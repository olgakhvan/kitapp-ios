//
//  ContainerViewController.h
//  KitappApplication
//
//  Created by Olga Khvan on 06.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
