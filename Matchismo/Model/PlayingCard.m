//
//  PlayingCard.m
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-04.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count-1;
}

@end
