//
//  ColorSectionHeaderView.h
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorSectionHeaderView;

@protocol ColorSectionHeaderDelegate <NSObject>

- (void)colorSectionHeaderDeleteSectionPressed:(ColorSectionHeaderView*)headerView;

@end

@interface ColorSectionHeaderView : UICollectionReusableView

@property (nonatomic, assign) NSUInteger sectionIndex;
@property (nonatomic, assign) BOOL hideDelete;

@property (nonatomic, retain) id<ColorSectionHeaderDelegate> delegate;

@end
