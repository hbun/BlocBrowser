//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Husam Al-Ziab on 8/13/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didPinchWithScale:(CGFloat)scale;

@end

@interface AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void)addButtons;
- (void)buttonTapped:(UIButton *)button;
- (void)setEnabled:(BOOL)enabled forButton:(UIButton *)button;
 
@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;
@property (nonatomic, retain)UIButton *backButton;
@property (nonatomic, retain)UIButton *forwardButton;
@property (nonatomic, retain)UIButton *stopButton;
@property (nonatomic, retain)UIButton *reloadButton;

@end
