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

    // It's ALWAYS a 3-card-match
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
                             // Shapes, colors & fillings pass - time for number
                             if((self.number == firstOtherCard.number && self.number == secondOtherCard.number)
                                || (self.number != firstOtherCard.number &&
                                    self.number != secondOtherCard.number &&
                                    firstOtherCard.number != secondOtherCard.number)) {
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

+(NSArray *)validNumbers
{
    return @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3]];
}

+(int)maxNumber
{
    return [self validNumbers].count;
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
-(void)setNumber:(int)number
{
    if([[SetCard validNumbers] containsObject:[NSNumber numberWithInt:(number)]])
        _number = number;
}


// We don't use the property contents
- (NSString *)contents
{
    return nil;
}

@end
