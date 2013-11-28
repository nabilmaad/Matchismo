//
//  SetCard.m
//  Matchismo
//
//  Created by Nabil Maadarani on 11/24/2013.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;

    // It's a 3-card-match
    if([otherCards count] == 2)
    {
        // Extract cards from array
        SetCard *firstOtherCard = [otherCards firstObject];
        SetCard *secondOtherCard = [otherCards lastObject];
        
        // Start checking match
        if(([self.shape isEqualToString:firstOtherCard.shape] && [self.shape isEqualToString:secondOtherCard.shape])
           || (![self.shape isEqualToString:firstOtherCard.shape] &&
               ![self.shape isEqualToString:secondOtherCard.shape] &&
               ![firstOtherCard.shape isEqualToString:secondOtherCard.shape])) {
               // Shapes pass - time for color
               if(([self.color isEqualToString:firstOtherCard.color] && [self.color isEqualToString:secondOtherCard.color])
                  || (![self.color isEqualToString:firstOtherCard.color] &&
                      ![self.color isEqualToString:secondOtherCard.color] &&
                      ![firstOtherCard.color isEqualToString:secondOtherCard.color])) {
                      // Shapes & colors pass - time for filling
                      if(([self.filling isEqualToString:firstOtherCard.filling] && [self.filling isEqualToString:secondOtherCard.filling])
                         || (![self.filling isEqualToString:firstOtherCard.filling] &&
                             ![self.filling isEqualToString:secondOtherCard.filling] &&
                             ![firstOtherCard.filling isEqualToString:secondOtherCard.filling])) {
                             // Shapes, colors & fillings pass - time for count
                             if((self.count == firstOtherCard.count && self.count == secondOtherCard.count)
                                || (self.count != firstOtherCard.count &&
                                    self.count != secondOtherCard.count &&
                                    firstOtherCard.count != secondOtherCard.count)) {
                                    // All pass - give score
                                    score = 16;
                                }
                         }
                  }
           }
    }
    
    return score;
}


+(NSArray *)validShapes
{
    return @[@"▲", @"●", @"■"];
}

+(NSArray *)validColors
{
    return @[@"Red", @"Green", @"Blue"];
}

+(NSArray *)validFillings
{
    return @[@"Solid", @"Stripped", @"Open"];
}

+(NSArray *)validCounts
{
    return @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3]];
}

+(int)maxCount
{
    return [self validCounts].count;
}

// Safe checking shape
@synthesize shape = _shape;

-(void)setShape:(NSString *)shape
{
    if([[SetCard validShapes] containsObject:shape])
        _shape = shape;
}

-(NSString *)shape
{
    return _shape ? _shape : @"?";
}

// Safe checking color
@synthesize color = _color;

-(void)setColor:(NSString *)color
{
    if([[SetCard validColors] containsObject:color])
        _color = color;
}

-(NSString *)color
{
    return _color ? _color : @"?";
}

// Safe checking filling
@synthesize filling = _filling;

-(void)setFilling:(NSString *)filling
{
    if([[SetCard validFillings] containsObject:filling])
        _filling = filling;
}

-(NSString *)filling
{
    return _filling ? _filling : @"?";
}

// Safe checking count
-(void)setCount:(int)count
{
    if([[SetCard validCounts] containsObject:[NSNumber numberWithInt:(count)]])
        _count = count;
}


// We don't use the property contents
- (NSString *)contents
{
    return nil;
}

@end
