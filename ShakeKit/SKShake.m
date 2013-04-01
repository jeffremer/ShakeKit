//
//  SKShake.m
//  ShakeKit
//
//  Created by Justin Williams on 5/28/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import "SKShake.h"
#import "SKUser.h"
#import "NSDate+DateConversion.h"

SKShakeType ConvertStringToShakeType(NSString *shakeType)
{
  SKShakeType convertedType = SKShakeTypeUnknown;
  
  if ([shakeType isEqualToString:@"user"])
  {
    convertedType = SKShakeTypeUser;
  }
  
  return convertedType;
}

static NSString * const kShakeID = @"id";
static NSString * const kShakeName = @"name";
static NSString * const kShakeDescription = @"description";
static NSString * const kShakeUser = @"user";
static NSString * const kShakeURL = @"url";
static NSString * const kShakeCreatedAt = @"created_at";
static NSString * const kShakeThumbnailURL = @"thumbnail_url";
static NSString * const kShakeType = @"type";
static NSString * const kShakeUpdatedAt = @"updated_at";

@implementation SKShake

@synthesize shakeID;
@synthesize title;
@synthesize shakeDescription;
@synthesize owner;
@synthesize shakeURL;
@synthesize creationDate;
@synthesize thumbnailURL;
@synthesize type;
@synthesize lastUpdatedDate;

- (id)initWithDictionary:(NSDictionary *)theDictionary
{
  if ((self = [super init]))
  {
    shakeID = [[theDictionary valueForKey:kShakeID] integerValue];
    title = [[theDictionary objectForKey:kShakeName] copy];
    shakeDescription = [[theDictionary objectForKey:kShakeDescription] copy];      
    owner = [[SKUser alloc] initWithDictionary:[theDictionary objectForKey:@"user"]];    
    shakeURL = [theDictionary objectForKey:kShakeURL];
    creationDate = ConvertStringToDate([theDictionary objectForKey:kShakeCreatedAt]);
    thumbnailURL = [theDictionary objectForKey:kShakeThumbnailURL];
    type = ConvertStringToShakeType([theDictionary valueForKey:kShakeType]);
    lastUpdatedDate = ConvertStringToDate([theDictionary objectForKey:kShakeUpdatedAt]);
  }
  
  return self;
}

#pragma mark -
#pragma mark Memory Management
// +--------------------------------------------------------------------
// | Memory Management
// +--------------------------------------------------------------------


@end
