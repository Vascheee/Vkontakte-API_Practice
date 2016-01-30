//
//  VSPost.m
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSPost.h"
#import "VSUser.h"
#import "VSGroup.h"
#import "VSPhoto.h"



@implementation VSPost
/*
- (instancetype) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        NSDictionary *itemDictionary     = responseObject[@"items"];
        NSArray      *profilesArray      = responseObject[@"profiles"];
        NSArray      *groupsArray        = responseObject[@"groups"];
        NSArray      *repostOwner        = responseObject[@"items"][@"copy_history"];
        self.photoArrayInPost = [NSMutableArray new];

        if (repostOwner) {
            self.isRepostingRecord = YES;
            self.text  = [repostOwner firstObject][@"text"];
            NSDictionary *repostOwnerInfo = repostOwner.firstObject;
            NSNumber *fromUser = repostOwnerInfo[@"from_id"];
            if (fromUser.floatValue<0) {
                self.repostFromGroup = [self getGroupFromID:fromUser ofGroupsArray:groupsArray];
                self.repostOwnerImageString = self.repostFromGroup.smallPhotoStringUrl;
            } else {
                self.repostFromUser = [self takeOwnerOfWallPost:fromUser ofProfilesArray:profilesArray];
                self.repostOwnerImageString = self.repostFromUser.smallImageURLString;
            }
            NSArray *arrayAttachments = [repostOwner firstObject][@"attachments"];
           // NSLog(@"%@", arrayAttachments);
            for (NSDictionary *obj in arrayAttachments) {
                if ([obj[@"type"] isEqualToString:@"photo"]) {
                    NSDictionary *dict = obj[@"photo"];
                    VSPhoto *photo = [[VSPhoto alloc] initWithDictionary:dict];
                    [self.photoArrayInPost addObject:photo]; }
                if ([obj[@"type"] isEqualToString:@"video"]) {
                    NSDictionary *dict = obj[@"video"];
                    self.videoImageURL = dict[@"photo_800"];
                    self.videofileName = dict[@"title"];
                    if (!self.videoImageURL) {
                        self.videoImageURL = dict[@"photo_640"];
                    }
                    if (!self.videoImageURL) {
                        self.videoImageURL = dict[@"photo_320"];  }
                   }
            }
        } else {
            
            NSArray *arrayAttachments = itemDictionary[@"attachments"];
            for (NSDictionary *obj in arrayAttachments) {
                if ([obj[@"type"] isEqualToString:@"photo"]) {
                    NSDictionary *dict = obj[@"photo"];
                    VSPhoto *photo = [[VSPhoto alloc] initWithDictionary:dict];
                    [self.photoArrayInPost addObject:photo]; }
                if ([obj[@"type"] isEqualToString:@"video"]) {
                    NSDictionary *dict = obj[@"video"];
                    self.videoImageURL = dict[@"photo_800"];
                    self.videofileName = dict[@"title"];
                    if (!self.videoImageURL) {
                        self.videoImageURL = dict[@"photo_640"];
                    }
                    if (!self.videoImageURL) {
                        self.videoImageURL = dict[@"photo_320"];
                    }
                }
            }
        }
        self.text = itemDictionary[@"text"];
        self.isRepostingRecord = NO;
        self.text      = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.ownerID   = itemDictionary[@"owner_id"];
        self.postID    = itemDictionary[@"id"];
        self.likeCount = [itemDictionary[@"likes"][@"count"] integerValue];
        self.commentCount = [itemDictionary[@"comments"][@"count"] integerValue];

        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        dateFormater.dateFormat = @"dd MMM yyyy ";
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[itemDictionary[@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        self.date = date;
 
        NSNumber *fromUser =  itemDictionary[@"from_id"];
        if (fromUser.floatValue<0) {
            self.fromGroup = [self getGroupFromID:fromUser ofGroupsArray:groupsArray];
        } else {
        self.fromUser = [self takeOwnerOfWallPost:fromUser ofProfilesArray:profilesArray];
        }
    }
    [self postTypeDetermination];
    return self;
}
*/

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        NSDictionary *itemDictionary     = responseObject[@"items"];
        NSArray      *profilesArray      = responseObject[@"profiles"];
        NSArray      *groupsArray        = responseObject[@"groups"];
        NSArray      *repostOwner        = responseObject[@"items"][@"copy_history"];
        self.photoArrayInPost = [NSMutableArray new];
        
        if (repostOwner) {
            self.isRepostingRecord = YES;
            self.text  = [repostOwner firstObject][@"text"];
            NSDictionary *repostOwnerInfo = repostOwner.firstObject;
            NSNumber *fromUser = repostOwnerInfo[@"from_id"];
            if (fromUser.floatValue<0) {
                self.repostFromGroup = [self getGroupFromID:fromUser ofGroupsArray:groupsArray];
                self.repostOwnerImageString = self.repostFromGroup.smallPhotoStringUrl;
            } else {
                self.repostFromUser = [self takeOwnerOfWallPost:fromUser ofProfilesArray:profilesArray];
                self.repostOwnerImageString = self.repostFromUser.smallImageURLString;
            }
            NSArray *arrayAttachments = [repostOwner firstObject][@"attachments"];
            [self generateAttachmentsFromArray:arrayAttachments];
        } else {
            NSArray *arrayAttachments = itemDictionary[@"attachments"];
            [self generateAttachmentsFromArray:arrayAttachments];
        }
        self.isRepostingRecord = NO;
        self.text = itemDictionary[@"text"];
        self.text      = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.ownerID   = itemDictionary[@"owner_id"];
        self.postID    = itemDictionary[@"id"];
        self.likeCount = [itemDictionary[@"likes"][@"count"] integerValue];
        self.commentCount = [itemDictionary[@"comments"][@"count"] integerValue];
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        dateFormater.dateFormat = @"dd MMM yyyy ";
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[itemDictionary[@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        self.date = date;
        
        NSNumber *fromUser =  itemDictionary[@"from_id"];
        if (fromUser.floatValue<0) {
            self.fromGroup = [self getGroupFromID:fromUser ofGroupsArray:groupsArray];
        } else {
            self.fromUser = [self takeOwnerOfWallPost:fromUser ofProfilesArray:profilesArray];
        }
    }
    [self postTypeDetermination];
    return self;
}


- (void)generateAttachmentsFromArray:(NSArray*)array {
    for (NSDictionary *obj in array) {
        if ([obj[@"type"] isEqualToString:@"photo"]) {
            NSDictionary *dict = obj[@"photo"];
            VSPhoto *photo = [[VSPhoto alloc] initWithDictionary:dict];
            [self.photoArrayInPost addObject:photo]; }
        if ([obj[@"type"] isEqualToString:@"video"]) {
            NSDictionary *dict = obj[@"video"];
            self.videoImageURL = dict[@"photo_800"];
            self.videofileName = dict[@"title"];
            if (!self.videoImageURL) {
                self.videoImageURL = dict[@"photo_640"];
            }
            if (!self.videoImageURL) {
                self.videoImageURL = dict[@"photo_320"];
            }
        }
    }
}


    
- (void) postTypeDetermination {
    if (self.photoArrayInPost.count == 0) {
      self.postType = @"post_OnlyText";
    }
    if (!self.text && self.photoArrayInPost.count > 0) {
        self.postType = @"post_OnlyPhoto";
    }
    if (self.text && self.photoArrayInPost.count > 0) {
        self.postType = @"post_PhotoAndText";
    }
}


- (VSUser*)takeOwnerOfWallPost:(NSNumber*)userID ofProfilesArray:(NSArray *)profilesArray{
    
    VSUser *postFromUser;
    for(NSDictionary *anyProfileDictionary in profilesArray) {
        if([anyProfileDictionary[@"id"] isEqualToNumber:userID]) {
            postFromUser = [[VSUser alloc] initWithProfile:anyProfileDictionary];  }
    }
    return postFromUser;
}

- (VSGroup *)getGroupFromID:(NSNumber *)fromID ofGroupsArray:(NSArray *)groupsArray {
    
    VSGroup *postFromGroup;
    NSString *idString = fromID.stringValue;
    idString = [idString substringFromIndex:1];
    
    for(NSDictionary *anyGroupDictionary in groupsArray) {
        
        NSString * str = [NSString stringWithFormat:@"%@", anyGroupDictionary[@"id"]];
         if([str isEqualToString:idString]) {
            postFromGroup = [[VSGroup alloc] initWithGroupProfile:anyGroupDictionary];
        }
    }
    return postFromGroup;
}

@end


