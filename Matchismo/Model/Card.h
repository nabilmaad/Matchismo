//
//  Card.h
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-03.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;

@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (int)match: (NSArray *)otherCards;

@end
