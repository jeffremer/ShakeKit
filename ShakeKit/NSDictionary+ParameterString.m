//
//  NSDictionary+ParameterString.m
//  Second Gear
//
//  Created by Justin Williams on 1/14/11.
//  Copyright 2011 Second Gear. All rights reserved.
//

#import "NSDictionary+ParameterString.h"
#import "NSString+URIEscaping.h"

@implementation NSDictionary (ParameterString)

- (NSString *)convertToURIParameterString
{
    NSMutableArray *elements = [NSMutableArray array];
    for (NSString *k in [self keyEnumerator])
    {
        NSString *escapedK = [NSString escapePath:k];
        if (![k isEqualToString: @""])
        {
            NSString *escapedV = [NSString escapePath:[self objectForKey: k]];
            [elements addObject:[NSString stringWithFormat: @"%@=%@", escapedK, escapedV]];
        }
    }

    return [elements componentsJoinedByString:@"&"];
}
@end
