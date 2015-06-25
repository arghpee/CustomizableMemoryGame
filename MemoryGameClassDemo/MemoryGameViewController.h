//
//  MemoryGameViewController.h
//  MemoryGameClassDemo
//
//  Created by Rizza on 6/23/15.
//  Copyright (c) 2015 Rizza Corella Punsalan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemoryGameViewControllerDelegate <NSObject>

@required

/* Should return an array of objects of type UIImage. The number of elements in the array should equal one added to the value of the numberOfCards property. The last element in the array should be the image to be shown when each card is faced down. */
- (NSArray*)cardImages;

/* Should return the width of each card in pixels. */
- (CGFloat)cardWidth;

/* Should return the height of each card in pixels. */
- (CGFloat)cardHeight;

/* Should return the number of cards in a row */
- (NSInteger)numberOfCardsInRow;

/* Should return the number of */
- (NSInteger)timerMaxTime;

@optional

/* Should return backround color */
- (UIColor *)backgroundColor;

/* Should return label font color */

/* Should return label font size */

@end

@interface MemoryGameViewController : UIViewController <UIAlertViewDelegate>

/* methods */
- (id)initWithNumberOfCards:(NSInteger)numberOfCards;

/* properties */
@property (nonatomic, assign) id<MemoryGameViewControllerDelegate> delegate;

@property (nonatomic, retain) UILabel* scoreLabel;
@property (nonatomic, retain) UILabel* timeRemainingLabel;

@property (retain) NSMutableArray *buttons;
@property (retain) NSMutableArray *board;

@property (assign) NSInteger pairsFound;
@property (assign) NSInteger flippedCards;
@property (assign) NSInteger firstButtonIndex;
@property (assign) NSInteger currButtonIndex;
@property (assign) NSInteger numberOfCards; // The number of unique cards to be used in the game.

@end
