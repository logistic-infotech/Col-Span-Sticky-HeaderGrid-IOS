//
//  ColorSectionHeaderView.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "ColorSectionHeaderView.h"

@interface ColorSectionHeaderView ()

@property (retain, nonatomic) IBOutlet UILabel *sectionHeaderLabel;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteSectionPressed:(id)sender;

@end


@implementation ColorSectionHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _sectionIndex = NSNotFound;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _sectionIndex = NSNotFound;
    self.hideDelete = YES;
}

- (void)setHideDelete:(BOOL)hideDelete
{
    _hideDelete = hideDelete;
    self.deleteButton.hidden = hideDelete;
}

- (void)setSectionIndex:(NSUInteger)sectionIndex
{
    _sectionIndex = sectionIndex;
    self.sectionHeaderLabel.text = [NSString stringWithFormat:@"Section %ld", sectionIndex+1];
}

- (IBAction)deleteSectionPressed:(id)sender
{
    //[self.delegate colorSectionHeaderDeleteSectionPressed:self];
}
@end
