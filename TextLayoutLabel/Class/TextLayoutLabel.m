//
//  TextLayoutLabel.m
//  TextLayoutLabel
//
//  Created by wuyang on 14-4-28.
//  Copyright (c) 2014年 wuyang. All rights reserved.
//

#define MAX_HEIGHT         100000                            //text最大高度


#import "TextLayoutLabel.h"
#import <CoreText/CoreText.h>
@implementation TextLayoutLabel
@synthesize characterSpacing = _characterSpacing;
@synthesize linesSpacing = _linesSpacing;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        //初始化字间距、行间距
        self.characterSpacing = 2.0f;
        self.linesSpacing = 5.0f;
    }
    return self;
}

-(void)setCharacterSpacing:(CGFloat)characterSpacings
{
    _characterSpacing = characterSpacings;
    [self setNeedsDisplay];
}
-(void)setLinesSpacing:(long)linesSpacings
{
    _linesSpacing = linesSpacings;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    if (self.text == nil) {
        return;
    }
    
    //去掉空行
    NSString *labelString = self.text;

    NSString *myString = [labelString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    //创建AttributeString
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:myString];
    
    //设置字体及大小
    CTFontRef helveticaBold = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    
    [string addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0,[string length])];
    
    //设置字间距
    if(self.characterSpacing)
    {
        long number = self.characterSpacing;
        
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        
        [string addAttribute:(NSString *)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [string length])];
        CFRelease(num);
    }
    
    //设置字体颜色
    [string addAttribute:(id)kCTForegroundColorAttributeName value:(id)(self.textColor.CGColor) range:NSMakeRange(0, [string length])];
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTLeftTextAlignment;
    
    if(self.textAlignment == UITextAlignmentCenter)
        
    {
        alignment = kCTCenterTextAlignment;
    }
    
    if(self.textAlignment == UITextAlignmentRight)
        
    {
        alignment = kCTRightTextAlignment;
    }
    
    CTParagraphStyleSetting alignmentStyle;
    
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    
    alignmentStyle.valueSize = sizeof(alignment);
    
    alignmentStyle.value = &alignment;
    
    //设置文本行间距
    CGFloat lineSpace = self.linesSpacing;
    
    CTParagraphStyleSetting lineSpaceStyle;
    
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    
    lineSpaceStyle.value = &lineSpace;
    
    //设置文本段间距
    CGFloat paragraphSpacing = 5.0;
    
    CTParagraphStyleSetting paragraphSpaceStyle;
    
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    
    paragraphSpaceStyle.valueSize = sizeof(CGFloat);
    
    paragraphSpaceStyle.value = &paragraphSpacing;
    
    //创建设置数组
    CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings , sizeof(settings));
    
    //给文本添加设置
    [string addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [string length])];
    
    //排版
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    //翻转坐标系统（文本原来是倒的要翻转下）
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    //画出文本
    CTFrameDraw(leftFrame,context);
    
    //释放
    CGPathRelease(leftColumnPath);
    
    CFRelease(framesetter);
    
    CFRelease(helveticaBold);

    UIGraphicsPushContext(context);
    
    //刷新高度
    int height = [self getAttributedStringHeightWithString:string WidthValue:self.frame.size.width];
    
    [delegate reloadHeight:self.tag LabelHeight:height];
}

//计算文本高度
- (int)getAttributedStringHeightWithString:(NSAttributedString *)string  WidthValue:(int) width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, MAX_HEIGHT);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = MAX_HEIGHT - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值

    CFRelease(textFrame);
    
    return total_height;
}

@end
