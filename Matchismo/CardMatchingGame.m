//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-12.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) int scoreIncrease;
@property (nonatomic) int mode;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
    withNumberOfMatchingCards:(NSInteger)matchNumber
{
    self = [super init];
    
    if(self)
    {
        // Define the game mode
        self.mode = matchNumber;
        
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
    BOOL resetScoreIncrease = YES;
    
    if(!card.isUnplayable)
    {
        if(!card.isFaceUp)
        // See if flipping this card up creates a match
        {
            // Number of cards facing up already
            int cardsFacingUp = 0;
            NSMutableArray *otherCardsOpen;
            
            for(Card *otherCard in self.cards)
            {
                if(otherCard.faceUp && !otherCard.isUnplayable)
                {
                    resetScoreIncrease = NO;
                    cardsFacingUp++;
                    if(self.mode == 2)
                    {
                        // 2-match mode
                        int matchScore = [card match:@[otherCard]];
                        if(matchScore)
                        {
                            result = [NSString stringWithFormat:@"Matched %@ and %@ for %d points", otherCard.contents, card.contents, matchScore * MATCH_BONUS];
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            self.scoreIncrease = matchScore * MATCH_BONUS;
                            self.score += self.scoreIncrease;
                        }
                        else
                        {
                            result = [NSString stringWithFormat:@"%@ and %@ don't match! %d points penalty!", otherCard.contents, card.contents, MISMATCH_PENALTY];
                            otherCard.faceUp = NO;
                            self.scoreIncrease = -MISMATCH_PENALTY;
                            self.score -= MISMATCH_PENALTY;
                        }
                    }
                    else if(self.mode == 3)
                    {
                        // 3-match mode
                        if(cardsFacingUp == 1) // That's the second card open - save the first
                        {
                            otherCardsOpen = [[NSMutableArray alloc] init];
                            [otherCardsOpen addObject:otherCard];
                            resetScoreIncrease = YES;
                        }
                        else if(cardsFacingUp == 2) // Time to do the match
                        {
                            [otherCardsOpen addObject:otherCard];
                            int matchScore = [card match:otherCardsOpen];
                            if(matchScore)
                            {
                                if(matchScore == 16 || matchScore == 5)
                                    result = [NSString stringWithFormat:@"Matched %@, %@ and %@ for %d points",
                                              ((Card *)[otherCardsOpen firstObject]).contents,
                                              ((Card *)[otherCardsOpen lastObject]).contents, card.contents,
                                              matchScore * MATCH_BONUS];
                                else if(matchScore == 1) {
                                    NSString *card1, *card2;
                                    if([card.contents hasSuffix:((Card *)[otherCardsOpen firstObject]).contents]) {
                                        card1 = card.contents;
                                        card2 = ((Card *)[otherCardsOpen firstObject]).contents;
                                    } else if([card.contents hasSuffix:((Card *)[otherCardsOpen lastObject]).contents]) {
                                        card1 = card.contents;
                                        card2 = ((Card *)[otherCardsOpen lastObject]).contents;
                                    } else {
                                        card1 = ((Card *)[otherCardsOpen firstObject]).contents;
                                        card2 = ((Card *)[otherCardsOpen lastObject]).contents;
                                    }
                                    result = [NSString stringWithFormat:@"Matched %@ and %@ for %d point",
                                              card1, card2, matchScore * MATCH_BONUS];
                                } else {
                                    NSString *card1, *card2;
                                    if([[card.contents substringToIndex:[card.contents length]-1] isEqualToString:
                                        [((Card *)[otherCardsOpen firstObject]).contents substringToIndex:
                                         [((Card *)[otherCardsOpen firstObject]).contents length]-1]]) {
                                        card1 = card.contents;
                                        card2 = ((Card *)[otherCardsOpen firstObject]).contents;
                                        } else if([[card.contents substringToIndex:[card.contents length]-1] isEqualToString:
                                                   [((Card *)[otherCardsOpen lastObject]).contents substringToIndex:
                                                    [((Card *)[otherCardsOpen lastObject]).contents length]-1]]) {
                                        card1 = card.contents;
                                        card2 = ((Card *)[otherCardsOpen lastObject]).contents;
                                    } else {
                                        card1 = ((Card *)[otherCardsOpen firstObject]).contents;
                                        card2 = ((Card *)[otherCardsOpen lastObject]).contents;
                                    }
                                    result = [NSString stringWithFormat:@"Matched %@ and %@ for %d points",
                                              card1, card2, matchScore * MATCH_BONUS];
                                }
                                    
                                // There is some match - Disable the 3 cards
                                card.unplayable = YES;
                                for(Card *cardToDisable in otherCardsOpen) {
                                    cardToDisable.unplayable = YES;
                                }
                                self.scoreIncrease = matchScore * MATCH_BONUS;
                                self.score += self.scoreIncrease;
                            }
                            else
                            {
                                // No match
                                result = [NSString stringWithFormat:@"%@, %@ and %@ don't match! %d points penalty!",
                                          ((Card *)[otherCardsOpen firstObject]).contents,
                                          ((Card *)[otherCardsOpen lastObject]).contents, card.contents,
                                          MISMATCH_PENALTY];
                                for(Card *cardToTurnBack in otherCardsOpen) {
                                    cardToTurnBack.faceUp = NO;
                                }
                                self.scoreIncrease = -MISMATCH_PENALTY;
                                self.score -= MISMATCH_PENALTY;
                            }
                        }
                            
                    }
                }
            }
            if(!result)
                result = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            self.scoreIncrease = resetScoreIncrease ? -FLIP_COST : self.scoreIncrease - FLIP_COST;
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
    return result;
}

@end
