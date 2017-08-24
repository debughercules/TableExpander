//
//  DBHTETableViewController.h
//  TableExpanded
//
//  Created by Debug Hercules on 8/22/17.
//  Copyright © 2017 debughercules. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBHTESection.h"

typedef NS_ENUM(NSUInteger, EMAnimationType) {
    EMAnimationTypeNone,
    EMAnimationTypeBounce,
};

@protocol DBHTETableDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) latestSectionOpened;

@optional
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

@end

@interface DBHTETableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImage * closedSectionIcon;
@property (nonatomic, strong) UIImage * openedSectionIcon;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionsHeaders;
@property (nonatomic, strong) NSMutableArray *sectionsFooters;
@property (nonatomic) NSInteger defaultOpenedSection;

- (id) initWithTable:(UITableView *)tableView withAnimationType:(EMAnimationType) type;

- (void) addAccordionSection: (DBHTESection *) section initiallyOpened:(BOOL)opened;
- (void) setDelegate: (NSObject <DBHTETableDelegate> *) delegate;

@end
