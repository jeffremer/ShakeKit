//
//  SKShake.h
//  ShakeKit
//
//  Created by Justin Williams on 5/28/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{  
  SKShakeTypeUser,  // User created shake type.
  SKShakeTypeGroup,  // Foo?
  SKShakeTypeUnknown,
} SKShakeType;

@class SKUser;

@interface SKShake : NSObject 

@property (assign) NSInteger shakeID;;
@property (copy) NSString *title;
@property (copy) NSString *shakeDescription;
@property (strong) SKUser *owner;
@property (strong) NSURL *shakeURL;
@property (strong) NSDate *creationDate;
@property (strong) NSURL *thumbnailURL;
@property (assign) SKShakeType type;
@property (strong) NSDate *lastUpdatedDate;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
