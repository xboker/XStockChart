//
//  UIDevice+RotateScreen.m
//  XStockChart
//
//  Created by xiekunpeng on 2019/8/27.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

#import "UIDevice+RotateScreen.h"

@implementation UIDevice (RotateScreen)
+ (void)switchOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
@end
