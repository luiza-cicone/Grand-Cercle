//
//  UIScreen.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 16/8/13.
//  Copyright (c) 2013 Ensimag. All rights reserved.
//

static BOOL isRetinaScreen = NO;
static BOOL didRetinaCheck = NO;

@implementation UIScreen (RetinaCheck)
+ (BOOL)retinaScreen
{
    if (!didRetinaCheck) {
        isRetinaScreen = ([[self mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                          ([self mainScreen].scale == 2.0));
        didRetinaCheck = YES;
    }
    return isRetinaScreen;
}
@end