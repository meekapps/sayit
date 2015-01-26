//
//  SettingsView.m
//  Say It!
//
//  Created by Mike Keller on 10/1/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

- (instancetype) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {}
  return self;
}

- (instancetype) initFromPoint:(CGPoint)point {
  self = [[NSBundle mainBundle]loadNibNamed:@"SettingsView"
                                       owner:self
                                     options:nil][0];
  self.frame = CGRectMake(0.0f,
                          0.0f,
                          [UIScreen mainScreen].bounds.size.width,
                          [UIScreen mainScreen].bounds.size.height);
  
  self.layer.opacity = 0.0f;
  self.settingsContainer.layer.transform = CATransform3DMakeScale(0.01f,
                                                                  0.01f,
                                                                  1.0f);
  self.settingsContainer.layer.opacity = 0.0f;
  self.settingsContainer.layer.cornerRadius = 8.0f;
  self.settingsContainer.layer.shadowColor = [UIColor blackColor].CGColor;
  self.settingsContainer.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
  self.settingsContainer.layer.shadowOpacity = 0.2f;
  self.settingsContainer.layer.shadowRadius = 2.0f;
  self.settingsContainer.layer.shadowPath =
  [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f,
                                                     0.0f,
                                                     self.settingsContainer.frame.size.width,
                                                     self.settingsContainer.frame.size.height)
                             cornerRadius:self.settingsContainer.layer.cornerRadius].CGPath;
  self.startingPoint = point;
  self.bottomSpaceConstraint.constant = point.y;

  return self;
}

- (void) show {
  [UIView animateWithDuration:0.5f
                        delay:0.0f
       usingSpringWithDamping:0.8f
        initialSpringVelocity:0.0f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     self.layer.opacity = 1.0f;
   self.settingsContainer.layer.opacity = 1.0f;
   self.settingsContainer.layer.transform = CATransform3DIdentity;
  } completion:^(BOOL finished) {
  }];
}

- (void) hide {
  [UIView animateWithDuration:0.25f
                   animations:^{
                     self.layer.opacity = 0.0f;
                   } completion:^(BOOL finished) {
                   }];
}

#pragma mark - Actions

- (IBAction)contactDeveloper:(id)sender {
  [self hide];
    
  if (self.delegate && [self.delegate respondsToSelector:@selector(didTapContactDeveloper)]) {
    [self.delegate didTapContactDeveloper];
  }
}

- (IBAction)tapAction:(id)sender {
  [self hide];
}

- (void) changeSlider:(UISlider*)sender {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  
  //Rate
  if (sender.tag == 0) {
    [prefs setFloat:sender.value forKey:@"rate"];
      
  //Pitch
  } else if (sender.tag == 1) {
    float pitchMultiplier = sender.value * 2.0f;
    [prefs setFloat:pitchMultiplier forKey:@"pitchMultiplier"];
  }
  
  [prefs synchronize];
}

#pragma mark - UITableView Delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellID = @"CellID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 190.0f, 40.0f)];
    [slider addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventTouchUpOutside];
    [slider addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventTouchCancel];
    cell.accessoryView = slider;
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
  cell.textLabel.textColor = [UIColor darkGrayColor];
  cell.textLabel.textAlignment = NSTextAlignmentLeft;
  
  UISlider *thisSlider = (UISlider*)cell.accessoryView;
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  
  //Rate
  if (indexPath.row == 0) {
    cell.textLabel.text = @"Rate";
    float rate = [prefs floatForKey:@"rate"];
    thisSlider.value = rate;
    thisSlider.tag = 0;
      
  //Pitch
  } else {
    cell.textLabel.text = @"Pitch";
    float pitchMultiplier = [prefs floatForKey:@"pitchMultiplier"];
    pitchMultiplier = pitchMultiplier/2.0f;
    thisSlider.value = pitchMultiplier;
    thisSlider.tag = 1;
  }
  
  return cell;
}


#pragma - Finishing Up

- (void) dealloc {
    self.settingsContainer = nil;
    self.tableView = nil;
    self.delegate = nil;
}

@end
