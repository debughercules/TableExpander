//
//  ViewController.m
//  TableExpander
//
//  Created by Bharat Byan on 25/08/17.
//  Copyright © 2017 Bharat Byan. All rights reserved.
//

#import "ViewController.h"

#define kTableSectionHeaderHeight 80.0f
#define kTableSectionFooterHeight 40.0f
#define kTableRowHeight 40.0f

@interface ViewController () {
    DBHTETableViewController *dbhteTV;
}

@end

@implementation ViewController{
    
    NSMutableArray *dataSection00;
    NSMutableArray *dataSection01;
    NSMutableArray *dataSection02;
    
    NSArray *sections;
    CGFloat origin;
    UITableView *mTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    
    // Setup the DBHTETableViewController
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [mTableView setSectionHeaderHeight:kTableSectionHeaderHeight];
    [mTableView setSectionFooterHeight:kTableSectionFooterHeight];
    /*
     ... set here some other tableView properties ...
     */
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mTableView.frame.size.width, 20.0f)];
    [headerView setBackgroundColor:[UIColor orangeColor]];
    headerView.alpha = 0.1;
    [mTableView setTableHeaderView:headerView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mTableView.frame.size.width, 20.0f)];
    [footerView setBackgroundColor:[UIColor yellowColor]];
    footerView.alpha = 0.1;
    [mTableView setTableFooterView:footerView];
    
    // Setup the DBHTETableViewController
    dbhteTV = [[DBHTETableViewController alloc] initWithTable:mTableView withAnimationType:EMAnimationTypeNone];
    [dbhteTV setDelegate:self];
    
    [dbhteTV setClosedSectionIcon:[UIImage imageNamed:@"closedIcon"]];
    [dbhteTV setOpenedSectionIcon:[UIImage imageNamed:@"openedIcon"]];
    
    
    // Setup some test data
    dataSection00 = [[NSMutableArray alloc] initWithObjects:@"0 0", @"0 1", @"0 2", @"0 3", @"0 4", @"0 5", @"0 6", nil];
    dataSection01 = [[NSMutableArray alloc] initWithObjects:@"1 0", @"1 1", @"1 2", @"1 3", @"1 4", @"1 5", @"1 6", @"1 7", @"1 8", @"1 9", @"1 10", @"1 11", @"1 12", @"1 13", @"1 14", nil];
    dataSection02 = [[NSMutableArray alloc] initWithObjects:@"2 0", @"2 1", @"2 2", nil];
    
    // Section graphics
    UIColor *sectionsColor = [UIColor colorWithRed:62.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
    UIColor *sectionTitleColor = [UIColor whiteColor];
    UIFont *sectionTitleFont = [UIFont fontWithName:@"Futura" size:24.0f];
    
    dbhteTV.defaultOpenedSection = 5;
    
    // Add the sections to the controller
    DBHTESection *section00 = [[DBHTESection alloc] init];
    [section00 setBackgroundColor:sectionsColor];
    [section00 setItems:dataSection00];
    [section00 setTitle:@"Section 0"];
    [section00 setTitleFont:sectionTitleFont];
    [section00 setTitleColor:sectionTitleColor];
    [dbhteTV addAccordionSection:section00 initiallyOpened:YES];
    
    DBHTESection *section01 = [[DBHTESection alloc] init];
    [section01 setBackgroundColor:sectionsColor];
    [section01 setItems:dataSection01];
    [section01 setTitle:@"Section 1"];
    [section01 setTitleColor:sectionTitleColor];
    [section01 setTitleFont:sectionTitleFont];
    [dbhteTV addAccordionSection:section01 initiallyOpened:NO];
    
    DBHTESection *section02 = [[DBHTESection alloc] init];
    [section02 setBackgroundColor:sectionsColor];
    [section02 setItems:dataSection02];
    [section02 setTitle:@"Section 2"];
    [section02 setTitleColor:sectionTitleColor];
    [section02 setTitleFont:sectionTitleFont];
    [dbhteTV addAccordionSection:section02 initiallyOpened:YES];
    
    sections = [[NSArray alloc] initWithObjects:section00, section01, section02, nil];
    
    [self.view addSubview:dbhteTV.tableView];
}

#pragma mark DBHTETableDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emCell"];
    
    NSMutableArray *items = [self dataFromIndexPath:indexPath];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, self.view.bounds.size.width - origin*2 - 10.0f, kTableRowHeight)];
    [titleLbl setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:12.0f]];
    [titleLbl setText:[items objectAtIndex:indexPath.row]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    
    [[cell contentView] addSubview:titleLbl];
    
    cell.alpha = 0.0f;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableRowHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHTESection *section = [sections objectAtIndex:indexPath.section];
    NSMutableArray *items = [self dataFromIndexPath:indexPath];
    
    NSLog(@"%@", [[NSString alloc] initWithFormat:@"%@ : %@", section.title, [items objectAtIndex:indexPath.row]]);
}

- (NSMutableArray *) dataFromIndexPath: (NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return dataSection00;
    else if (indexPath.section == 1)
        return dataSection01;
    else if (indexPath.section == 2)
        return dataSection02;
    
    return NULL;
}

- (void) latestSectionOpened {
    NSLog(@"section opened");
    
    [mTableView reloadData];
}

@end

