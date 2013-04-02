//
//  OAuthCore.h
//
//  Created by Loren Brichter on 6/9/10.
//  Copyright 2010 Loren Brichter. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *OAuth2Header(NSURL *url,
                              NSString *method,
                              NSInteger port,
                              NSString *_oAuthToken,
                              NSString *_oAuthTokenSecret);
