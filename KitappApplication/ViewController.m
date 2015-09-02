//
//  ViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 30.06.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "MainViewController1.h"
#import "UIDeviceHardware.h"


@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    //[self.view addSubview:pageControl];
    
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];

    NSString *platform = [UIDevice currentDevice].model;
    if ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,3"] || [platform isEqualToString:@"iPhone4,1"]){
        self.backgrounds = @[@"bg1_4s", @"bg2_4s", @"bg3_4s"];
    }
    else{
        if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"] || [platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"] || [platform isEqualToString:@"iPhone6,1"] || [platform isEqualToString:@"iPhone6,2"]){
                self.backgrounds = @[@"bg1_5s.jpg", @"bg2_5s.jpg", @"bg3_5s.jpg"];
        }
        else{
            if ([platform isEqualToString:@"iPhone7,1"]){
                self.backgrounds = @[@"bg1_6plus.jpg", @"bg2_6plus.jpg", @"bg3_6plus.jpg"];
            }
            else{
                if ([platform isEqualToString:@"iPhone7,2"]){
                    self.backgrounds = @[@"bg1_6.jpg", @"bg2_6.jpg", @"bg3_6.jpg"];
                }
                else{
                    self.backgrounds = @[@"bg1_5s.jpg", @"bg2_5s.jpg", @"bg3_5s.jpg"];
                }
            }
        }
    }
    self.pageTitles = @[@"Подари своим старым книгам вторую жизнь", @"Продавай свои старые книги", @"Находи книги, которые давно искал"];

    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageVC"];
    self.pageViewController.dataSource = self;
    
    MainViewController1 *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0,
                                                    [[self view] bounds].size.width, [[self view] bounds].size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    
    
   
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"viewControllerToPopularBooks" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MainViewController1 *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MainViewController1 *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Helper methods
- (MainViewController1 *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    MainViewController1 *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC1"];
    pageContentViewController.imageFile = self.backgrounds[index];
    //pageContentViewController.bg1Label = self.pageTitles[index];
    pageContentViewController.bg1Label.text = @"sdssadasdasdssafadsadsadsadasdasd";
    pageContentViewController.pageIndex = index;
    
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end

























































