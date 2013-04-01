//
//  SKPost.m
//  ShakeKit
//
//  Created by Justin Williams on 5/28/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import "SKPost.h"
#import "SKUser.h"
#import "NSDate+DateConversion.h"

static NSString * const kPostTitle = @"title";
static NSString * const kPostName = @"name";
static NSString * const kPostDescription = @"description";
static NSString * const kPostedAt = @"posted_at";
static NSString * const kPostPermalinkPage = @"permalink_page";
static NSString * const kPostOriginalImageURL = @"original_image_url";
static NSString * const kPostHeight = @"height";
static NSString * const kPostWidth = @"width";
static NSString * const kPostViews = @"views";

@implementation SKPost

@synthesize title;
@synthesize fileName;
@synthesize fileDescription;
@synthesize user;
@synthesize postDate;
@synthesize permalink;
@synthesize originalImageURL;
@synthesize height;
@synthesize width;
@synthesize views;

- (id)initWithDictionary:(NSDictionary *)theDictionary
{
  if ((self = [super init]))
  {
    title = [[theDictionary objectForKey:kPostTitle] copy];
    fileName = [[theDictionary objectForKey:kPostName] copy];
    fileDescription = [[theDictionary objectForKey:kPostDescription] copy];      
    user = [[SKUser alloc] initWithDictionary:[theDictionary objectForKey:@"user"]];
    postDate = ConvertStringToDate([theDictionary objectForKey:kPostedAt]);
    permalink = [theDictionary objectForKey:kPostPermalinkPage];
    originalImageURL = [theDictionary objectForKey:kPostOriginalImageURL];
    height = [[theDictionary valueForKey:kPostHeight] integerValue];
    width = [[theDictionary valueForKey:kPostWidth] integerValue];
    views = [[theDictionary valueForKey:kPostViews] integerValue];
  }
  
  return self;
}

#pragma mark -
#pragma mark Memory Management
// +--------------------------------------------------------------------
// | Memory Management
// +--------------------------------------------------------------------


@end
