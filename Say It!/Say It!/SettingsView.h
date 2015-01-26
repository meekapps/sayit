//
//  SettingsView.h
//  Say It!
//
//  Created by Mike Keller on 10/1/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewDelegate <NSObject>
- (void) didTapContactDeveloper;
@end

@interface SettingsView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *settingsContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (nonatomic) CGPoint startingPoint;

@property (unsafe_unretained, nonatomic) id <SettingsViewDelegate> delegate;

- (id) initFromPoint:(CGPoint)point;
- (void) show;
- (void) hide;
- (IBAction)tapAction:(id)sender;
- (IBAction)contactDeveloper:(id)sender;

@end
