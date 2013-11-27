//
//  SetCard.h
//  Matchismo
//
//  Created by Nabil Maadarani on 11/24/2013.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

// Set Card visual properties
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *filling;
@property (nonatomic) NSInteger count;

// Valid properties
+(NSArray *)validShapes;
+(NSArray *)validColors;
+(NSArray *)validFillings;
+(NSArray *)countStrings;
+(NSUInteger)maxCount;

@end
