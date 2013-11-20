//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by nmaadara on 20/11/13.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
