//
//  RootViewController.h
//  TextLayoutLabel
//
//  Created by wuyang on 14-4-28.
//  Copyright (c) 2014年 wuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextLayoutLabel.h"
@interface RootViewController : UIViewController<TextLayoutLabelDelegate>
{
    TextLayoutLabel *newsTitle;
    UIScrollView *imgscroll;
    
    CGFloat height;
}
@end
