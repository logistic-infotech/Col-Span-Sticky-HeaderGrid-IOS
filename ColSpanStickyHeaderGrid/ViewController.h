//
//  ViewController.h
//  UConnGrid
//
//  Created by Chintan on 23/01/14.
//  Copyright (c) 2014 Logistic Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColumnSpanFlowLayout;

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    
    NSMutableArray *arrSection;
    
    NSIndexPath *indexPathSelected;
    NSIndexPath *indexPathLastSel;
    
    ColumnSpanFlowLayout *layout;
}


@end
