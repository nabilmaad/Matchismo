//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-12.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite) int score;
@property (nonatomic) int mode;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    
    if(self)
    {
        // Define the game mode (get rid of it later)
        if([deck isKindOfClass:[PlayingCardDeck class]])
            self.mode = 2;
        else if([deck isKindOfClass:[SetCardDeck class]])
            self.mode = 3;
        
        // Create the cards
        for(int i=0; i < cardCount; i++)
        {
            Card *card = [deck drawRandomCard];
            if(! card)
            {
                self = nil;
            }
            else
            {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
- (NSString *)flipCardAtIndex:(NSUInteger)index
{
    NSString *result; // Result of flip
    
    Card *card = [self cardAtIndex:index];
    
    if(!card.isUnplayable)
    {
        if(!card.isFaceUp)
        // See if flipping this card up creates a match
        {
            // Cards facing up already
            NSMutableArray *otherCardsOpen;
            
            for(Card *otherCard in self.cards)
            {
                if(otherCard.faceUp && !otherCard.isUnplayable)
                {
                    if(self.mode == 2)
                    {
                        // 2-match mode
                        int matchScore = [card match:@[otherCard]];
                        if(matchScore)
                        {
                            result = [NSString stringWithFormat:@"Matched %@ and %@ for %d points", otherCard.contents, card.contents, matchScore * MATCH_BONUS];
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                        }
                        else
                        {
                            result = [NSString stringWithFormat:@"%@ and %@ don't match! %d points penalty!", otherCard.contents, card.contents, MISMATCH_PENALTY];
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                        }
                    }
                    else if(self.mode == 3)
                    {
                        // 3-match mode
                        
                        // Add open card to array
                        if(!otherCardsOpen)
                            otherCardsOpen = [[NSMutableArray alloc] init];
                        [otherCardsOpen addObject:otherCard];
                        
                        if([otherCardsOpen count] == 2) // Time to do the match - there are already 2 cards in the array
                        {
                            int matchScore = [card match:otherCardsOpen];
                            if(matchScore)
                            {
                                result = [NSString stringWithFormat:@"Matched %d%@, %d%@ and %d%@ for %d points",
                                          ((SetCard *)[otherCardsOpen firstObject]).number,
                                          ((SetCard *)[otherCardsOpen firstObject]).shape,
                                          ((SetCard *)[otherCardsOpen lastObject]).number,
                                          ((SetCard *)[otherCardsOpen lastObject]).shape,
                                          ((SetCard *)card).number, ((SetCard *)card).shape,
                                          matchScore * MATCH_BONUS];
                                
                                // There is a match - Disable the 3 cards
                                card.unplayable = YES;
                                for(Card *cardToDisable in otherCardsOpen) {
                                    cardToDisable.unplayable = YES;
                                }
                                self.score += matchScore * MATCH_BONUS;
                            }
                            else
                            {
                                // No match
                                result = [NSString stringWithFormat:@"Your 3 cards don't match! %d points penalty!",
                                          MISMATCH_PENALTY];
                                for(Card *cardToTurnBack in otherCardsOpen) {
                                    cardToTurnBack.faceUp = NO;
                                }
                                self.score -= MISMATCH_PENALTY;
                            }
                        }
                    }
                }
            }
            if(!result)
                result = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
    return result;
}

@end
