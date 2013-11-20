//
//  CardGameViewController.h
//  Matchismo
//
//  Created by nmaadara on 1/10/13.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//
//  Abstract class. Implement method(s) below.

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// Protected (for sub-classes)
- (Deck *)createDeck; // abstract

@end
