//
//  ViewController.m
//  ConsultItem
//
//  Created by 陈峰 on 16/2/23.
//  Copyright © 2016年 陈峰. All rights reserved.
//

#import "ViewController.h"
#import "ApisConsultUnite.h"
#import "ConsultTitleCollectionCell.h"

@interface ViewController () <ApisConsultUniteDelegate, ApisConsultUniteDataSource> {

    __weak IBOutlet UICollectionView *titleCollection;
    __weak IBOutlet UICollectionView *contentCollection;
    ApisConsultUnite *unite;
    
    NSInteger leftIndex;
    CGFloat leftPercent;
    NSInteger selectIndex;
}



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [titleCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [contentCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    unite = [ApisConsultUnite new];
    unite.delegate = self;
    unite.dataSource = self;
    [unite uniteTitle:titleCollection content:contentCollection];
    
    [titleCollection registerNib:[UINib nibWithNibName:consultTitleCollectionCell bundle:nil] forCellWithReuseIdentifier:consultTitleCollectionCell];
    leftIndex = leftPercent = selectIndex = 0;
}

- (NSInteger)numberOfItems {
    return 20;
}

- (CGFloat)widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UICollectionViewCell *)collectionViewType:(ConsultUniteViewType)viewType cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (viewType==ConsultUniteViewTypeTitle) {
        ConsultTitleCollectionCell *cell = [titleCollection dequeueReusableCellWithReuseIdentifier:consultTitleCollectionCell forIndexPath:indexPath];
        cell.titleLabel.text = [NSString stringWithFormat:@"第%ld个",(long)indexPath.item];
        
        
        cell.titleLabel.isMainLabel = leftIndex==indexPath.row;
        
        if (leftIndex == indexPath.row) {
            cell.titleLabel.progress = leftPercent;
        } else if (leftIndex+1 == indexPath.row) {
            cell.titleLabel.progress = leftPercent;
        } else {
            cell.titleLabel.progress = 0;
        }
        
        
        return cell;
    }
    
    
    UICollectionView *collection = viewType==ConsultUniteViewTypeTitle? titleCollection:contentCollection;
    UICollectionViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:(indexPath.row%6)/6.f green:((indexPath.row+3)%6)/6.f blue:((indexPath.row+5)%6)/6.f alpha:1];
    
    
    return cell;
}

- (void)contentCollectionDidScrollAtIndex:(NSInteger)index atCurrentItemPercent:(CGFloat)percent {
    NSLog(@"index = %ld, percent = %f", index, percent);
    leftIndex = index;
    leftPercent = percent;
    [titleCollection reloadData];
}

- (void)contentCollectionDidScrollToIndex:(NSInteger)index {
    
}


@end
