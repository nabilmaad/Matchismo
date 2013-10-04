//
//  Deck.h
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-03.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void) addCard: (Card *)card atTop: (BOOL)atTop;

- (Card *)drawRandomCard;

@end
