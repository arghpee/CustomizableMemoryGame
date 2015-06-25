//
//  AppDelegate.h
//  MemoryGameClassDemo
//
//  Created by Rizza on 6/23/15.
//  Copyright (c) 2015 Rizza Corella Punsalan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    MainViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

