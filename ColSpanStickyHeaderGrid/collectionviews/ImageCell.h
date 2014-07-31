//
//  ColorNameCell.h
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageBean;

@interface ImageCell : UICollectionViewCell {
    
    IBOutlet UIImageView *imgView;
    ImageBean *imgBean;
    
}

@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) ImageBean *imgBean;

-(void)setImgBeanObj:(ImageBean *)imgB;


@end
