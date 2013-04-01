//
//  SKUser.m
//  ShakeKit
//
//  Created by Justin Williams on 5/28/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import "SKUser.h"

static NSString * const kUserID = @"id";
static NSString * const kUserName = @"name";
static NSString * const kUserProfileImageURL = @"profile_image_url";

@implementation SKUser

@synthesize userID;
@synthesize screenName;
@synthesize profileImageURL;

- (id)initWithDictionary:(NSDictionary *)theDictionary
{
  if ((self = [super init]))
  {
    userID = [[theDictionary objectForKey:kUserID] integerValue];
    screenName = [[theDictionary objectForKey:kUserName] copy];
    profileImageURL = [theDictionary objectForKey:kUserProfileImageURL];
  }
  
  return self;
}

#pragma mark -
#pragma mark Memory Management
// +--------------------------------------------------------------------
// | Memory Management
// +--------------------------------------------------------------------


@end
