//
//  ViewController.m
//  UConnGrid
//
//  Created by Chintan on 23/01/14.
//  Copyright (c) 2014 Logistic Infotech. All rights reserved.
//

#import "ViewController.h"
#import "ImageBean.h"

#import "ColumnSpanFlowLayout.h"
//#import "ColorName.h"
#import "ImageCell.h"
#import "ColorSectionHeaderView.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

//ColorSectionHeaderDelegate, ColorSectionFooterDelegate
@property (nonatomic, retain) UICollectionView * collectionView;

//@property (nonatomic, strong) NSMutableArray * sectionedColorNames;

/*- (void)addNewItemInSection:(NSUInteger)section;
 - (void)deleteItemAtIndexPath:(NSIndexPath*)indexPath;
 
 - (void)insertSectionAtIndex:(NSUInteger)index;
 - (void)deleteSectionAtIndex:(NSUInteger)index;*/

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrSection = [[NSMutableArray alloc] init];
    
    for (int i=1; i <= 3; i++) {
        NSMutableArray *arrImages = [[NSMutableArray alloc] init];
        if(i==1) {
            for (int i=1; i <= 5; i++) {
                
                ImageBean *imgBean = [[ImageBean alloc] init];
                [imgBean setStrName:[NSString stringWithFormat:@"image%d.jpg",i]];
                
                [arrImages addObject:imgBean];
            }
        } else if(i==2) {
            for (int i=1; i <= 12; i++) {
                
                ImageBean *imgBean = [[ImageBean alloc] init];
                [imgBean setStrName:[NSString stringWithFormat:@"image%d.jpg",i]];
                
                [arrImages addObject:imgBean];
            }
        } else if(i==3) {
            for (int i=1; i <= 13; i++) {
                
                ImageBean *imgBean = [[ImageBean alloc] init];
                [imgBean setStrName:[NSString stringWithFormat:@"image%d.jpg",i]];
                
                [arrImages addObject:imgBean];
            }
        }
        [arrSection addObject:arrImages];
    }
    
    // This array will contain the ColorName objects that populate the CollectionView, one array per section
    //self.sectionedColorNames = [NSMutableArray arrayWithObjects:[NSMutableArray array], nil];
    
    // Allocate and configure the layout.
    layout = [[ColumnSpanFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.isHeaderStiky = TRUE;
    //layout.sectionInset = UIEdgeInsetsMake(10.f, 20.f, 10.f, 20.f);
    
    // Bigger items for iPad
    layout.itemSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGSizeMake(120, 120) : CGSizeMake(160, 120);
    
    // uncomment this to see the default flow layout behavior
    //[layout makeBoring];
    
    
    // Allocate and configure a collection view
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.bounces = YES;
    collectionView.alwaysBounceVertical = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;
    
    // Register reusable items
    //[collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AddCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AddCell class])];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageCell class]) bundle:nil]
     forCellWithReuseIdentifier:NSStringFromClass([ImageCell class])];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ColorSectionHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ColorSectionHeaderView class])];
    
    [self.collectionView.viewForBaselineLayout.layer setSpeed:0.5f];
    //[collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ColorSectionFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([ColorSectionFooterView class])];
    
    // Add to view
    [self.view addSubview:collectionView];
    
}



#pragma mark - Header/Footer Delegates



#pragma mark - UICollectionView Data Source


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [arrSection count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Always one extra cell for the "add" cell
    //NSMutableArray *sectionColorNames = self.sectionedColorNames[section];
    return [[arrSection objectAtIndex:section] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath isEqual:indexPathSelected]) {
        //isAnyCellBigger = TRUE;
        //NSLog(@"sizeForItemAtIndexPath Bigger >> lastRow = %d lastSection = %d", indexPath.row, indexPath.section);
        return CGSizeMake(320, 240);
        
    } /*else if(lastRow == indexPath.row && lastSection == indexPath.section && isAnyCellBigger == TRUE) {
       //isAnyCellBigger = FALSE;
       NSLog(@"sizeForItemAtIndexPath Smaller >> lastRow = %d lastSection = %d", lastRow, lastSection);
       }*/
    
    return CGSizeMake(160, 120);
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * view = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        ColorSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:NSStringFromClass([ColorSectionHeaderView class])
                                                                                   forIndexPath:indexPath];
        header.sectionIndex = indexPath.section;
        header.hideDelete = collectionView.numberOfSections == 1; // hide when only one section
        header.delegate = self;
        view = header;
    }
    /*else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
     {
     ColorSectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
     withReuseIdentifier:NSStringFromClass([ColorSectionFooterView class])
     forIndexPath:indexPath];
     footer.sectionIndex = indexPath.section;
     footer.delegate = self;
     view = footer;
     }*/
    
    return view;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    ImageCell *cnCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ImageCell class])
                                                                  forIndexPath:indexPath];
    [cnCell setImgBeanObj:[[arrSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell = cnCell;
    
    if([indexPathSelected isEqual:indexPath]) {
        [cell.layer setSpeed:0.9f];
    } else {
        [cell.layer setSpeed:0.8f];
    }
    
    return cell;
}


#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    // only the height component is used
    if(section == 0) {
        return CGSizeMake(50, 50);
    }
    return CGSizeMake(50, 50);
}

/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
 {
 // only the height component is used
 return CGSizeMake(50, 50);
 }*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    // Upon tapping an item, delete it. If it's the last item (the add cell), add a new one
    
    //ImageBean *imgBean = [arrImages objectAtIndex:indexPath.row];
    
    indexPathLastSel = indexPathSelected;
    layout.indexPathLastSel = indexPathSelected;
    
    if([indexPathSelected isEqual:indexPath]) {
        indexPathSelected = nil;
        layout.indexPathSelected = nil;
    } else {
        indexPathSelected = indexPath;
        layout.indexPathSelected = indexPath;
    }
    
    //NSLog(@"didSelectItemAtIndexPath >> lastRow = %d lastSection = %d", indexPath.row, indexPath.section);
    [self.collectionView performBatchUpdates:^{
        [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } completion:^(BOOL finished) {
        //[self.collectionView reloadData];
    }];
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
