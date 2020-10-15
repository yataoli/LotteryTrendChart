//
//  testView.h
//  biaogetest
//
//  Created by sangji on 2019/8/14.
//  Copyright © 2019 liyatao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ViewHeightBlock)(CGFloat height);
@interface Caipiaozoushiview : UIView
@property (nonatomic,copy) ViewHeightBlock heightBlock;
- (instancetype)initWithFrame:(CGRect)frame andxDatas:(NSArray *)xDatas andfillDatas:(NSMutableArray*)fillDatas andIsPk10:(BOOL)ispk10 andWeiZhi:(NSString *)weiZhiName;
@end

NS_ASSUME_NONNULL_END
