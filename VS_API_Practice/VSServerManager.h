//
//  VSServerManager.h
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VSUser;
@class VSGroup;
@class VSAccessToken;

@interface VSServerManager : NSObject

@property (strong, nonatomic) VSUser *owner;
@property (strong, nonatomic) VSAccessToken *accessToken;

+ (VSServerManager*)sharedManager;

- (void)loadSettings;

- (void) autorizeUser:(void(^)(VSUser *user))complition;

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(VSUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getFriendsForUser:(NSString*)userID
                     limit:(NSInteger)count
                withOffset:(NSInteger)offset
                 onSuccess:(void(^)(NSArray *friendsArray))success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void) getGroupsForUser:(NSString*)userID
                     limit:(NSInteger)count
                withOffset:(NSInteger)offset
                 onSuccess:(void(^)(NSArray *groupsArray))success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void) getGroupByID:(NSString*)groupID
                onSuccess:(void(^)(VSGroup *group))success
                onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void) getFollowersOfUser:(NSString*)userID
                     limit:(NSInteger)count
                withOffset:(NSInteger)offset
                 onSuccess:(void(^)(NSArray *followersArray))success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void) getSubscriptionsForUser:(NSString*)userID
                     limit:(NSInteger)count
                withOffset:(NSInteger)offset
                 onSuccess:(void(^)(NSArray *subscriptionsArray))success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void) getWallPost:(NSString*)groupID
               limit:(NSInteger)count
          withOffset:(NSInteger)offset
          withFilter:(NSString*)filter
             inGroup:(BOOL)isGroup
           onSuccess:(void(^)(NSArray *postsArray, NSString *count))success
           onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void) getAllUserPhotos:(NSString*)userID
                    limit:(NSInteger)count
                 forGroup:(BOOL)isGroup
               withOffset:(NSInteger)offset
                onSuccess:(void(^)(NSArray *photosArray))success
                onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void) getUserAlbums:(NSString*)userID
             onSuccess:(void(^)(NSArray *albumsArray))success
             onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)postTextOnWall:(NSString*)text
           wallOwnerID:(NSString*)ownerID
               inGroup:(BOOL)isGroup
             onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)sendMessage:(NSString*)text
           toUser:(NSString*)userID
             onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getHistoryOfMessagesByUser:(NSString*)userId
                             limit:(NSInteger)count
                         onSuccess:(void(^)(NSArray *messagesArray))success
                         onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

@end
