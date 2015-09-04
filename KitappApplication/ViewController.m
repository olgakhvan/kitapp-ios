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


@interface ViewController () <MainViewController1Delegate>

@property (nonatomic) UIButton *signupButton;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIButton *nextButton;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    //[self.view addSubview:pageControl];
    _signupButton = [UIButton new];
    _loginButton = [UIButton new];
    _nextButton = [UIButton new];
    

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

    //signup button
    _signupButton.layer.masksToBounds = YES;
    //_signupButton.layer.cornerRadius = 5.f;
    _signupButton.layer.borderWidth = 1.f;
    [_signupButton setTitle:@"Регистрация" forState:UIControlStateNormal];
    _signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _signupButton.layer.borderColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    [self.view addSubview:_signupButton];
    
    _signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_signupButton(130)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_signupButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_signupButton(45)]-15-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_signupButton)]];
    [_signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    
    //login button
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"Войти" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _loginButton.layer.backgroundColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_loginButton];
    
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_loginButton(130)]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_loginButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_loginButton(45)]-15-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_loginButton)]];
    
    //next button
    _nextButton.layer.masksToBounds = YES;
    [_nextButton setTitle:@"Дальше" forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _nextButton.layer.backgroundColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    [_nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_nextButton];
    
    _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_nextButton(130)]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_nextButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nextButton(45)]-15-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_nextButton)]];

    
    // initial visibility
    _loginButton.hidden = YES;
    _signupButton.hidden = YES;
    _nextButton.hidden = NO;
   
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
    pageContentViewController.pageText = self.pageTitles[index];;
    pageContentViewController.pageIndex = index;
    pageContentViewController.delegate = self;
    
    return pageContentViewController;
}

#pragma mark - IBOutlet methods

-(void) signupButtonPressed:(UIButton *)button
{
    [self performSegueWithIdentifier:@"VCToSignUpVC" sender:self];
}

-(void) loginButtonPressed: (UIButton *) button{
    [self performSegueWithIdentifier:@"VCToLoginVC" sender:self];
}

-(void) nextButtonPressed: (UIButton *) button{
    MainViewController1 *viewController = (MainViewController1 *)[self.pageViewController.viewControllers objectAtIndex:0];
    NSLog(@"page index = %d", viewController.pageIndex);
    
    if (viewController.pageIndex+1 >= self.pageTitles.count) {
        return;
    }
    
    MainViewController1 *startingViewController = [self viewControllerAtIndex:viewController.pageIndex + 1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    
}


-(void)viewIsShown:(NSUInteger)pageIndex
{
    if (pageIndex == self.pageTitles.count - 1) {
        //last page
        _nextButton.hidden = YES;
        _signupButton.hidden = NO;
        _loginButton.hidden = NO;
    } else {
        _nextButton.hidden = NO;
        _signupButton.hidden = YES;
        _loginButton.hidden = YES;

    }
}


//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return [self.pageTitles count];
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}


@end

























































