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
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;

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

    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"/token" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:JSON[@"access_token"] forKey:kOAuthAccessToken];
        [defaults setObject:JSON[@"secret"] forKey:kOAuthAccessSecret];
        [defaults synchronize];
        theHandler(JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        theHandler(nil, error);
    }];
    [self.queue addOperation:operation];
}

- (void)loadFavoritesWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/favorites";
    [self loadArrayOfClass:[SKPost class] key:@"favorites" path:path completionHandler:handler];
}

- (void)loadFavoritesBeforeKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/favorites/before/%@", theKey];
    [self loadArrayOfClass:[SKPost class] key:@"favorites" path:path completionHandler:handler];
}

- (void)loadFavoritesAfterKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/favorites/after/%@", theKey];
    [self loadArrayOfClass:[SKPost class] key:@"favorites" path:path completionHandler:handler];
}

- (void)loadFriendsTimelineWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/friends";
    [self loadArrayOfClass:[SKPost class] key:@"friend_shake" path:path completionHandler:handler];
}

- (void)loadFriendsTimelineBeforeKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/friends/before/%@", theKey];
    [self loadArrayOfClass:[SKPost class] key:@"friend_shake" path:path completionHandler:handler];
}

- (void)loadFriendsTimelineAfterKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/friends/after/%@", theKey];
    [self loadArrayOfClass:[SKPost class] key:@"friend_shake" path:path completionHandler:handler];
}

- (void)loadMagicFilesWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/magicfiles";
    [self loadArrayOfClass:[SKPost class] key:@"magicfiles" path:path completionHandler:handler];
}

- (void)loadSharedFileWithKey:(NSString *)theKey completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/sharedfile/%@", theKey];
    [self loadObjectOfClass:[SKPost class] path:path completionHandler:handler];
}

- (void)loadProfileForUserWithID:(NSInteger)theUserID completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/user_id/%ld", (long)theUserID];
    [self loadObjectOfClass:[SKUser class] path:path completionHandler:handler];
}

- (void)loadProfileForUserWithName:(NSString *)theScreenName completionHandler:(SKCompletionHandler)handler
{
    NSString *path = [NSString stringWithFormat:@"/user_name/%@", theScreenName];
    [self loadObjectOfClass:[SKUser class] path:path completionHandler:handler];
}

- (void)loadProfileForUser:(SKUser *)theUser completionHandler:(SKCompletionHandler)handler
{
    [self loadProfileForUserWithID:theUser.userID completionHandler:handler];
}

- (void)loadProfileForCurrentlyAuthenticatedUserWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/user";
    [self loadObjectOfClass:[SKUser class] path:path completionHandler:handler];
}

- (void)loadShakesWithCompletionHandler:(SKCompletionHandler)handler
{
    NSString *path = @"/shakes";
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

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", kSKProtocolHTTPS, kSKMlkShkAPIHost]];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (theShake) {
        params[@"shake_id"] = @(theShake.shakeID);
    }

    NSData *data = [NSData dataWithContentsOfURL:theLocalPath];
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:kSKMethodPOST path:@"/upload" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:[theLocalPath relativeString] mimeType:@"image/png"];
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kOAuthAccessToken];
    NSString *secret = [defaults objectForKey:kOAuthAccessSecret];

    NSString *header = OAuth2Header(url, kSKMethodPOST, 80, self.applicationKey, self.applicationSecret, token, secret);
    [request setValue:@"Authorization" forHTTPHeaderField:header];

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

    [self.queue addOperation:operation];
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (AFJSONRequestOperation *)operationWithPath:(NSString *)path method:(NSString*)method
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kOAuthAccessToken];
    NSString *secret = [defaults objectForKey:kOAuthAccessSecret];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", kSKProtocolHTTPS, kSKMlkShkAPIHost, path]];
    NSString *header = OAuth2Header(url, method, 80, self.applicationKey, self.applicationSecret, token, secret);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    [request setValue:@"Authorization" forHTTPHeaderField:header];

    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    return operation;
}

- (void)loadObjectOfClass:(Class)aClass path:(NSString*)path completionHandler:(SKCompletionHandler)handler
{
    AFJSONRequestOperation *operation = [self operationWithPath:path method:kSKMethodGET];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id object = [[aClass alloc] initWithDictionary:responseObject];
        handler(object, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];

    [self.queue addOperation:operation];
}

- (void)loadArrayOfClass:(Class)aClass key:(NSString*)key path:(NSString*)path completionHandler:(SKCompletionHandler)handler
{
    AFJSONRequestOperation *operation = [self operationWithPath:path method:kSKMethodGET];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[key]) {
            id object = [[aClass alloc] initWithDictionary:dict];
            [objects addObject:object];
        }
        handler(objects, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
    
    [self.queue addOperation:operation];
}
@end
