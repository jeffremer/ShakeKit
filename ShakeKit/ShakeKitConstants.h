//
//  ShakeKitConstants.h
//  ShakeKit
//
//  Created by Justin Williams on 5/20/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

// Error codes in the dropbox.com domain represent the HTTP status code if less than 1000
typedef enum {
    SKShakeErrorNone = 0,
    SKShakeErrorFileNotFound = 404,
} SKShakeErrorCode;


extern NSString * const kSKProtocolHTTP;
extern NSString * const kSKProtocolHTTPS;

extern NSString * const kSKMethodGET;
extern NSString * const kSKMethodPOST;

extern NSString * const kSKMlkShkAPIHost;

extern NSString * const kOAuthAccessToken;
extern NSString * const kOAuthAccessSecret;

extern NSString * const SKShakeErrorDomain;