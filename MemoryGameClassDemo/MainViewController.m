//
//  MainViewController.m
//  MemoryGameClassDemo
//
//  Created by Rizza on 6/23/15.
//  Copyright (c) 2015 Rizza Corella Punsalan. All rights reserved.
//

#import "MainViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MainViewController ()

@property (nonatomic, strong) MemoryGameViewController *gameViewController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.gameViewController = [[MemoryGameViewController alloc] initWithNumberOfCards:8];
    
    self.gameViewController.delegate = self;
    
    [self.view addSubview:self.gameViewController.view];
    [self addChildViewController:self.gameViewController];
}

/* Delegate Methods */
- (NSArray *)cardImages {
    NSArray *cards = [NSArray arrayWithObjects:[UIImage imageNamed:@"Card0.png"],
                         [UIImage imageNamed:@"Card1.png"],
                         [UIImage imageNamed:@"Card2.png"],
                         [UIImage imageNamed:@"Card3.png"],
                         [UIImage imageNamed:@"Card4.png"],
                         [UIImage imageNamed:@"Card5.png"],
                         [UIImage imageNamed:@"Card6.png"],
                         [UIImage imageNamed:@"Card7.png"],
                         [UIImage imageNamed:@"CardBack.png"],
                         nil];
    return cards;
}

- (CGFloat)cardWidth {
    return 60.0;
}

- (CGFloat)cardHeight {
    return 60.0;
}

- (NSInteger)numberOfCardsInRow {
    return 4;
}

- (UIColor *)backgroundColor {
    return UIColorFromRGB(0x228B22);
}

- (NSInteger)timerMaxTime {
    return 60;
}


- (UIColor *)labelFontColor {
    return [UIColor whiteColor];
}


- (NSString *)labelFontName {
    return [NSString stringWithFormat:@"Futura"];
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
