//
//  MainViewController1.h
//  KitappApplication
//
//  Created by Olga Khvan on 06.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol MainViewController1Delegate <NSObject>

-(void) viewIsShown: (NSUInteger) pageIndex;

@end

@interface MainViewController1 : UIViewController


@property (weak, nonatomic) id<MainViewController1Delegate> delegate; 
@property NSUInteger pageIndex;
@property (nonatomic) NSString *imageFile;
@property (nonatomic) NSString *pageTitle;
@property (nonatomic) NSString *pageDescription;

@end
