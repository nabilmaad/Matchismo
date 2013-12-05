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
                    for(NSUInteger number=1; number <= [SetCard maxNumber]; number++)
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.color = color;
                        card.filling = filling;
                        card.number = number;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
