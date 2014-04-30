//
//  TextLayoutLabel.h
//  TextLayoutLabel
//
//  Created by wuyang on 14-4-28.
//  Copyright (c) 2014年 wuyang. All rights reserved.
//

@protocol TextLayoutLabelDelegate <NSObject>

-(void)reloadHeight:(NSInteger)LabelTag LabelHeight:(int)Height;

@end

#import <UIKit/UIKit.h>
@interface TextLayoutLabel : UILabel
{
    CGFloat characterSpacing;       //字间距
    
    long linesSpacing;              //行间距
}

@property (nonatomic,assign) id<TextLayoutLabelDelegate>delegate;

@property (nonatomic, assign) CGFloat characterSpacing;
@property (nonatomic, assign) long linesSpacing;

- (int)getAttributedStringHeightWithString:(NSAttributedString *)string  WidthValue:(int) width;

@end
