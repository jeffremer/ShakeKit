//
//  NSString+URIEscaping.m
//  Second Gear
//
//  Created by Justin Williams on 1/14/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import "NSString+URIEscaping.h"


@implementation NSString (URIEscaping)

+ (NSString *)escapePath:(NSString*)path 
{
  CFStringEncoding encoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
  NSString *escapedPath = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                              (CFStringRef)path,
                                                                              NULL,
                                                                              (CFStringRef)@":?=,!$&'()*+;[]@#",
                                                                              encoding));
  
  return escapedPath;
}


@end
