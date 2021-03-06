//
//  OAuthCore.m
//
//  Created by Loren Brichter on 6/9/10.
//  Copyright 2010 Loren Brichter. All rights reserved.
//

#import "OAuthCore.h"
#import "OAuth+Additions.h"
#import "NSData+Base64.h"
#import <CommonCrypto/CommonHMAC.h>

static NSData *HMAC_SHA1(NSString *data, NSString *key) {
	unsigned char buf[CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, [key UTF8String], [key length], [data UTF8String], [data length], buf);
	return [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
}

extern NSString *OAuth2Header(NSURL *url,
                              NSString *method,
                              NSInteger port,
                              NSString *_oAuthToken,
                              NSString *_oAuthTokenSecret)
{
	NSString *oAuth2Nonce = [NSString ab_GUID];
	NSString *oAuth2Timestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];

    NSMutableString *normalizedString = [[NSMutableString alloc] init];

    [normalizedString appendFormat:@"%@\n", _oAuthToken];
    [normalizedString appendFormat:@"%@\n", oAuth2Timestamp];
    [normalizedString appendFormat:@"%@\n", oAuth2Nonce];
    [normalizedString appendFormat:@"%@\n", method];
    [normalizedString appendFormat:@"%@\n", [url host]];
    [normalizedString appendFormat:@"%d\n", port];
    [normalizedString appendFormat:@"%@\n", [url path]];

    NSData *signature = HMAC_SHA1(normalizedString, _oAuthTokenSecret);
	NSString *base64Signature = [signature base64EncodedString];

    NSString *authorizationString = [NSString stringWithFormat:@"MAC token=\"%@\", timestamp=\"%@\", nonce=\"%@\", signature=\"%@\"", _oAuthToken, oAuth2Timestamp, oAuth2Nonce, base64Signature];
    
    return authorizationString;
}


