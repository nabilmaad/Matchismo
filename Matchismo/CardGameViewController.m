//
//  CardGameViewController.m
//  Matchismo
//
//  Created by nmaadara on 1/10/13.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *deck;
@end

@implementation CardGameViewController

- (PlayingCardDeck *)deck
{
    if(!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"Flip number is updated to %d", self.flipCount   );
}

- (IBAction)flipCard:(UIButton *)sender
{
    // Toggle button state
    sender.selected = !sender.isSelected;

    // Get content of random card and set its title (only if back is showing)
    if(!sender.isSelected)
        [sender setTitle:[self.deck drawRandomCard].contents forState:UIControlStateSelected];
    
    // Increment flip count
    self.flipCount++;
}


@end