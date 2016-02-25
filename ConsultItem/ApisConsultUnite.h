//
//  ConsultItem.h
//  ConsultItem
//
//  Created by 陈峰 on 16/2/23.
//  Copyright © 2016年 陈峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ConsultUniteViewType) {
    ConsultUniteViewTypeTitle = 0,
    ConsultUniteViewTypeContent,
};

@protocol ApisConsultUniteDelegate <NSObject>

@optional
- (void)collectionViewType:(ConsultUniteViewType)viewType didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)contentCollectionDidScrollAtIndex:(NSInteger)index atCurrentItemPercent:(CGFloat)percent;
- (void)contentCollectionDidScrollToIndex:(NSInteger)index;

@end

@protocol ApisConsultUniteDataSource <NSObject>

@required
- (CGFloat)widthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfItems;
- (UICollectionViewCell *)collectionViewType:(ConsultUniteViewType)viewType cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ApisConsultUnite : NSObject

@property (nonatomic, weak) id<ApisConsultUniteDataSource> dataSource;
@property (nonatomic, weak) id<ApisConsultUniteDelegate> delegate;

- (BOOL)uniteTitle:(UICollectionView *)titleCollection content:(UICollectionView *)contentCollection;
- (void)reloadData;

@end
