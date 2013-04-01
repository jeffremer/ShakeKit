//
//  SKUser.h
//  ShakeKit
//
//  Created by Justin Williams on 5/28/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKUser : NSObject 

@property (assign) NSInteger userID;
@property (copy) NSString *screenName;
@property (strong) NSURL *profileImageURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
