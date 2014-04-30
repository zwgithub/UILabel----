//
//  RootViewController.m
//  TextLayoutLabel
//
//  Created by wuyang on 14-4-28.
//  Copyright (c) 2014年 wuyang. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    height = 1;
    [self TextLayoutView];
}

-(void)TextLayoutView
{
    imgscroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 20, 300, self.view.frame.size.height-40)];
    imgscroll.contentSize = CGSizeMake(300, height);
    imgscroll.showsHorizontalScrollIndicator = NO;
    //imgscroll.pagingEnabled = YES;
    [self.view addSubview:imgscroll];
    
    newsTitle = [[TextLayoutLabel alloc]init];
    newsTitle.frame = CGRectMake(0, 0, 300, height);
    newsTitle.backgroundColor = [UIColor redColor];
    newsTitle.opaque = YES;
    newsTitle.textAlignment = UITextAlignmentLeft;
    newsTitle.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    newsTitle.font = [UIFont fontWithName:@"Courier" size:17.0f];
    newsTitle.characterSpacing = 4.0f;
    newsTitle.linesSpacing = 5.0f;
    newsTitle.text = @"提供了一系列方便的函数，可以很容易的把文本绘制在屏幕上，对于一个Frame来说，一般并不需要担心文本的排列问题，这些Core Text的函数都可以直接搞定，只要给他一个大小合适的CGRect就可以。但，在某些情况下，我们还希望知道这段文本在绘制之后，对应绘制的字体字号设置，在屏幕上实际占用了多大面积。举例来说，有文本段落a，屏幕大小rect，通常做法是以rect创建path，然后创建CTFramesetter，再然后创建CTFrame，最后用CTFrameDraw画出来，这时候，往往文本段落占用的实际面积会小于rect，这时候就有必要获得这段文本所占用的真正面积。最理想的情况是使用double CTLineGetTypographicBounds( CTLineRef line, CGFloat* ascent, CGFloat* descent, CGFloat* leading );这是Core Text提供的函数，传入CTLine，就会得到这一行的ascent,descent和leading，在OSX上通常可以工作的很好，但是在iOS(iPhone/iPad)上这个函数的结果略有不同。正常情况下，计算行高只需要ascent+descent+leading即可。在这个略有不同的情况下，leading的值会出现偏差，导致算出来的结果是错误的。如果不管行距，ascent+descent计算出来的Glyph的高度还是正确的。这样就有了第一步在创建用于绘图的CFAttributedStringRef时，除了设置字体，多设置一个CTParagraphStyleRef，其中特别应该确定行距kCTParagraphStyleSpecifierLineSpacing。在计算这里时，先逐行计算ascent+descent，累加起来，再加上一个行数*之前设置好的行距，这样算出来的就是这些文本的实际高度，传入CTLine，就会得到这一行的ascent,descent和leading，在OSX上通常可以工作的很好，但是在iOS(iPhone/iPad)上这个函数的结果略有不同。正常情况下，计算行高只需要ascent+descent+leading即可。在这个略有不同的情况下，leading的值会出现偏差，导致算出来的结果是错误的。如果不管行距，ascent+descent计算出来的Glyph的高度还是正确的。这样就有了第一步在创建用于绘图的CFAttributedStringRef时，除了设置字体，多设置一个CTParagraphStyleRef，其中特别应该确定行距kCTParagraphStyleSpecifierLineSpacing。在计算这里时，先逐行计算ascent+descent，累加起来，再加上一个行数*之前设置好的行距，这样算出来的就是这些文本的实际高度";
    newsTitle.delegate = self;
    newsTitle.tag = 11;
    [imgscroll addSubview:newsTitle];
}

#pragma mark
#pragma mark TextLayoutLabelDelegate
-(void)reloadHeight:(NSInteger)LabelTag LabelHeight:(int)Height
{
    if (LabelTag == 11)
    {   //NSLog(@"xxx = %d",Height);
        if (height == 1)
        {
            height = Height;
            [self TextLayoutView];
        }
    }
}
#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
