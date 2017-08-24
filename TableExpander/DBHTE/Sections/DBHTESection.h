//
//  DBHTESection.h
//  TableExpanded
//
//  Created by Debug Hercules on 8/22/17.
//  Copyright © 2017 debughercules. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DBHTESection : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@end
