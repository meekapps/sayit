//
//  MainViewController.h
//  Say It!
//
//  Created by Mike Keller on 10/1/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsView.h"
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController <ADBannerViewDelegate, SettingsViewDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet ADBannerView *adView;
@property (nonatomic) BOOL displayedAd;

- (IBAction)sayIt:(id)sender;
- (IBAction)clearAction:(id)sender;

@end
