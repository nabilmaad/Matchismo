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
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameMode;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (strong, nonatomic) NSMutableArray *flipResultHistory; // of strings
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation CardGameViewController

// Flip result history lazy instantiation
- (NSMutableArray *)flipResultHistory
{
    if(!_flipResultHistory)
        _flipResultHistory = [[NSMutableArray alloc] init];
    return _flipResultHistory;
}

// Game lazy instantiation
- (CardMatchingGame *)game
{
    if(!_game)
    {
        if(self.gameMode.selectedSegmentIndex == 0) {
            _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[[PlayingCardDeck alloc]init]
                                         withNumberOfMatchingCards:2];
        } else if(self.gameMode.selectedSegmentIndex == 1) {
            _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                      usingDeck:[[PlayingCardDeck alloc]init]
                                      withNumberOfMatchingCards:3];
        }
    }
    return _game;
}

// Have random cards from the deck to our screen & set card images
- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    
    // Grab the images
    UIImage *cardBackImage = [UIImage imageNamed:@"playing-card-back.jpg"];
    UIImage *cardFrontImage = [[UIImage alloc] init];
    UIImage *cardFrontBackground = [UIImage imageNamed:@"playing-card-front.jpg"];
    
    // Apply imgaes and backgrounds
    for(UIButton *cardButton in self.cardButtons) {
        // Setting cards' back image
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        
        // Setting cards' front image (null)
        [cardButton setImage:cardFrontImage forState:UIControlStateSelected];
        [cardButton setImage:cardFrontImage forState:UIControlStateSelected|UIControlStateDisabled];
        [cardButton setBackgroundImage:cardFrontBackground forState:UIControlStateSelected];
        
        // Setting cards' front background (clear with grey edges)
        [cardButton setBackgroundImage:cardFrontBackground forState:UIControlStateSelected|UIControlStateDisabled];
    }
    
    [self updateUI];
}

// Flip result background
- (void)setFlipResult:(UILabel *)flipResult
{
    _flipResult = flipResult;
    UIImage *flipResultBackground = [UIImage imageNamed:@"flip-result-bkgd.png"];
    self.flipResult.backgroundColor = [UIColor colorWithPatternImage:flipResultBackground];
}

// History Slider properties
- (void)setSlider:(UISlider *)slider
{
    _slider = slider;
    _slider.enabled = NO;
}

// Updating the UI to match the model
- (void)updateUI
{
    NSMutableArray *cardsFacingUpBeforeUpdate; // of cards
    
    // Get the card facing up before the update (if any)
    for(UIButton *cardButton in self.cardButtons) {
        if(cardButton.isSelected && cardButton.isEnabled) {
            // Found a card already facing up - add it
            if (!cardsFacingUpBeforeUpdate) cardsFacingUpBeforeUpdate = [[NSMutableArray alloc] init];
            [cardsFacingUpBeforeUpdate addObject:[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]]];
        }
    }
    
    // Scan through the cards
    for(UIButton *cardButton in self.cardButtons) {
        // Setting cards' contents
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        // Getting to the card I just opened & checking for match
        if(cardButton.isEnabled && card.isUnplayable &&
           ![card.contents isEqualToString:((Card *)[cardsFacingUpBeforeUpdate firstObject]).contents] &&
           ![card.contents isEqualToString:((Card *)[cardsFacingUpBeforeUpdate lastObject]).contents])
        {
            if(self.gameMode.selectedSegmentIndex == 0)
            {
                // 2-card-match mode
                if(self.game.scoreIncrease == 7) {
                    // Suit match in 2-card-match game
                    self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 8 points",
                                            ((Card *)[cardsFacingUpBeforeUpdate firstObject]).contents, card.contents];
                } else if(self.game.scoreIncrease == 31) {
                    // Rank match in 2-card-match game
                    self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 32 points",
                                            ((Card *)[cardsFacingUpBeforeUpdate firstObject]).contents, card.contents];
                }
            }
            else if(self.gameMode.selectedSegmentIndex == 1)
            {
                // 3-card-match mode
                NSString *firstCard = ((Card *)[cardsFacingUpBeforeUpdate firstObject]).contents;
                NSString *secondCard = ((Card *)[cardsFacingUpBeforeUpdate lastObject]).contents;

                if(self.game.scoreIncrease == 3) {
                    // 2 suits matched in 3-card-match game
                    if([firstCard characterAtIndex:[firstCard length]-1] == [secondCard characterAtIndex:[secondCard length]-1])
                        self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 4 points",
                                                firstCard, secondCard];
                    else if([firstCard characterAtIndex:[firstCard length]-1] ==
                            [card.contents characterAtIndex:[card.contents length]-1])
                        self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 4 points",
                                                firstCard, card.contents];
                    else
                        self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 4 points",
                                                secondCard, card.contents];
                } else if(self.game.scoreIncrease == 63) {
                    // 3 ranks matched in 3-card-match game
                    self.flipResult.text = [NSString stringWithFormat:@"Matched %@, %@, and %@ for 64 points",
                                            firstCard, secondCard, card.contents];
                } else if(self.game.scoreIncrease == 15) {
                    // 3 suits match OR 2 ranks match in 3-card-match game
                    if([firstCard characterAtIndex:[firstCard length]-1] == [secondCard characterAtIndex:[secondCard length]-1] &&
                       [firstCard characterAtIndex:[firstCard length]-1] == [card.contents characterAtIndex:[card.contents length]-1])
                        // 3 suits matched
                        self.flipResult.text = [NSString stringWithFormat:@"Matched %@, %@, and %@ for 16 points",
                                                firstCard, secondCard, card.contents];
                    else {
                        // 2 ranks match
                        if([firstCard characterAtIndex:0] == [secondCard characterAtIndex:0])
                            self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 16 points",
                                                    firstCard, secondCard];
                        else if([firstCard characterAtIndex:0] == [card.contents characterAtIndex:0])
                            self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 16 points",
                                                    firstCard, card.contents];
                        else
                            self.flipResult.text = [NSString stringWithFormat:@"Matched %@ and %@ for 16 points",
                                                    secondCard, card.contents];
                    }
                }
            }
        }
        
        // Setting buttons' states and appearances
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        // Checking cards flipped up and non matches
        if(cardButton.isSelected && cardButton.isEnabled &&
           ![card.contents isEqualToString:((Card *)[cardsFacingUpBeforeUpdate firstObject]).contents]) {
            if(self.game.scoreIncrease == -1)
                // Flipping up the card without consequences
                self.flipResult.text = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            else if(self.game.scoreIncrease == -3) {
                if(self.gameMode.selectedSegmentIndex == 0)
                    // No match in 2-card-match game
                    self.flipResult.text = [NSString stringWithFormat:@"%@ and %@ don't match! 2 point penalty!",
                                            ((Card *)[cardsFacingUpBeforeUpdate firstObject]).contents, card.contents];
                else
                    // No match in 3-card-match game
                    self.flipResult.text = [NSString stringWithFormat:@"%@, %@, and %@ don't match! 2 point penalty!",
                                            ((Card *)[cardsFacingUpBeforeUpdate firstObject]).contents,
                                            ((Card *)[cardsFacingUpBeforeUpdate lastObject]).contents, card.contents];
            }
        }
    }
    
    // Save the content of the flip result
    if(self.flipResult.text && ![self.flipResult.text isEqualToString:@""])
        [self.flipResultHistory addObject:self.flipResult.text];
    
    // Updating the score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

// Setting the flip count label
- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

// Triggered by tapping a card
- (IBAction)flipCard:(UIButton *)sender
{
    // Disable game mode segmented control
    if(self.gameMode.isEnabled)
        self.gameMode.enabled = NO;
    
    // Push UISlider to the present, enable it, and fix the label's alpha
    [self.slider setValue:1.0 animated:YES];
    self.slider.enabled = YES;
    self.flipResult.alpha = 1.0;
    
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
    // Enable game mode segmented control
    self.gameMode.enabled = YES;
    
    // Start a new game
    if(self.gameMode.selectedSegmentIndex == 0) {
        self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                      usingDeck:[[PlayingCardDeck alloc]init]
                                      withNumberOfMatchingCards:2];
    } else {
        self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                      usingDeck:[[PlayingCardDeck alloc]init]
                                      withNumberOfMatchingCards:3];
    }
    // Reset the result text
    self.flipResult.text = [NSString stringWithFormat:@"Flip a card to start..."];
    
    // Reset the number of flips
    self.flipCount = 0;
    
    // Erase all elements in the flip result history
    self.flipResultHistory = [[NSMutableArray alloc] init];
    
    // Disable UISlider
    self.slider.value = 1.0;
    self.slider.enabled = NO;
    
    // Update the UI to flip all cards down
    [self updateUI];
}

- (IBAction)gameMode:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc]init]
                                  withNumberOfMatchingCards:2];
    } else if(self.gameMode.selectedSegmentIndex == 1) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc]init]
                                  withNumberOfMatchingCards:3];
    }
    // Reset the result text
    self.flipResult.text = [NSString stringWithFormat:@"Flip a card to start..."];
}

- (IBAction)historySlider:(UISlider *)sender
{
    int flipLogsAvailable = [self.flipResultHistory count];
    float lengthOfEachElement = 1.0/(float)flipLogsAvailable;
    
    // Creating the values array that corresponds with the flip history array
    float values[flipLogsAvailable];
    for(int i=0; i < flipLogsAvailable; i++) {
        values[i] = (float)i * lengthOfEachElement;
    }
    
    // Find the boundaries of the slider value (in the values array)
    int lowerBound = 0;
    if(sender.value > values[flipLogsAvailable-1]) {
        // Latest value - keep alpha
        lowerBound = flipLogsAvailable-1;
        self.flipResult.alpha = 1.0;
    } else {
        // Old value - apply alpha
        for(int i=0; i < flipLogsAvailable-1; i++) {
            if(sender.value > values[i] && sender.value <= values[i+1]) {
                lowerBound = i;
                self.flipResult.alpha = 0.5;
                break;
            }
        }
    }
    
    // Update flip label accordingly
    self.flipResult.text = [self.flipResultHistory objectAtIndex:lowerBound];
}


@end