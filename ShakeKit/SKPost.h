//
//  SKPost.h
//  ShakeKit
//
//  Created by Justin Williams on 5/28/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKUser;

@interface SKPost : NSObject 

@property (copy) NSString *title;
@property (copy) NSString *fileName;
@property (copy) NSString *fileDescription;
@property (strong) SKUser *user;
@property (strong) NSDate *postDate;
@property (strong) NSURL *permalink;
@property (strong) NSURL *originalImageURL;
@property (assign) NSInteger height;
@property (assign) NSInteger width;
@property (assign) NSInteger views;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
