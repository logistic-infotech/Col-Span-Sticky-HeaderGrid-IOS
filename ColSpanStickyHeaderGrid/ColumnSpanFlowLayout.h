//
//  LessBoringFlowLayout.h
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnSpanFlowLayout : UICollectionViewFlowLayout {
    
    
    NSIndexPath *indexPathSelected;
    NSIndexPath *indexPathLastSel;
    
    BOOL isHeaderStiky;
    
}

@property (nonatomic, assign) BOOL isHeaderStiky;
@property (nonatomic, retain) NSIndexPath *indexPathSelected;
@property (nonatomic, retain) NSIndexPath *indexPathLastSel;

@end
