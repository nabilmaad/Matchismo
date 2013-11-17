//
//  PlayingCard.m
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-04.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // 2-card-match
    if([otherCards count] == 1)
    {
        PlayingCard *otherCard = [otherCards lastObject];
        if([self.suit isEqualToString:otherCard.suit]) {
            score = 2;
        } else if(self.rank == otherCard.rank) {
            score = 8;
        }
    }
    
    // 3-card-match
    else if([otherCards count] == 2)
    {
        PlayingCard *firstOtherCard = [otherCards firstObject];
        PlayingCard *secondOtherCard = [otherCards lastObject];
        if(self.rank == firstOtherCard.rank && self.rank == secondOtherCard.rank) {
            // 3 matching ranks
            score = 16;
        } else if([self.suit isEqualToString:firstOtherCard.suit] && [self.suit isEqualToString:secondOtherCard.suit]) {
            // 3 matching suits
            score = 5;
        } else if(self.rank == firstOtherCard.rank || self.rank == secondOtherCard.rank
                  || firstOtherCard.rank == secondOtherCard.rank) {
            // 2 cards matching ranks
            score = 4;
        } else if([self.suit isEqualToString:firstOtherCard.suit] || [self.suit isEqualToString:secondOtherCard.suit]
           || [firstOtherCard.suit isEqualToString:secondOtherCard.suit]) {
            // 2 cards matching suits
            score = 1;
        }
    }
    
    return score;
}

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
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count-1;
}

@end
