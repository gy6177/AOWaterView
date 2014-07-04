//
//  MessView.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MessView.h"
#import "UrlImageButton.h"
#define WIDTH 320/2
@implementation MessView
@synthesize idelegate;
@synthesize labelSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithData:(DataInfo *)data yPoint:(float) y{
   
    float imgW=data.width;//图片原宽度
    float imgH=data.height;//图片原高度
    float sImgW = WIDTH-4;//缩略图宽带
    float sImgH = sImgW*imgH/imgW;//缩略图高度
    if (self) {
        UrlImageButton *imageBtn = [[UrlImageButton alloc]initWithFrame:CGRectMake(2,2, sImgW, sImgH)];//初始化url图片按钮控件
        [imageBtn setImageFromUrl:YES withUrl:data.url];//设置图片地质
     
        [imageBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageBtn];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, sImgH, WIDTH-4, 20)];
        label.backgroundColor = [UIColor blackColor];
        label.alpha=0.8;
        label.text=data.mess;
        label.textColor =[UIColor whiteColor];
        CGSize size = CGSizeMake(WIDTH, MAXFLOAT);
        
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName,nil];
        labelSize =[label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        self.backgroundColor = [UIColor whiteColor];
        label.frame = CGRectMake(2, sImgH, labelSize.width, labelSize.height);
        [self addSubview:label];
       
    }
    self = [super initWithFrame:CGRectMake(0, y, WIDTH, sImgH+4+labelSize.height)];

    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)click{
    [self.idelegate click:self.dataInfo];
}
@end
