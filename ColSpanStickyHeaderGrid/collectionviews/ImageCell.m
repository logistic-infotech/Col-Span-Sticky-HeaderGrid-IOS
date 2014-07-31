//
//  ColorNameCell.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "ImageCell.h"
#import "ImageBean.h"

#import <QuartzCore/QuartzCore.h>

@implementation ImageCell

@synthesize imgBean;
@synthesize imgView;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //self.backgroundColor = [UIColor whiteColor];
    self.imgView.image = nil;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    //self.backgroundColor = [UIColor whiteColor];
    self.imgView.image = nil;
}

-(void)setImgBeanObj:(ImageBean *)imgB {
    self.imgBean = imgB;
    //NSLog(@"imgB.strName >> %@",imgB.strName);
    self.imgView.image = [UIImage imageNamed:imgB.strName];
}



@end
