//
//  LessBoringFlowLayout.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "ColumnSpanFlowLayout.h"
#import <objc/runtime.h>


@implementation ColumnSpanFlowLayout

@synthesize isHeaderStiky;
@synthesize indexPathSelected;
@synthesize indexPathLastSel;

- (id)init
{
    self = [super init];
    if (self)
    {
        //self.currentCellAttributes = [NSMutableDictionary dictionary];
        //self.currentSupplementaryAttributesByKind = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - Subclass

- (void)prepareLayout
{
    [super prepareLayout];
    
    // Deep-copy attributes in current cache
    //    self.cachedCellAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.currentCellAttributes copyItems:YES];
    //    self.cachedSupplementaryAttributesByKind = [NSMutableDictionary dictionary];
    //    [self.currentSupplementaryAttributesByKind enumerateKeysAndObjectsUsingBlock:^(NSString *kind, NSMutableDictionary * attribByPath, BOOL *stop) {
    //        NSMutableDictionary * cachedAttribByPath = [[NSMutableDictionary alloc] initWithDictionary:attribByPath copyItems:YES];
    //        [self.cachedSupplementaryAttributesByKind setObject:cachedAttribByPath forKey:kind];
    //    }];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    //NSLog(@"layoutAttributesForItemAtIndexPath frame >> %@ row : %d",NSStringFromCGRect(attributes.frame),indexPath.row);
    if([indexPathSelected isEqual:indexPath]) {
        //NSLog(@"layoutAttributesForItemAtIndexPath in IF");
    }
    
    return [self getModifiedAttributeForRow:attributes];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:[indexPath retain]];
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        attributes = [self getModifiedAttributeForSection:attributes];
    }
    
    if(isHeaderStiky) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            UICollectionView * const cv = self.collectionView;
            CGPoint const contentOffset = cv.contentOffset;
            CGPoint nextHeaderOrigin = CGPointMake(INFINITY, INFINITY);
            
            if (indexPath.section+1 < [cv numberOfSections]) {
                UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section+1]];
                nextHeaderOrigin = nextHeaderAttributes.frame.origin;
            }
            
            CGRect frame = attributes.frame;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                frame.origin.y = MIN(MAX(contentOffset.y, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame));
            }
            else { // UICollectionViewScrollDirectionHorizontal
                frame.origin.x = MIN(MAX(contentOffset.x, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame));
            }
            attributes.zIndex = 1024;
            attributes.frame = frame;
            //NSLog(@"Header Origin Changed >> %@",NSStringFromCGRect(attributes.frame));
        }
    }
    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    rect.origin.x = rect.origin.x - 120;
    rect.size.height = rect.size.height + 240;
    
    NSMutableArray * attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    // Always cache all visible attributes so we can use them later when computing final/initial animated attributes
    // Never clear the cache as certain items may be removed from the attributes array prior to being animated out
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            [self getModifiedAttributeForRow:attributes];
            
            //[self.currentCellAttributes setObject:[self getModifiedAttributeForRow:attributes]
            //                               forKey:attributes.indexPath];
            
            //NSLog(@"layoutAttributesForElementsInRect UICollectionElementCategoryCell frame >> %@ row : %d",NSStringFromCGRect(attributes.frame), attributes.indexPath.row);
        }
        else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView)
        {
            //NSMutableDictionary *supplementaryAttribuesByIndexPath = [self.currentSupplementaryAttributesByKind objectForKey:attributes.representedElementKind];
            //if (supplementaryAttribuesByIndexPath == nil)
            //{
            //    supplementaryAttribuesByIndexPath = [NSMutableDictionary dictionary];
            //[self.currentSupplementaryAttributesByKind setObject:supplementaryAttribuesByIndexPath forKey:attributes.representedElementKind];
            //}
            
            [self getModifiedAttributeForSection:attributes];
            //attributes.zIndex = 1;
            //[supplementaryAttribuesByIndexPath setObject:[self getModifiedAttributeForSection:attributes]
            //                                      forKey:attributes.indexPath];
            
            //NSLog(@"layoutAttributesForElementsInRect UICollectionElementCategorySupplementaryView frame >> %@",NSStringFromCGRect(attributes.frame));
        }
        
        
    }];
    
    
    //NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    if(isHeaderStiky) {
        NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
        for (NSUInteger idx=0; idx<[attributes count]; idx++) {
            UICollectionViewLayoutAttributes *layoutAttributes = attributes[idx];
            
            if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
                [missingSections addIndex:layoutAttributes.indexPath.section];  // remember that we need to layout header for this section
            }
            if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [attributes removeObjectAtIndex:idx];  // remove layout of header done by our super, we will do it right later
                idx--;
            }
        }
        
        // layout all headers needed for the rect using self code
        [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
            UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            if (layoutAttributes != nil) {
                [attributes addObject:layoutAttributes];
            }
        }];
    }
    return attributes;
}


- (CGSize)collectionViewContentSize {
    
    int count = [self.collectionView numberOfItemsInSection:indexPathSelected.section];
    
    if(indexPathSelected.row % 2 == 1 && count%2 == 1) {
        int noOfSec = [self.collectionView numberOfSections];
        int heightForRows = 0;
        int heightForColumns = 0;
        //NSLog(@">>>>>> Looping from : %d to %d",indexPathSelected.section, indexCurr.section);
        for (int i=0; i < noOfSec; i++) {
            
            int actualRows = [self getActualRowForSection:i];
            
            heightForRows = heightForRows + actualRows * self.itemSize.height;
            
            NSIndexPath *indexSection = [NSIndexPath indexPathForRow:0 inSection:i];
            CGRect rectHeader = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexSection].frame;
            heightForColumns = heightForColumns + rectHeader.size.height;
            //NSLog(@">>>>>>>>>> rows : %d >> actualRows : %d >> heightForRows : %d For Section : %d", countRows, actualRows, heightForRows, i);
            
        }
        
        //NSLog(@">>>>>>>>>>>>>> Final heightForRows : %d", heightForRows);
        int totalHeight = heightForRows + heightForColumns;
        return CGSizeMake(320, totalHeight);
    }
    
    return [super collectionViewContentSize];
}

-(UICollectionViewLayoutAttributes *) getModifiedAttributeForSection:(UICollectionViewLayoutAttributes *)attributes
{
    //    if(indexPathSelected == nil) {
    //        return attributes;
    //    }
    
    NSIndexPath *indexCurr = attributes.indexPath;
    CGRect rectHeader = attributes.frame;
    
    if(indexPathSelected.row % 2 == 1 && indexPathSelected.section < indexCurr.section)
    {
        //NSLog(@"getModifiedAttributeForSection calculating for > %d",indexCurr.section);
        int count = [self.collectionView numberOfItemsInSection:indexPathSelected.section];
        
        if (count%2 == 1) {
            //int section = indexCurr.section + 1;
            int heightForRows = 0;
            int heightForColumns = 0;
            //NSLog(@">>>>>> Looping from : %d to %d",indexPathSelected.section, indexCurr.section);
            for (int i=0; i< indexCurr.section; i++) {
                
                int actualRows = [self getActualRowForSection:i];
                
                heightForRows = heightForRows + actualRows * self.itemSize.height;
                
                //NSLog(@">>>>>>>>>> rows : %d >> actualRows : %d >> heightForRows : %d For Section : %d", countRows, actualRows, heightForRows, i);
                
                
                NSIndexPath *indexSection = [NSIndexPath indexPathForRow:0 inSection:i];
                CGRect rectHeader = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexSection].frame;
                heightForColumns = heightForColumns + rectHeader.size.height;
            }
            
            //NSLog(@">>>>>>>>>>>>>> Final heightForRows : %d", heightForRows);
            int yheader = heightForRows + heightForColumns;
            //NSLog(@">>>>>>>>>>>>>> headerPosition yheader : %d", yheader);
            attributes.frame = CGRectMake(0, yheader, rectHeader.size.width, rectHeader.size.height);
            
        }
    }
    
    return attributes;
}

-(CGRect) getHeaderFrameAtIndex:(NSIndexPath*)indexPath {
    //int section = indexCurr.section + 1;
    int heightForRows = 0;
    int heightForColumns = 0;
    
    //NSLog(@">>>>>> Looping from : %d to %d",indexPathSelected.section, indexCurr.section);
    for (int i=0; i< indexPath.section; i++) {
        
        int actualRows = [self getActualRowForSection:i];
        
        heightForRows = heightForRows + actualRows * self.itemSize.height;
        //NSLog(@">>>>>>>>>> rows : %d >> actualRows : %d >> heightForRows : %d For Section : %d", countRows, actualRows, heightForRows, i);
        
        NSIndexPath *indexSection = [NSIndexPath indexPathForRow:0 inSection:i];
        CGRect rectHeader = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexSection].frame;
        heightForColumns = heightForColumns + rectHeader.size.height;
    }
    
    CGRect rectHeader = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath].frame;
    
    int yheader = heightForRows + heightForColumns;
    //NSLog(@">>>>>>>>>>>>>> headerPosition yheader : %d", yheader);
    
    return CGRectMake(0, yheader, rectHeader.size.width, rectHeader.size.height);
}

-(UICollectionViewLayoutAttributes *) getModifiedAttributeForRow:(UICollectionViewLayoutAttributes *)attributes {
    
    //    if(indexPathSelected == nil) {
    //        return attributes;
    //    }
    
    NSIndexPath *indexCurr = attributes.indexPath;
    
    //NSLog(@"layoutAttributesForItemAtIndexPath row: %d frame before >> %@", indexCurr.row, NSStringFromCGRect(attributes.frame));
    
    //CGRect rectHeader = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexCurr].frame;
    CGRect rectHeader = [self getHeaderFrameAtIndex:indexCurr];
    
    CGRect rectAtt = attributes.frame;
    
    //NSLog(@"sizeHeader : %@",NSStringFromCGSize(sizeHeader));
    if(indexPathSelected.row % 2 == 1 && indexPathSelected.section == indexCurr.section) {
        
        //int section = indexCurr.section + 1;
        int count = [self.collectionView numberOfItemsInSection:indexCurr.section];
        //NSLog(@"data count in section :%d", count);
        
        BOOL isEven = FALSE;
        if (count%2 == 0 && count == indexPathSelected.row + 1) {
            isEven = TRUE;
        }
        
        if(![indexPathSelected isEqual:attributes.indexPath]) {
            
            if(attributes.indexPath.row <= indexPathSelected.row+1) {
                int actualRow = indexCurr.row/2;
                
                if(attributes.indexPath.row % 2 == 0) {
                    attributes.frame = CGRectMake(0, rectHeader.origin.y + rectHeader.size.height + actualRow * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
                } else {
                    attributes.frame = CGRectMake(160, rectHeader.origin.y + rectHeader.size.height + actualRow * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
                }
                
                if(attributes.indexPath.row == indexPathSelected.row+1) {
                    //NSLog(@" in special conditions >> %d %d",indexCurr.row,actualRow);
                    attributes.frame = CGRectMake(160, rectHeader.origin.y + rectHeader.size.height + (actualRow - 1) * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
                }
                
            } else {
                int actualRow = ceil((float)indexCurr.row/2.0);
                //NSLog(@" >>> indexpath.row >> %d actualrow = %d",indexCurr.row,actualRow);
                if(attributes.indexPath.row % 2 == 1) {
                    attributes.frame = CGRectMake(0, self.itemSize.height + rectHeader.origin.y + rectHeader.size.height + actualRow * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
                } else {
                    attributes.frame = CGRectMake(160, self.itemSize.height + rectHeader.origin.y + rectHeader.size.height + actualRow * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
                }
            }
            //NSLog(@"layoutAttributesForItemAtIndexPath frame after >> %@",NSStringFromCGRect(attributes.frame));
        }
        
        if (isEven)
        {
            int actualRow = ceil((float)indexCurr.row/2.0);
            if([indexPathSelected isEqual:attributes.indexPath]) {
                //------------ If its even and last Cell, moving it up
                attributes.frame = CGRectMake(0, rectHeader.origin.y + rectHeader.size.height + (actualRow - 1)  * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
                
            } else if(indexPathSelected.section == indexCurr.section && indexCurr.row == count-2) {
                //------------ If its even and second last Cell, moving it Down
                attributes.frame = CGRectMake(0, rectHeader.origin.y + rectHeader.size.height + (actualRow + 2)  * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
            }
            // NSLog(@"is even number of data available so we need to rearrange them again");
        }
        
    } else if(indexPathSelected.row % 2 == 1 && indexPathSelected.section < indexCurr.section) {
        int actualRow = floor((float)indexCurr.row/2.0);
        if(attributes.indexPath.row % 2 == 0) {
            attributes.frame = CGRectMake(0, rectHeader.origin.y + rectHeader.size.height + actualRow * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
        } else {
            attributes.frame = CGRectMake(160, rectHeader.origin.y + rectHeader.size.height + actualRow * self.itemSize.height, rectAtt.size.width, rectAtt.size.height);
        }
    }
    
    return attributes;
}


-(int)getActualRowForSection:(int)section {
    
    int countRows = [self.collectionView numberOfItemsInSection:section];
    int actualRows = ceil(countRows/2.0);
    if(indexPathSelected.section == section) {
        if(countRows % 2 == 0) {
            actualRows = actualRows + 2;
        } else {
            actualRows = actualRows + 1;
        }
    }
    
    return actualRows;
}


- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
}

// These layout attributes are applied to a cell that is "appearing" and will be eased into the nominal layout attributes for that cell
// Cells "appear" in several cases:
//  - Inserted explicitly or via a section insert
//  - Moved as a result of an insert at a lower index path
//  - Result of an animated bounds change repositioning cells
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    
    //attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
    
    if([indexPathSelected isEqual:itemIndexPath]) {
        //CATransform3D transform1 = CATransform3DMakeRotation(90, 1, 0, 0);
        //CATransform3D transform2 = CATransform3DMakeScale(0.5, 0.5, 0);
        // You might need to swap the two arguments here
        //CATransform3D combined = CATransform3DConcat(transform1, transform2);
        
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    } /*else {
       if(attributes.frame.origin.x == 0) {
       attributes.transform3D = CATransform3DMakeTranslation(-self.collectionView.bounds.size.width, 0, 0);
       } else if(attributes.indexPath.row == indexPathSelected.row+1) {
       attributes.transform3D = CATransform3DMakeTranslation(+self.collectionView.bounds.size.width, 0, 0);
       } else {
       attributes.transform3D = CATransform3DMakeTranslation(+self.collectionView.bounds.size.width, 0, 0);
       }
       }*/
    
    //attributes.transform3D = CATransform3DMakeTranslation(-self.collectionView.bounds.size.width, 0, 0);
    
    return attributes;
}

// These layout attributes are applied to a cell that is "disappearing" and will be eased to from the nominal layout attribues prior to disappearing
// Cells "disappear" in several cases:
//  - Removed explicitly or via a section removal
//  - Moved as a result of a removal at a lower index path
//  - Result of an animated bounds change repositioning cells
- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    //attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    if ([indexPathLastSel isEqual:itemIndexPath]) {
        //attributes.transform3D = CATransform3DMakeScale(2, 2, 1.0);
        /*CATransform3D transform = CATransform3DMakeTranslation(0, self.collectionView.bounds.size.height, 0);
         transform = CATransform3DRotate(transform, M_PI*0.2, 0, 0, 1);
         attributes.transform3D = CATransform3DMakeTranslation(120, 0, 0);
         attributes.alpha = 0.0f;*/
    }
    
    return attributes;
}

// These layout attributes are applied to newly appearing supplementary views, which are then eased to their nominal attributes
// Supplementary views in a flow layout normally only appear when adding a section
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    
    //attributes.transform3D = CATransform3DMakeTranslation(-self.collectionView.bounds.size.width, 0, 0);
    
    return attributes;
}

// These layout attributes are eased to in disappearing supplementary views from their current attributes
// Supplementary views in a flow layout normally only disappear when deleting a section
- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    
    
//    CATransform3D transform = CATransform3DMakeTranslation(0, self.collectionView.bounds.size.height, 0);
//    transform = CATransform3DRotate(transform, M_PI*0.2, 0, 0, 1);
//    attributes.transform3D = transform;
//    attributes.alpha = 0.0f;
    
    
    return attributes;
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
}


#pragma mark - Helpers

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}


@end
