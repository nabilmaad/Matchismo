//
//  PlayingCard.h
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-04.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;

@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
