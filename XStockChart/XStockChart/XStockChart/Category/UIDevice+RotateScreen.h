//
//  UIDevice+RotateScreen.h
//  XStockChart
//
//  Created by xiekunpeng on 2019/8/27.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (RotateScreen)
+ (void)switchOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

NS_ASSUME_NONNULL_END
