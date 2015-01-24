//
//  MainViewController.m
//  Say It!
//
//  Created by Mike Keller on 10/1/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Genie.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayedAd = NO;
    
    [self.adView removeFromSuperview];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.textView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    self.textView.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"text"];
    
    self.adView.frame = CGRectMake(self.adView.frame.size.width, 20.0f, self.adView.frame.size.width, self.adView.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) handleShowKeyboard:(NSNotification*)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    // Get keyboard size.
    NSValue *endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [self.view convertRect:endFrameValue.CGRectValue fromView:nil];
    
    // Get keyboard animation.
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Create animation.
    CGRect controlsViewFrame = self.controlsView.frame;
    controlsViewFrame.origin.y -= keyboardEndFrame.size.height;
    
    // Begin animation.
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.controlsView.frame = controlsViewFrame;
                         CGRect textViewFrame = self.textView.frame;
                         textViewFrame.size.height -= keyboardEndFrame.size.height;
                         self.textView.frame = textViewFrame;
                     }
                     completion:NULL];
}

- (void) handleHideKeyboard:(NSNotification*)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    // Get keyboard size.
    
    NSValue *endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [self.view convertRect:endFrameValue.CGRectValue fromView:nil];
    
    // Get keyboard animation.
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Create animation.
    CGRect controlsViewFrame = self.controlsView.frame;
    controlsViewFrame.origin.y += keyboardEndFrame.size.height;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.controlsView.frame = controlsViewFrame;
                         CGRect textViewFrame = self.textView.frame;
                         textViewFrame.size.height += keyboardEndFrame.size.height;
                         self.textView.frame = textViewFrame;
                     }
                     completion:NULL];
}

#pragma mark - AdView

- (void) bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"banner loaded");
    
    if (self.displayedAd == NO) {
        self.displayedAd = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.adView.frame.size.height-0.5f, self.adView.frame.size.width, 0.5f)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.adView addSubview:lineView];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.textView.frame = CGRectMake(0.0f, self.adView.frame.size.height, self.textView.frame.size.width, self.textView.frame.size.height-self.adView.frame.size.height);
                             self.adView.frame = CGRectMake(0.0f, self.adView.frame.origin.y, self.adView.frame.size.width, self.adView.frame.size.height);
                         }];
    }
}

- (void) bannerViewActionDidFinish:(ADBannerView *)banner {
    NSLog(@"banner view action finish");
}

- (void) bannerViewWillLoadAd:(ADBannerView *)banner {
    NSLog(@"banner view will load ad");
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"banner view failed");
    
    if (self.displayedAd) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                            self.textView.frame = CGRectMake(0.0f, 0.0f, self.textView.frame.size.width, self.textView.frame.size.height + self.adView.frame.size.height);
                             self.adView.frame = CGRectMake(self.adView.frame.size.width, self.adView.frame.origin.y, self.adView.frame.size.width, self.adView.frame.size.height);
                         }];
        
        self.displayedAd = NO;
    }
}

#pragma mark - SettingsView Delegate

- (void) didTapContactDeveloper {
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.navigationBar.tintColor = [UIColor sayitBlueColor];
    mailVC.mailComposeDelegate = self;
    
	//Set E-mail Fields
	NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	NSString *deviceType = [UIDevice currentDevice].model;
	
	NSString *subjectString = [NSString stringWithFormat:@"%@ (%@ - %@)", bundleName, bundleVersion, deviceType];
	[mailVC setSubject:subjectString];
	
	NSString *emailAddress = @"support@meekapps.net";
	[mailVC setToRecipients:[NSArray arrayWithObject:emailAddress]];
	
	NSMutableString *messageBody = [[NSMutableString alloc]initWithString:@""];
	[messageBody appendFormat:@"Hey, your app is awesome but..."];
	
	[mailVC setMessageBody:messageBody isHTML:NO];
    
    [self.navigationController presentViewController:mailVC animated:YES completion:^{
    }];
}

#pragma mark - UITextView Delegate

- (void) textViewDidChange:(UITextView *)textView {
    NSString *text = textView.text;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:text forKey:@"text"];
    [prefs synchronize];
}

#pragma mark - MFMailComposeViewController Delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Actions

- (IBAction)clearAction:(UIButton*)clearButton {
    
    if ([self.textView.text isEqualToString:@""]) return;
    
    UITextView *dummyTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y + 20.0f, self.textView.frame.size.width, self.textView.frame.size.height-20.0f)];
    dummyTextView.text = self.textView.text;
    dummyTextView.font = self.textView.font;
    dummyTextView.textColor = self.textView.textColor;
    dummyTextView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    dummyTextView.layer.opacity = 0.0f;
    
    [self.view addSubview:dummyTextView];
    
    [UIView animateWithDuration:0.15f
                     animations:^{
                         dummyTextView.layer.opacity = 0.5f;
                     } completion:^(BOOL finished) {
                         self.textView.text = @"";
                         
                         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                         [prefs setObject:@"" forKey:@"text"];
                         [prefs synchronize];
                         
                         CGPoint clearPoint = clearButton.center;
                         CGPoint convertedPoint = [clearButton convertPoint:clearPoint toView:self.view];
                         
                         [dummyTextView genieInTransitionWithDuration:0.7f destinationRect:CGRectMake(convertedPoint.x-10.0f, convertedPoint.y, 0.0f, 0.0f)destinationEdge:BCRectEdgeTop completion:^{
                             
                             [dummyTextView removeFromSuperview];
                             
                         }];
                     }];

}

- (IBAction)showSettings:(UIButton*)settingsButton {
    
    CGPoint settingsPoint = settingsButton.center;
    CGPoint convertedPoint = [settingsButton convertPoint:settingsPoint toView:self.view];
    
    SettingsView *settingsView = [[SettingsView alloc] initFromPoint:convertedPoint];
    settingsView.delegate = self;
    [self.view addSubview:settingsView];
    [settingsView show];
}

- (IBAction)sayIt:(id)sender {
    [self.textView resignFirstResponder];
    
    NSString *stringToSpeak = self.textView.text;
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:stringToSpeak];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Rate
    float rate = [prefs floatForKey:@"rate"];
    utterance.rate = rate;
    
    //Pitch
    float pitchMultiplier = [prefs floatForKey:@"pitchMultiplier"];
    utterance.pitchMultiplier = pitchMultiplier;
    
    [synthesizer speakUtterance:utterance];
}

#pragma mark - Finishing Up

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.textView = nil;
    self.controlsView = nil;
    self.adView = nil;
}

@end
