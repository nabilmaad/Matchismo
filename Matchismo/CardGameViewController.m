//
//  CardGameViewController.m
//  Matchismo
//
//  Created by nmaadara on 1/10/13.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@end

@implementation CardGameViewController

// Game lazy instantiation
- (CardMatchingGame *)game
{
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[[PlayingCardDeck alloc]init]];
    return _game;
}

// Have random cards from the deck to our screen
- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

// Updating the UI to match the model
- (void)updateUI
{
    Card *cardFacingUpBeforeUpdate;
    
    // Get the card facing up before the update (if any)
    for(UIButton *cardButton in self.cardButtons) {
        if(cardButton.isSelected && cardButton.isEnabled)
            cardFacingUpBeforeUpdate = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
    }
    
    for(UIButton *cardButton in self.cardButtons) {
        // Setting cards' contents
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        // Checking if we just got a match with the current card & update result label
        if(cardButton.isEnabled && card.isUnplayable && ![card.contents isEqualToString:cardFacingUpBeforeUpdate.contents]) {
            // The card just got matched but the UI hasn't changed yet --> This is matched card
            if([cardFacingUpBeforeUpdate.contents characterAtIndex:0] == [card.contents characterAtIndex:0])
                // Rank matched
                self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 16 points",
                                       cardFacingUpBeforeUpdate.contents, card.contents];
            else
                // Suit matched
                self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 4 points",
                                        cardFacingUpBeforeUpdate.contents, card.contents];
        }
        
        // Setting buttons' states and appearances
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        // Updaying the results label
        if(cardButton.isSelected && cardButton.isEnabled) {
            if(!cardFacingUpBeforeUpdate) {
                // Only card faced up (only card selected and enabled)
                self.flipResult.text = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            } else {
                // No match (there was a card open before)
                self.flipResult.text = [NSString stringWithFormat:@"%@ and %@ don't match! 2 point penalty!",
                                        cardFacingUpBeforeUpdate.contents, card.contents];
            }
        }
    }
    
    // Updating the score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

// Setting the flip count label
- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"Flip number is updated to %d", self.flipCount);
}

// Triggered by tapping a card
- (IBAction)flipCard:(UIButton *)sender
{
    // Flip button by calling the model
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    // Increment flip count
    self.flipCount++;
    // Update the UI
    [self updateUI];
}

// Triggered by tapping "Deal"
- (IBAction)dealButton:(UIButton *)sender
{
    // Start a new game
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                      usingDeck:[[PlayingCardDeck alloc]init]];
    // Clear the result text
    self.flipResult.text = [NSString stringWithFormat:@""];
    
    // Reset the number of flips
    self.flipCount = 0;
    
    // Update the UI to flip all cards down
    [self updateUI];
}

- (IBAction)gameMode:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0) {
        // 2-card-match game
        NSLog(@"2-card-match");
    } else {
        // 3-card-match game
        NSLog(@"3-card-match");
    }
}


@end