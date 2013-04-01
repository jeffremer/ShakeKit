//
//  NSDate+DateConversion.m
//  ShakeKit
//
//  Created by Justin Williams on 5/28/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import "NSDate+DateConversion.h"

NSDate *ConvertStringToDate(NSString *dateString)
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  
  
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  [formatter setLocale:locale];
  
  // 2011-05-27T22:25:27Z
  [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
  
  NSDate *parsedDate = nil;
  NSError *dateParsingError = nil; 
  if (![formatter getObjectValue:&parsedDate forString:dateString range:nil error:&dateParsingError]) 
  {
    NSLog(@"Date '%@' could not be parsed: %@", dateString, dateParsingError);
  }
  
  return parsedDate;
}

@implementation NSDate (DateConversion)

@end
