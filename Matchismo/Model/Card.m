//
//  Card.m
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-03.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for(Card *card in otherCards)
    {
        if([card.contents isEqualToString:self.contents])
        {
            score = 1;
        }
    }
    
    return score;
}

@end
