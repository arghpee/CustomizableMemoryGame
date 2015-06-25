//
//  MemoryGameViewController.m
//  MemoryGameClassDemo
//
//  Created by Rizza on 6/23/15.
//  Copyright (c) 2015 Rizza Corella Punsalan. All rights reserved.
//

#import "MemoryGameViewController.h"
#define NAV_BAR_HEIGHT 70
#define FLIP_DELAY 1.0
#define WIN_DELAY 0.5
#define DEFAULT_FONT_COLOR [UIColor blackColor]
#define DEFAULT_FONT_SIZE 25
#define DEFAULT_FONT_NAME @"Futura"

@interface MemoryGameViewController ()

@end

@implementation MemoryGameViewController {
    NSInteger timer;
    BOOL timerRunning;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNumberOfCards:(NSInteger)numberOfCards {
    self = [super initWithNibName:@"MemoryGameViewController" bundle:nil];
    self.numberOfCards = numberOfCards;
    return self;
}

- (void)startGame {
    [self setupGameView];
    [self initBoard];
    [self startTimer];
}

- (NSArray *)getCardImages {
    if ([[self.delegate cardImages] count] != (self.numberOfCards + 1)) {
        [NSException raise:@"Invalid number of cards images." format:@"Number of card images must equal the set number of cards plus 1."];
    }
    return [self.delegate cardImages];
}

- (void)setupGameView {
    /* Set new background color if delegate provided it */
    if ([self.delegate respondsToSelector:@selector(backgroundColor)] ) {
        [self.view setBackgroundColor:[self.delegate backgroundColor]];
    }
    
    /* Get screen width */
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;;
    
    /* Get the card width and height specified by delegate */
    CGFloat cardWidth = [self.delegate cardWidth];
    CGFloat cardHeight = [self.delegate cardHeight];
    
    /* Get the number of cards in a row, specified by delegate */
    NSInteger numberOfCardsInRow = [self.delegate numberOfCardsInRow];
    
    /* Arbitrarily set the width from the left edge of the screen to the leftmost card and the with from the right edge of th screen to the rightmost card */
    CGFloat edgeSpace = 0.04 * screenWidth;
    
    /* Arbitrarily set the width of the space in between cards */
    CGFloat cardSpace = (screenWidth - (cardWidth * numberOfCardsInRow) - (edgeSpace * 2)) / (numberOfCardsInRow - 1); // width of space between cards
    
    /* Initialize array of card buttons */
    self.buttons = [[NSMutableArray alloc]initWithCapacity:self.numberOfCards * 2];
    
    /* Fill buttons array with button objects and them to the view */
    for (int i = 0; i < self.numberOfCards * 2; i++) {
        /* Initialize button */
        UIButton *button = [[UIButton alloc] init];
        
        /* Set the method called when button is pressed to method 'cardClicked' */
        [button addTarget:self action:@selector(cardClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        /* Set the button tag to its index in the buttons array for later reference */
        button.tag = i;
        
        /* Set button image to the image shown when a card is faced down */
        [button setImage:[[self getCardImages] objectAtIndex:self.numberOfCards] forState:UIControlStateNormal];
        [button setImage:[[self getCardImages] objectAtIndex:self.numberOfCards] forState:UIControlStateDisabled];
        [button setImage:[[self getCardImages] objectAtIndex:self.numberOfCards] forState:UIControlStateSelected];
        
        /* Set button position and size */
        button.frame = CGRectMake((edgeSpace + ((i % numberOfCardsInRow) * (cardWidth + cardSpace))), ((NAV_BAR_HEIGHT + (0.25 * NAV_BAR_HEIGHT)) + ((int)(i / numberOfCardsInRow))*(cardHeight*1.5)), cardWidth, cardHeight);
        
        /* Add the button to the view */
        [self.view addSubview:button];
        
        /* Add the button to the buttons array */
        [self.buttons addObject:button];
    }
    
    /* Get Label Font Color if Available */
    UIColor *labelFontColor;
    if ([self.delegate respondsToSelector:@selector(labelFontColor)]) {
        labelFontColor = [self.delegate labelFontColor];
    }
    else {
        labelFontColor = DEFAULT_FONT_COLOR;
    }
    
    /* Get Label Font Size if Available */
    NSInteger labelFontSize;
    if ([self.delegate respondsToSelector:@selector(labelFontSize)]) {
        labelFontSize = [self.delegate labelFontSize];
    }
    else {
        labelFontSize = DEFAULT_FONT_SIZE;
    }
    
    /* Get Label Font Name if Available */
    NSString *labelFontName;
    if ([self.delegate respondsToSelector:@selector(labelFontName)]) {
        labelFontName = [self.delegate labelFontName];
    }
    else {
        labelFontName = DEFAULT_FONT_NAME;
    }
    
    /* Set size of score label */
    CGFloat scoreLabelXPos = edgeSpace;
    int heightOfCards = (int)(((self.numberOfCards * 2) - 1)/ numberOfCardsInRow) + 1;
    NSLog(@"Height of Cards: %d", heightOfCards);
    CGFloat scoreLabelYPos = NAV_BAR_HEIGHT + (0.25 * NAV_BAR_HEIGHT) + (heightOfCards*cardHeight*1.5);
    NSLog(@"Y-Position of Score Label: %f", scoreLabelYPos);
    CGFloat scoreLabelWidth = screenWidth - (edgeSpace * 2);
    CGFloat scoreLabelHeight = 50.0;
    
    /* Set score label parameters */
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreLabelXPos, scoreLabelYPos, scoreLabelWidth, scoreLabelHeight)];
    self.scoreLabel.textColor = labelFontColor;
    [self.scoreLabel setFont:[UIFont fontWithName:@"Futura" size:labelFontSize]];
    
    /* Add score label to view */
    [self.view addSubview:self.scoreLabel];
    
    /* Set size of time remaining label */
    CGFloat timeRemainingLabelXPos = edgeSpace;
    CGFloat timeRemainingLabelYPos = scoreLabelYPos + 50.0;
    CGFloat timeRemainingLabelWidth = screenWidth - (edgeSpace * 2);
    CGFloat timeRemainingLabelHeight = 50.0;
    
    /* Set time remaining label parameters */
    self.timeRemainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeRemainingLabelXPos, timeRemainingLabelYPos, timeRemainingLabelWidth, timeRemainingLabelHeight)];
    self.timeRemainingLabel.textColor = labelFontColor;
    [self.timeRemainingLabel setFont:[UIFont fontWithName:@"Futura" size:labelFontSize]];
    self.timeRemainingLabel.text = [NSString stringWithFormat:@"Time Remaining: %lu", [self.delegate timerMaxTime]];
    
    /* Add time remaining label to view */
    [self.view addSubview:self.timeRemainingLabel];
}

- (IBAction)cardClicked:(id)sender {
    if (self.flippedCards < 2) { // card is initially facing down
        self.currButtonIndex = [self.buttons indexOfObject:sender];
        [self faceCardWithThisIndexUp:self.currButtonIndex];
        
        self.flippedCards++;
        
        if (self.flippedCards == 1) {
            self.firstButtonIndex = self.currButtonIndex;
        }
        else if (self.flippedCards == 2) {
            if ([self doesFirstButtonMatchCurrentButton]) {
                self.pairsFound++;
                [self disableFirstAndCurrentButtons];
                self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lu", self.pairsFound];
                if (self.pairsFound == self.numberOfCards) {
                    timerRunning = NO;
                    [NSTimer scheduledTimerWithTimeInterval:WIN_DELAY
                                                     target:self
                                                   selector:@selector(winGame)
                                                   userInfo:nil
                                                    repeats:NO];
                }
            }
            else {
                [self disableAllButtons];
                [NSTimer scheduledTimerWithTimeInterval:FLIP_DELAY
                                                 target:self
                                               selector:@selector(faceLastTwoCardsDown)
                                               userInfo:nil
                                                repeats:NO];
            }
            self.flippedCards = 0;
        }
    }
}

-(BOOL)doesFirstButtonMatchCurrentButton {
    if ([[self.board objectAtIndex:self.firstButtonIndex] intValue] == [[self.board objectAtIndex:self.currButtonIndex] intValue]) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)disableFirstAndCurrentButtons {
    NSLog(@"Disabling button with tag %lu", self.firstButtonIndex);
    [[self.buttons objectAtIndex:self.firstButtonIndex] setEnabled:NO];
    [[self.buttons objectAtIndex:self.firstButtonIndex] setSelected:YES];
    NSLog(@"Disabling button with tag %lu", self.currButtonIndex);
    [[self.buttons objectAtIndex:self.currButtonIndex] setEnabled:NO];
    [[self.buttons objectAtIndex:self.currButtonIndex] setSelected:YES];
}

-(void)disableAllButtons {
    for (int i = 0; i < self.numberOfCards * 2; i++) {
        [[self.buttons objectAtIndex:i] setEnabled:NO];
    }
}

-(void)reenableUnmatchedButtons {
    UIButton* button;
    for (int i = 0; i < self.numberOfCards * 2; i++) {
        button = (UIButton *) [self.buttons objectAtIndex:i];
        if (!button.selected) {
            [button setEnabled:YES];
        }
    }
}

-(void)winGame {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hooray!" message:@"You won the game!" delegate:self cancelButtonTitle:@"Play again" otherButtonTitles:nil];
    alertView.tag = 200;
    timerRunning = NO;
    [alertView show];
}

-(void)loseGame {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Time is up!" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil];
    alertView.tag = 100;
    [alertView show];
}

-(void)startTimer {
    timer = [self.delegate timerMaxTime];
    self.timeRemainingLabel.text = [NSString stringWithFormat:@"Time Remaining: %lu", timer];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(decrementTimer)
                                   userInfo:nil
                                    repeats:NO];
    timerRunning = YES;
}

-(void)decrementTimer {
    if (timerRunning) {
        timer--;
        self.timeRemainingLabel.text = [NSString stringWithFormat:@"Time Remaining: %lu", timer];
        if (timer == 0) {
            [self loseGame];
        }
        else {
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(decrementTimer)
                                           userInfo:nil
                                            repeats:NO];
        }
        
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ((alertView.tag == 100 || alertView.tag == 200) && buttonIndex == 0) {
        [self reinitBoard];
    }
}

-(void)reinitBoard {
    for (int i = 0; i < self.numberOfCards * 2; i++) {
        [self.board replaceObjectAtIndex:i withObject:[[NSNumber alloc] initWithInt:-1]];
    }
    [self fillBoard];
    [self faceDownAllCards];
    [self startTimer];
}


-(void)initBoard {
    self.board = [[NSMutableArray alloc]initWithCapacity:self.numberOfCards * 2];
    
    for(int i = 0; i < (self.numberOfCards * 2); i++){
        [self.board addObject:[[NSNumber alloc] initWithInt:-1 ]];
    }
    
    [self fillBoard];
}

-(void)fillBoard {
    for(int i = 0; i < self.numberOfCards; i++){
        
        for(int j = 0; j < 2; j++){
            
            int randomSlot = arc4random() % (self.numberOfCards * 2);
            while([[self.board objectAtIndex:randomSlot] intValue] != -1){
                randomSlot = arc4random() % (self.numberOfCards * 2);
            }
            NSLog(@"Assigning %d to slot %d\n", i, randomSlot);
            [self.board replaceObjectAtIndex:randomSlot withObject:[[NSNumber alloc] initWithInteger: i]];
            NSLog(@"Slot %d now contains %d\n", randomSlot, [[self.board objectAtIndex:randomSlot] intValue]);
        }
        
    }
    
    NSLog(@"The BOARD: @%@", self.board);
    self.flippedCards = 0;
    self.pairsFound = 0;
    self.scoreLabel.text = @"Score: 0";
}

- (void)faceDownAllCards {
    for (int i = 0; i < self.numberOfCards * 2; i++) {
        [self faceCardWithThisIndexDown:i];
    }
}

- (void)faceCardWithThisIndexDown:(NSInteger)cardIndex {
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[[self getCardImages] objectAtIndex:self.numberOfCards] forState:UIControlStateNormal];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[[self getCardImages] objectAtIndex:self.numberOfCards] forState:UIControlStateDisabled];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[[self getCardImages] objectAtIndex:self.numberOfCards] forState:UIControlStateDisabled];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setEnabled:YES];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setSelected:NO];
}

-(void)faceCardWithThisIndexUp:(NSInteger)cardIndex {
    NSUInteger imgIndex = (NSUInteger) [[self.board objectAtIndex:(NSUInteger) cardIndex] intValue];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[[self getCardImages] objectAtIndex:imgIndex] forState:UIControlStateNormal];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[[self getCardImages] objectAtIndex:imgIndex] forState:UIControlStateDisabled];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[[self getCardImages] objectAtIndex:imgIndex] forState:UIControlStateSelected];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setEnabled:NO];
}

-(void)faceLastTwoCardsDown {
    NSLog(@"Facing Down Card %lu", self.firstButtonIndex);
    [self faceCardWithThisIndexDown:self.firstButtonIndex];
    NSLog(@"Facing Down Card %lu", self.currButtonIndex);
    [self faceCardWithThisIndexDown:self.currButtonIndex];
    [self reenableUnmatchedButtons];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
