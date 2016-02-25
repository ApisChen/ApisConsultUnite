//
//  ConsultItem.m
//  ConsultItem
//
//  Created by 陈峰 on 16/2/23.
//  Copyright © 2016年 陈峰. All rights reserved.
//

#import "ApisConsultUnite.h"

@interface ApisConsultUnite () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UICollectionView *titleCollection;
    UICollectionView *contentCollection;
}

@end

@implementation ApisConsultUnite

- (BOOL)uniteTitle:(UICollectionView *)title content:(UICollectionView *)content {
    if (title && content && _dataSource && _delegate) {
        
        titleCollection = title;
        contentCollection = content;
        titleCollection.delegate = self;
        titleCollection.dataSource = self;
        contentCollection.delegate = self;
        contentCollection.dataSource = self;
        return YES;
    }
    return NO;
}

- (void)reloadData {
    [contentCollection reloadData];
    [titleCollection reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfItems)]) {
        return [_dataSource numberOfItems];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource && [_dataSource respondsToSelector:@selector(collectionViewType:cellForItemAtIndexPath:)]) {
        ConsultUniteViewType type = collectionView==titleCollection? ConsultUniteViewTypeTitle:ConsultUniteViewTypeContent;
        return [_dataSource collectionViewType:type cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == contentCollection) {
        return contentCollection.bounds.size;
    } else {
        if (_dataSource && [_dataSource respondsToSelector:@selector(widthForItemAtIndexPath:)]) {
            return CGSizeMake([_dataSource widthForItemAtIndexPath:indexPath], CGRectGetHeight(titleCollection.bounds));
        }
        return CGSizeZero;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(collectionViewType:didSelectItemAtIndexPath:)]) {
        ConsultUniteViewType type = collectionView==titleCollection? ConsultUniteViewTypeTitle:ConsultUniteViewTypeContent;
        return [_delegate collectionViewType:type didSelectItemAtIndexPath:indexPath];
    }
    
    if (collectionView == titleCollection) {
        [contentCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == contentCollection) {

        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat screenW = CGRectGetWidth(scrollView.bounds);
        NSInteger index = offsetX/screenW;
        CGFloat percent = (offsetX-screenW*index)/screenW;
        
        if (_delegate && [_delegate respondsToSelector:@selector(contentCollectionDidScrollAtIndex:atCurrentItemPercent:)]) {
            [_delegate contentCollectionDidScrollAtIndex:index atCurrentItemPercent:percent];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == contentCollection) {
        NSInteger expectIndex = contentCollection.contentOffset.x/CGRectGetWidth(titleCollection.bounds);
        [titleCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:expectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        if (_delegate && [_delegate respondsToSelector:@selector(contentCollectionDidScrollToIndex:)]) {
            [_delegate contentCollectionDidScrollToIndex:expectIndex];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == contentCollection) {
        NSInteger index = contentCollection.contentOffset.x/CGRectGetWidth(titleCollection.bounds);
        [titleCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        if (_delegate && [_delegate respondsToSelector:@selector(contentCollectionDidScrollToIndex:)]) {
            [_delegate contentCollectionDidScrollToIndex:index];
        }
    }
}



@end
