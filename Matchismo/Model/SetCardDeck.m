//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Nabil Maadarani on 11/24/2013.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if(self)
    {
        for(NSString *shape in [SetCard validShapes])
        {
            for(NSString *color in [SetCard validColors])
            {
                for(NSString *filling in [SetCard validFillings])
                {
                    for(NSUInteger rank=1; rank <= [PlayingCard maxRank]; rank++)
                    {
                        PlayingCard *card = [[PlayingCard alloc] init];
                        card.rank = rank;
                        card.suit = suit;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}


@end
