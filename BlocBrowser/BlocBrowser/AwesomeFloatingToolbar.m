//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Husam Al-Ziab on 8/13/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *holdGesture;

@end

@implementation AwesomeFloatingToolbar

@synthesize backButton;
@synthesize forwardButton;
@synthesize stopButton;
@synthesize reloadButton;

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];

    if (self) {
    
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        [self addButtons];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.holdGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(holdFired:)];
        [self addGestureRecognizer:self.holdGesture];
    }
    return self;
}

- (void) addButtons {
    
    NSLog(@"%f", (CGRectGetHeight(super.bounds)));
    
    //Back
    self.backButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 140, 30);
    [self.backButton setTitle:self.currentTitles[0] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backButton.backgroundColor = self.colors[0];
    self.backButton.alpha = 0.25;
    [self.backButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    //Forward
    self.forwardButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardButton.frame = CGRectMake(CGRectGetWidth(backButton.bounds), 0, 140, 30);
    [self.forwardButton setTitle:self.currentTitles[1] forState:UIControlStateNormal];
    self.forwardButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.forwardButton.backgroundColor = self.colors[1];
    self.forwardButton.alpha = 0.25;
    [self.forwardButton setEnabled:YES];
    [self.forwardButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.forwardButton];
    
    //Stop
    self.stopButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.stopButton.frame = CGRectMake(0, CGRectGetHeight(backButton.bounds), 140, 30);
    [self.stopButton setTitle:self.currentTitles[2] forState:UIControlStateNormal];
    self.stopButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.stopButton.backgroundColor = self.colors[2];
    self.stopButton.alpha = 0.25;
    [self.stopButton setEnabled:YES];
    [self.stopButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.stopButton];
    
    //Reload
    self.reloadButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.reloadButton.frame = CGRectMake(CGRectGetWidth(backButton.bounds), CGRectGetHeight(backButton.bounds), 140, 30);
    [self.reloadButton setTitle:self.currentTitles[3] forState:UIControlStateNormal];
    self.reloadButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.reloadButton.backgroundColor = self.colors[3];
    self.reloadButton.alpha = 0.25;
    [self.reloadButton setEnabled:YES];
    
    [self.reloadButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reloadButton];
    
}


- (void)buttonTapped:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
        [self.delegate floatingToolbar:self didSelectButtonWithTitle:button.titleLabel.text];
    }
    
}


- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) { // If a gesture is recognized
        CGPoint translation = [recognizer translationInView:self]; //Take note of the CGPoint as finger moves
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation)); // Log the current finger coord
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) { // Not sure what this does.
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self]; // sets new coords to 0,0 during each minipan
    }
}

- (void) holdFired:(UILongPressGestureRecognizer *)recognizer {
    recognizer.minimumPressDuration = 0.7;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        NSMutableArray *mutableColors = [self.colors mutableCopy];
        
        NSObject *obj = [mutableColors lastObject];
        [mutableColors insertObject:obj atIndex:0];
        [mutableColors removeLastObject];
        self.colors = mutableColors;
        self.backButton.backgroundColor = mutableColors[0];
        self.forwardButton.backgroundColor = mutableColors[1];
        self.stopButton.backgroundColor = mutableColors[2];
        self.reloadButton.backgroundColor = mutableColors[3];
    }
}

- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
        CGFloat scale = recognizer.scale;
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didPinchWithScale:)]){
            [self.delegate floatingToolbar:self didPinchWithScale:scale];
        }
}


#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButton:(UIButton *)button {
    button.alpha = enabled ? 1.0 : 0.25;
}

@end
