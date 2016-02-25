//
//  ConsultTitleCollectionCell.h
//  ConsultItem
//
//  Created by 陈峰 on 16/2/24.
//  Copyright © 2016年 陈峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFGradientLabel.h"

static NSString *consultTitleCollectionCell = @"ConsultTitleCollectionCell";

IB_DESIGNABLE

@interface ConsultTitleCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet CFGradientLabel *titleLabel;


@end
