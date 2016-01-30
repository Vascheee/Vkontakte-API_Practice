//
//  VSServerManager.m
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSServerManager.h"
#import "AFNetworking.h"
#import "VSLoginVC.h"
#import "VSAccessToken.h"
#import "VSUser.h"
#import "VSPost.h"
#import "VSGroup.h"
#import "VSPhoto.h"
#import "VSUserPhotoAlbum.h"
#import "VSMessage.h"

@interface VSServerManager ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation VSServerManager

static NSString* kOwner          = @"kOwner";
static NSString* kToken          = @"kToken";
static NSString* kUserID         = @"kUserID";
static NSString* kExpirationDate = @"kExpirationDate";


+ (VSServerManager*)sharedManager {
    
    static VSServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VSServerManager alloc] init];
    });
    return manager;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        self.accessToken = [VSAccessToken new];
        [self loadSettings];
    }
    return self;
}


#pragma mark - UserDefaults
/*=================================================================================================*/

- (void)saveSettings:(VSAccessToken *)token {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:token.token          forKey:kToken];
    [userDefaults setObject:token.userID         forKey:kUserID];
    [userDefaults setObject:token.expirationDate forKey:kExpirationDate];
    [userDefaults synchronize];
}


- (void)loadSettings {
    
    NSUserDefaults* userDefaults    = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:kToken];
    [userDefaults removeObjectForKey:kUserID];
    [userDefaults removeObjectForKey:kExpirationDate];

    self.accessToken.token          = [userDefaults objectForKey:kToken];
    self.accessToken.userID         = [userDefaults objectForKey:kUserID];
    self.accessToken.expirationDate = [userDefaults objectForKey:kExpirationDate];
 
}



#pragma mark - API methods
/*=================================================================================================*/

// AUTORIZE:

- (void) autorizeUser:(void(^)(VSUser *user))complition {
    
    VSLoginVC *loginVC = [[VSLoginVC alloc] initWithComplitionBlock:^(VSAccessToken *token) {
        if (token) {
            [self saveSettings:token];
            self.accessToken = token;
            [self getUser:self.accessToken.userID
                onSuccess:^(VSUser *user) {
                    self.owner = user;
                    if (complition) {
                        complition(user); }
                }
                onFailure:^(NSError *error, NSInteger statusCode) {
                    if (complition) {
                        complition(nil); }
                }];
        } else if (complition) {
            complition(nil); }
    }];
    UINavigationController *navC = [[UINavigationController alloc]
                                    initWithRootViewController:loginVC];
    UIViewController *mainVC = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    [mainVC presentViewController:navC animated:YES completion:nil];
}


// GET:

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(VSUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =  @{@"user_ids": userID,
                              @"fields": @"photo_200,city, bdate, online, photo_100",
                              @"name_case":                               @"nom",
                              @"v":                                       @"5.37"};
    
    [self.requestOperationManager GET:@"users.get"
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  NSArray* dictsArray = responseObject[@"response"];
                                  if (dictsArray.count > 0) {
                                      VSUser* user = [[VSUser alloc] initWithServerResponse:dictsArray.firstObject];
                                      if (success) {
                                          success(user);  }
                                  } else {
                                      if (failure) {
                                          failure(nil, operation.response.statusCode); }
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}



- (void) getFriendsForUser:(NSString*)userID
                     limit:(NSInteger)count
                withOffset:(NSInteger)offset
                 onSuccess:(void(^)(NSArray *friendsArray))success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *dict =    @{@"user_id": userID,
                            @"order":        @"name",
                            @"offset":       @(offset),
                            @"fields":       @"photo_100, online",
                            @"name_case":    @"nom"};
    
    [self.requestOperationManager GET:@"friends.get"
                           parameters:dict
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSArray * dictionaryArray = responseObject[@"response"];
                                  NSMutableArray *friendsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary *dict in dictionaryArray) {
                                      VSUser *friend = [[VSUser alloc] initWithServerResponse:dict];
                                      [friendsArray addObject:friend];
                                  }
                                  if (success) {
                                      success(friendsArray);
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}


- (void) getGroupByID:(NSString*)groupID
            onSuccess:(void(^)(VSGroup *group))success
            onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
  

    NSDictionary *dict =  @{@"group_ids":          groupID,
                            @"extended":           @(1),
                            @"v":                  @"5.40",
                            @"access_token":       self.accessToken.token,
                            @"fields":             @"status, members_count, photo_200, id, name, links,"
                            "description, counters"};
    
    [self.requestOperationManager GET:@"groups.getById"
                           parameters:dict
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSArray * dictionaryArray = responseObject [@"response"];
                                  NSMutableArray *friendsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary *dict in dictionaryArray) {
                                      VSGroup *group = [[VSGroup alloc] initWithServerResponse:dict];
                                      [friendsArray addObject:group];
                                      if (success) {
                                          success(group);
                                      }
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode); }
                              }];
}


- (void)getGroupsForUser:(NSString *)userID
                   limit:(NSInteger)count
              withOffset:(NSInteger)offset
               onSuccess:(void (^)(NSArray *groupsArray))success
               onFailure:(void (^)(NSError *, NSInteger))failure {
    
    NSDictionary *dict =  @{@"user_id":            userID,
                            @"offset":             @(offset),
                            @"extended":           @(1),
                            @"v":                  @"5.37",
                            @"access_token":       self.accessToken.token,
                            @"fields":             @"photo_100, photo_200, id, name, links,"
                            "description,          counters, members_count"};
    
    [self.requestOperationManager GET:@"groups.get"
                           parameters:dict
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSArray * dictionaryArray = responseObject [@"response"][@"items"];
                                  NSMutableArray *friendsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary *dict in dictionaryArray) {
                                      VSGroup *friend = [[VSGroup alloc] initWithServerResponse:dict];
                                      [friendsArray addObject:friend];
                                  }
                                  if (success) {
                                      success(friendsArray);
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode); }
                              }];
}


- (void) getFollowersOfUser:(NSString*)userID
                      limit:(NSInteger)count
                 withOffset:(NSInteger)offset
                  onSuccess:(void(^)(NSArray *followersArray))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *dict =  @{@"user_id":   userID,
                            @"order":     @"name",
                            @"count":     @(count),
                            @"offset":    @(offset),
                            @"fields":    @"photo_100",
                            @"name_case": @"nom",
                            @"v":         @"5.37"};
    
    [self.requestOperationManager GET:@"users.getFollowers"
                           parameters:dict
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSArray * dictionaryArray = responseObject[@"response"][@"items"];
                                  NSMutableArray *friendsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary *dict in dictionaryArray) {
                                      if (dict[@"first_name"]) {
                                          VSUser *friend = [[VSUser alloc] initWithProfile:dict];
                                          [friendsArray addObject:friend];
                                      } else {
                                          VSGroup *group = [[VSGroup alloc] initWithServerResponse:dict];
                                          [friendsArray addObject:group]; }
                                  }
                                  if (success) {
                                      success(friendsArray);
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];

}

- (void) getSubscriptionsForUser:(NSString*)userID
                           limit:(NSInteger)count
                      withOffset:(NSInteger)offset
                       onSuccess:(void(^)(NSArray *subscriptionsArray))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *dict = @{ @"user_id": userID,
                            @"order":     @"name",
                            @"count":     @(count),
                            @"offset":    @(offset),
                            @"fields":    @"photo_100",
                            @"name_case": @"nom",
                            @"extended":  @(1),
                            @"v":         @"5.37"};
    
    [self.requestOperationManager GET:@"users.getSubscriptions"
                           parameters:dict
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSArray * dictionaryArray = responseObject[@"response"][@"items"];
                                  NSMutableArray *friendsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary *dict in dictionaryArray) {
                                      if (dict[@"first_name"]) {
                                          VSUser *friend = [[VSUser alloc] initWithServerResponse:dict];
                                          [friendsArray addObject:friend];
                                      } else {
                                      VSGroup *group = [[VSGroup alloc] initWithServerResponse:dict];
                                          [friendsArray addObject:group]; }
                                  }
                                  if (success) {
                                      success(friendsArray);
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];

}

- (void) getWallPost:(NSString*)groupID
               limit:(NSInteger)count
          withOffset:(NSInteger)offset
          withFilter:(NSString*)filter
             inGroup:(BOOL)isGroup
           onSuccess:(void(^)(NSArray *postArray, NSString *count))success
           onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSNumber *ownerID = [NSNumber numberWithInteger:(groupID.integerValue)];
    if (isGroup) {
        ownerID = @(-groupID.integerValue); }

    NSDictionary *dict = @{ @"owner_id":     ownerID,
                            @"order":        @"name",
                            @"count":        @(count),
                            @"offset":       @(offset),
                            @"filter":       filter,
                            @"extended":     @(1),
                            @"v":            @"5.37",
                            @"access_token": self.accessToken.token};
    
    [self.requestOperationManager GET:@"wall.get"
                           parameters:dict
                              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                  
                                  NSDictionary *wallPostDict = responseObject[@"response"];
                                  NSArray *wallPosts = wallPostDict[@"items"];
                                  NSMutableArray *postArray = [NSMutableArray array];
                                  
                                  for(NSDictionary *anyWallPost in wallPosts) {
                                      
                                      NSMutableDictionary *anyWallPostMDictionary =
                                      [NSMutableDictionary dictionaryWithDictionary:wallPostDict];
                                      
                                      [anyWallPostMDictionary removeObjectForKey:@"items"];
                                      anyWallPostMDictionary[@"items"] = anyWallPost;
                                      
                                      VSPost *wallPost = [[VSPost alloc] initWithServerResponse:anyWallPostMDictionary];
                                      [postArray addObject:wallPost];

                                  }
                                  if (success) {
                                      success(postArray, [NSString stringWithFormat:@"%@", wallPostDict[@"count"]]);
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}


- (void) getAllUserPhotos:(NSString*)userID
                    limit:(NSInteger)count
                 forGroup:(BOOL)isGroup
               withOffset:(NSInteger)offset
                onSuccess:(void(^)(NSArray *photosArray))success
                onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {

  
    if (isGroup) {
        NSString *newID = [NSString stringWithFormat:@"%@", userID];
        userID = [@"-" stringByAppendingString:newID]; }
    
    NSDictionary *dict = @{ @"owner_id":    userID,
                            @"need_covers": @(1),
                            @"v":           @"5.40",
                            @"extended":    @(1),
                            @"offset":      @(offset),
                            @"count":       @(count),
                            @"no_service_albums": @(1),
                            @"access_token": self.accessToken.token };
    
    [self.requestOperationManager GET:@"photos.getAll"
                           parameters:dict
                              success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
                                  NSArray * dictionaryArray = responseObject[@"response"][@"items"];
                                  NSMutableArray *photoArray = [NSMutableArray array];
                                 // NSLog(@"%@", dictionaryArray);
                                  for (NSDictionary *dict in dictionaryArray) {
                                      VSPhoto *album = [[VSPhoto alloc]
                                                                 initWithServerResponse:dict];
                                      [photoArray addObject:album];
                                  }
                                  if (success) {
                                      success(photoArray);
                                  }
                              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode); }
                              }];
}


- (void) getUserAlbums:(NSString*)userID
             onSuccess:(void(^)(NSArray *albumsArray))success
             onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *dict = @{ @"owner_id": userID,
                            @"need_covers": @(1),
                            @"v":           @"5.40"};
    
    [self.requestOperationManager GET:@"photos.getAlbums"
                           parameters:dict
                              success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
                                  NSArray * dictionaryArray = responseObject[@"response"][@"items"];
                                  NSMutableArray *albumsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary *dict in dictionaryArray) {
                                      VSUserPhotoAlbum *album = [[VSUserPhotoAlbum alloc]
                                                                 initWithServerResponse:dict];
                                      [albumsArray addObject:album]; }
                                  if (success) {
                                      success(albumsArray); }
                              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode); }
                              }];
}


- (void)getHistoryOfMessagesByUser:(NSString*)userId
                             limit:(NSInteger)count
                         onSuccess:(void(^)(NSArray *messagesArray))success
                         onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *dict = @{@"user_id": userId,
                           @"count": @(count),
                           @"access_token": self.accessToken.token};
    
    [self.requestOperationManager GET:@"messages.getHistory"
                           parameters:dict
                              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                  
                                  NSArray * dictionaryArray = responseObject[@"response"];
                                  NSMutableArray *array = [NSMutableArray array];
                                  for (id obj in dictionaryArray) {
                                      if ([obj isKindOfClass:[NSDictionary class]]) {
                                          VSMessage *message = [[VSMessage alloc] initWithServerResponse:obj];
                                          [array addObject:message]; }
                                  }
                                  if (success) {
                                      success(array); }
                              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode); }
                              }];
}


//POST:

- (void)postTextOnWall:(NSString*)text
           wallOwnerID:(NSString*)ownerID
               inGroup:(BOOL)isGroup
             onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {

    NSNumber *owner = [NSNumber numberWithInteger:(ownerID.integerValue)];
    if (isGroup) {
        owner = @(-ownerID.integerValue); }
    
    NSDictionary *dict = @{@"owner_id": ownerID,
                           @"message": text,
                           @"access_token": self.accessToken.token};
    
    [self.requestOperationManager POST:@"wall.post"
                            parameters:dict
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"Error: %@", error);
                                   if (failure) {
                                       failure(error, operation.response.statusCode);
                                   }
                               }];
}


- (void)sendMessage:(NSString*)text
             toUser:(NSString*)userID
          onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *dict = @{@"user_id": userID,
                           @"message": text,
                           @"access_token": self.accessToken.token};
    
    [self.requestOperationManager POST:@"messages.send"
                            parameters:dict
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"Error: %@", error);
                                   if (failure) {
                                       failure(error, operation.response.statusCode);
                                   }
                               }];

}





@end

