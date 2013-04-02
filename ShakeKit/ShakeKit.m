//
//  ShakeKit.m
//  ShakeKit
//
//  Created by Justin Williams on 5/20/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import "ShakeKit.h"

#import "ShakeKitConstants.h"
#import "OAuthCore.h"
#import "OAuth+Additions.h"
#import "NSDictionary+ParameterString.h"
#import "NSString+URIEscaping.h"
#import "SKPost.h"
#import "SKUser.h"
#import "SKShake.h"

@implementation ShakeKit

- (id)initWithApplicationKey:(NSString *)theKey secret:(NSString *)theSecret
{

    if ((self = [super initWithBaseURL:[NSURL URLWithString:@"https://mlkshk.com"]])) {
        _applicationKey = theKey;
        _applicationSecret = theSecret;
    }

    return self;
}


#pragma mark -
#pragma mark Instance Methods
// +--------------------------------------------------------------------
// | Instance Methods
// +--------------------------------------------------------------------

- (void)loginWithUsername:(NSString *)theUsername password:(NSString *)thePassword withCompletionHandler:(SKCompletionHandler)theHandler
{
    NSDictionary *params = @{
        @"username" : theUsername,
        @"password" : thePassword,
        @"client_id" : self.applicationKey,
        @"client_secret" : self.applicationSecret,
        @"grant_type" : @"password"
    };

    [self postPath:@"/api/token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSError *error = nil;
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];

        if (error) {
            theHandler(nil, error);
        } else {
            [defaults setObject:JSON[@"access_token"] forKey:kOAuthAccessToken];
            [defaults setObject:JSON[@"secret"] forKey:kOAuthAccessSecret];
            [defaults synchronize];
            theHandler(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        theHandler(nil, error);
    }];
}

- (void)loadFavoritesWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/api/favorites";
    [self loadArrayOfClass:[SKPost class] key:@"favorites" path:path completionHandler:handler];
}

- (void)loadFavoritesBeforeKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/api/favorites/before/%@", theKey];
    [self loadArrayOfClass:[SKPost class] key:@"favorites" path:path completionHandler:handler];
}

- (void)loadFavoritesAfterKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/api/favorites/after/%@", theKey];
    [self loadArrayOfClass:[SKPost class] key:@"favorites" path:path completionHandler:handler];
}

- (void)loadFriendsTimelineWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/api/friends";
    [self loadArrayOfClass:[SKPost class] key:@"friend_shake" path:path completionHandler:handler];
}

- (void)loadFriendsTimelineBeforeKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/api/friends/before/%@", theKey];
    [self loadArrayOfClass:[SKPost class] key:@"friend_shake" path:path completionHandler:handler];
}

- (void)loadFriendsTimelineAfterKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/api/friends/after/%@", theKey];
    [self loadArrayOfClass:[SKPost class] key:@"friend_shake" path:path completionHandler:handler];
}

- (void)loadMagicFilesWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/api/magicfiles";
    [self loadArrayOfClass:[SKPost class] key:@"magicfiles" path:path completionHandler:handler];
}

- (void)loadSharedFileWithKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/api/sharedfile/%@", theKey];
    [self loadObjectOfClass:[SKPost class] path:path completionHandler:handler];
}

- (void)loadProfileForUserWithID:(NSInteger)theUserID completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/api/user_id/%ld", (long)theUserID];
    [self loadObjectOfClass:[SKUser class] path:path completionHandler:handler];
}

- (void)loadProfileForUserWithName:(NSString *)theScreenName completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/api/user_name/%@", theScreenName];
    [self loadObjectOfClass:[SKUser class] path:path completionHandler:handler];
}

- (void)loadProfileForUser:(SKUser *)theUser completionHandler:(SKCompletionHandler)handler
{
    [self loadProfileForUserWithID:theUser.userID completionHandler:handler];
}

- (void)loadProfileForCurrentlyAuthenticatedUserWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/api/user";
    [self loadObjectOfClass:[SKUser class] path:path completionHandler:handler];
}

- (void)loadShakesWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/api/shakes";
    [self loadArrayOfClass:[SKShake class] key:@"shakes" path:path completionHandler:handler];
}

- (void)uploadFileFromLocalPath:(NSURL *)theLocalPath toShake:(SKShake *)theShake progress:(void (^)(float))progressBlock completionHandler:(SKCompletionHandler)handler
{
    if ((![[NSFileManager defaultManager] fileExistsAtPath:[theLocalPath path]]))
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theLocalPath forKey:@"localPath"];
        NSError *error = [NSError errorWithDomain:SKShakeErrorDomain code:SKShakeErrorFileNotFound userInfo:userInfo];
        handler(nil, error);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (theShake) {
        params[@"shake_id"] = @(theShake.shakeID);
    }

    NSData *data = [NSData dataWithContentsOfURL:theLocalPath];
    NSString *path = @"/api/upload";
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:kSKMethodPOST path:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:[theLocalPath relativeString] mimeType:@"image/png"];
    }];

    [request setValue:@"Authorization" forHTTPHeaderField:[self authorizationHeaderWithPath:path method:kSKMethodPOST]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float progress = ((float)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (error == nil) {
            handler(nil, error);
        } else {
            handler(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (NSString *)authorizationHeaderWithPath:(NSString *)path method:(NSString*)method
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kOAuthAccessToken];
    NSString *secret = [defaults objectForKey:kOAuthAccessSecret];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", kSKProtocolHTTPS, kSKMlkShkAPIHost, path]];
    NSString *header = OAuth2Header(url, method, 80, token, secret);
    return header;
}

- (void)loadObjectOfClass:(Class)aClass path:(NSString*)path completionHandler:(SKCompletionHandler)handler
{
    NSString *header = [self authorizationHeaderWithPath:path method:kSKMethodGET];
    [self setDefaultHeader:header value:@"Authorization"];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id object = [[aClass alloc] initWithDictionary:responseObject];
        handler(object, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}

- (void)loadArrayOfClass:(Class)aClass key:(NSString*)key path:(NSString*)path completionHandler:(SKCompletionHandler)handler
{
    NSString *header = [self authorizationHeaderWithPath:path method:kSKMethodGET];
    [self setDefaultHeader:header value:@"Authorization"];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[key]) {
            id object = [[aClass alloc] initWithDictionary:dict];
            [objects addObject:object];
        }
        handler(objects, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}
@end
