//
//  TabBarController.m
//  KitappApplication
//
//  Created by Olga Khvan on 09.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "TabBarController.h"
#import "UIImage+Scale.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
  //  UITabBarItem *item3 = [tabBar.items objectAtIndex:3];

    tabBar.tintColor = [UIColor brownColor];
    
    tabBar.backgroundColor = UIColorFromRGB(0xABABAB);
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    UIColor *titleHighlightedColor = [UIColor brownColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor,
                                                       NSForegroundColorAttributeName,
                                                       nil]
                                             forState:UIControlStateSelected];
    UIImage *item0Image = [UIImage imageNamed:@"allBooksIcon.png"];
    item0Image = [item0Image scaledToSize:CGSizeMake(27, 27)];
    item0.image = item0Image;
    
    UIImage *item2Image = [UIImage imageNamed:@"myProfileIcon.png"];
    item2Image = [item2Image scaledToSize:CGSizeMake(27, 27)];
    item2.image = item2Image;
    
    UIImage *item1Image = [UIImage imageNamed:@"addBookIcon.png"];
    item1Image = [item1Image scaledToSize:CGSizeMake(27, 27)];
    item1.image = item1Image;
    
    /*UIImage *item3Image = [UIImage imageNamed:@"homeIcon.png"];
    item3Image = [item3Image scaledToSize:CGSizeMake(27, 27)];
    item3.image = item3Image;*/
    
    item0.title = @"Все книги";
    item1.title = @"Добавить книгу";
    item2.title = @"Профиль";
   // item3.title = @"Мои книги";
    
    

    
    self.tabBar.backgroundColor = [UIColor brownColor];
    //UIImage *tabBarBackgroundImage = [UIImage imageNamed:@"tabBarBackgroundImage.png"];
    //self.tabBar.backgroundImage = tabBarBackgroundImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Assign tab bar item with titles

    
    /*[tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"home_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home.png"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"maps_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"maps.png"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"myplan_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"myplan.png"]];
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"settings_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings.png"]];*/
    
    return YES;
}



@end
