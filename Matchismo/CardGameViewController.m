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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameMode;
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

// History Slider properties
- (void)setSlider:(UISlider *)slider
{
    _slider = slider;
    _slider.enabled = NO;
}

// Get a card's title
- (NSString *) titleForCard:(Card *)card
{
    return card.isFaceUp ? card.contents : @"";
}

// Get a card's background
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.faceUp ? @"cardfront.png" : @"cardback.png"];
}

// Updating the UI to match the model
- (void)updateUI
{
    // Scan through the cards
    for(UIButton *cardButton in self.cardButtons) {
        // Setting cards' contents
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        // Setting buttons' states and appearances
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    // Save the content of the flip result
    if(self.flipResult.text && ![self.flipResult.text isEqualToString:@""])
        [self.flipResultHistory addObject:self.flipResult.text];
    
    // Updating the score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
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
    
    // Flip card and show flip result by calling the model
    self.flipResult.text = [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];

    // Update the UI
    [self updateUI];
}

// Triggered by tapping the deal button
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
    
    // Disable UISlider
    self.slider.value = 1.0;
    self.slider.enabled = NO;
    
    // Update the UI to flip all cards down
    [self updateUI];
    
    // Erase all elements in the flip result history
    [self.flipResultHistory removeAllObjects];

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