//
//  DBHTETableViewController.m
//  TableExpanded
//
//  Created by Debug Hercules on 8/22/17.
//  Copyright © 2017 debughercules. All rights reserved.
//

#import "DBHTETableViewController.h"

#import <QuartzCore/QuartzCore.h>

#define kSectionTag 1110
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface DBHTETableViewController () {
    UITableViewStyle emTableStyle;
    
    NSMutableArray *sections;
    NSMutableArray *sectionsOpened;
    
    NSObject <DBHTETableDelegate> *emDelegate;
    
    NSUInteger openedSection;
    EMAnimationType animationType;
    
    NSInteger showedCell;
}

@end

@implementation DBHTETableViewController

@synthesize closedSectionIcon = _closedSectionIcon;
@synthesize openedSectionIcon = _openedSectionIcon;
@synthesize tableView = _tableView;
@synthesize sectionsHeaders = _sectionsHeaders;
@synthesize sectionsFooters = _sectionsFooters;
@synthesize defaultOpenedSection = _defaultOpenedSection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showedCell = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Exposed Methods
- (void) setEmTableView:(UITableView *)tv {
    self.view = [[UIView alloc] initWithFrame:tv.frame];
    
    _tableView = tv;
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self.view addSubview:_tableView];
}

- (id) initWithTable:(UITableView *)tableView withAnimationType:(EMAnimationType) type {
    if (self = [super init]) {
        self.view = [[UIView alloc] initWithFrame:tableView.frame];
        
        _tableView = tableView;
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        
        animationType = type;
        sections = [[NSMutableArray alloc] initWithCapacity:0];
        sectionsOpened = [[NSMutableArray alloc] initWithCapacity:0];
        openedSection = -1;
        
        self.sectionsHeaders = [[NSMutableArray alloc] initWithCapacity:0];
        self.sectionsFooters = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void) setDelegate: (NSObject <DBHTETableDelegate> *) delegate {
    emDelegate = delegate;
}

- (void) addAccordionSection: (DBHTESection *) section initiallyOpened:(BOOL)opened {
    [sections addObject:section];

    NSInteger index = sections.count - 1;
    
    [sectionsOpened addObject:[NSNumber numberWithBool:opened]];
    if (index == self.defaultOpenedSection) {
        [sectionsOpened setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:index];
    }
    
}


#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DBHTESection *dbhteSection = [sections objectAtIndex:section];
    BOOL value = [[sectionsOpened objectAtIndex:section] boolValue];
    
    if (value)
        return dbhteSection.items.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([emDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)])
        return [emDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
    else
        [NSException raise:@"The delegate doesn't respond tableView:cellForRowAtIndexPath:" format:@"The delegate doesn't respond tableView:cellForRowAtIndexPath:"];
    
    return NULL;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([emDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        return [emDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    else
        [NSException raise:@"The delegate doesn't respond tableView:didSelectRowAtIndexPath:" format:@"The delegate doesn't respond tableView:didSelectRowAtIndexPath:"];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {    
    return tableView.sectionHeaderHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DBHTESection *emAccordionSection = [sections objectAtIndex:section];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, tableView.sectionHeaderHeight)];
    [sectionView setBackgroundColor:emAccordionSection.backgroundColor];
    
    UILabel *cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, self.tableView.frame.size.width - 50.0f, sectionView.bounds.size.height)];
    [cellTitle setText:emAccordionSection.title];
    [cellTitle setTextColor:emAccordionSection.titleColor];
    [cellTitle setBackgroundColor:[UIColor clearColor]];
    [cellTitle setFont:emAccordionSection.titleFont];
    [sectionView addSubview:cellTitle];
    
    [self.sectionsHeaders insertObject:sectionView atIndex:section];

    if ([emDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
        return [emDelegate tableView:tableView viewForHeaderInSection:section];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return tableView.sectionFooterHeight;
}

   // custom view for footer. will be adjusted to default or specified footer height
- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, tableView.sectionFooterHeight)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *accessoryIV = [[UIImageView alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 40.0f, (sectionView.frame.size.height / 2) - 15.0f, 30.0f, 30.0f)];
    BOOL value = [[sectionsOpened objectAtIndex:section] boolValue];
    [accessoryIV setBackgroundColor:[UIColor clearColor]];
    if (value)
        [accessoryIV setImage:self.openedSectionIcon];
    else
        [accessoryIV setImage:self.closedSectionIcon];
    
    [sectionView addSubview:accessoryIV];
    
    UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, sectionView.frame.size.width, sectionView.frame.size.height)];
    sectionBtn.backgroundColor = [UIColor redColor];
    sectionBtn.alpha = 0.1;
    [sectionBtn addTarget:self action:@selector(openTheSection:) forControlEvents:UIControlEventTouchDown];
    [sectionBtn setTag:(kSectionTag + section)];
    [sectionView addSubview:sectionBtn];
    
    [self.sectionsFooters insertObject:sectionView atIndex:section];
    
    if ([emDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
        return [emDelegate tableView:tableView viewForFooterInSection:section];
    
    return sectionView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([emDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        return [emDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    else
        [NSException raise:@"The delegate doesn't respond ew:heightForRowAtIndexP:" format:@"The delegate doesn't respond ew:heightForRowAtIndexP:"];
    
    return 0.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        
        
        DBHTESection *dbhteSection = [sections objectAtIndex:indexPath.section];
        
        [dbhteSection.items removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}


- (IBAction)openTheSection:(id)sender {
    int index = (int)[sender tag] - kSectionTag;
    
    BOOL value = [[sectionsOpened objectAtIndex:index] boolValue];
    NSNumber *updatedValue = [NSNumber numberWithBool:!value];
    
    [sectionsOpened setObject:updatedValue atIndexedSubscript:index];
    
    openedSection = index;

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [emDelegate latestSectionOpened];
}


@end
