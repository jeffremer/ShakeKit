//
//  ShakeKit.h
//  ShakeKit
//
//  Created by Justin Williams on 5/20/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@class SKShake;
@class SKUser;

typedef void (^SKCompletionHandler)(id response, NSError *error);

@interface ShakeKit : AFHTTPClient

@property (copy) NSString *applicationKey;
@property (copy) NSString *applicationSecret;

/**
 Initialize an instance of ShakeKit using the credential you get from applying at this URL:
 http://mlkshk.com/developers/apps
 */
- (id)initWithApplicationKey:(NSString *)key secret:(NSString *)secret;

/**
 Logs in as the user with the given email/password and stores the OAuth tokens returned.
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password withCompletionHandler:(SKCompletionHandler)handler;

/**
 Returns favorites
 */
- (void)loadFavoritesWithCompletionHandler:(SKCompletionHandler)handler;

/**
 Returns favorite files before shared file GJI
 */
- (void)loadFavoritesBeforeKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler;

/**
 Returns favorite files after shared file GJI
 */
- (void)loadFavoritesAfterKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler;

/**
 Returns friend timeline
 */
- (void)loadFriendsTimelineWithCompletionHandler:(SKCompletionHandler)handler;

/**
 Returns files from friend timeline before shared file GJI
 */
- (void)loadFriendsTimelineBeforeKey:(NSString *)key completionHandler:(SKCompletionHandler)handler;

/**
 Returns files from friend timeline after shared file GJI
 */
- (void)loadFriendsTimelineAfterKey:(NSString *)key completionHandler:(SKCompletionHandler)handler;

/**
 Returns magic files
 */
- (void)loadMagicFilesWithCompletionHandler:(SKCompletionHandler)handler;

/**
 Returned the shared file with the given share key (e.g., GJ1)
 */
- (void)loadSharedFileWithKey:(NSString *)key completionHandler:(SKCompletionHandler)handler;

/**
 Returned information about a user with a given user ID
 */
- (void)loadProfileForUserWithID:(NSInteger)userID completionHandler:(SKCompletionHandler)handler;

/**
 Returned information about a user with a given user ID
 */
- (void)loadProfileForUser:(SKUser *)user completionHandler:(SKCompletionHandler)handler;

/**
 Returned information about a user with a given screen name
 */
- (void)loadProfileForUserWithName:(NSString *)screenName completionHandler:(SKCompletionHandler)handler;

/**
 Returns data about the currently authenticated user
 */
- (void)loadProfileForCurrentlyAuthenticatedUserWithCompletionHandler:(SKCompletionHandler)handler;

/**
 Returns the shakes the currently authenticated user can post to
 */
- (void)loadShakesWithCompletionHandler:(SKCompletionHandler)handler;

/**
 POST a multipart/form-data containing the file information in field called "file".
 Optionally, include an SKShake to post to a shake other than the currently authenticated user's user shake.
 */

- (void)uploadFileFromLocalPath:(NSURL *)localPath toShake:(SKShake *)shake progress:(void (^)(float progress))progressBlock completionHandler:(SKCompletionHandler)handler;


@end
