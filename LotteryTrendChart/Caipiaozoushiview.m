//
//  testView.m
//  biaogetest
//
//  Created by sangji on 2019/8/14.
//  Copyright © 2019 liyatao. All rights reserved.
//

#import "Caipiaozoushiview.h"
#define RGB_Color(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define first_width 70
#define two_width 0

#define FormWidth ([[UIScreen mainScreen] bounds].size.width - first_width - two_width)/10

#define FormHeight FormWidth

@interface Caipiaozoushiview()

@property (nonatomic, copy) NSArray *xDatas; // 每行的数字为0～9
@property (nonatomic, strong) NSMutableArray *fillDatas;// 来存放选中号码
@property (nonatomic, strong) NSMutableArray *frameArr;// 用来存放坐标的数组
@property (nonatomic) CGFloat view_heigth;
@property (nonatomic) BOOL ispk10;
@property (nonatomic,strong) NSString *weiZhiName;
@end

@implementation Caipiaozoushiview
- (instancetype)initWithFrame:(CGRect)frame andxDatas:(NSArray *)xDatas andfillDatas:(NSMutableArray*)fillDatas andIsPk10:(BOOL)ispk10 andWeiZhi:(NSString *)weiZhiName{
    self = [super initWithFrame:frame];
    if (self) {
        self.ispk10 = ispk10;
        self.weiZhiName = weiZhiName;
        self.backgroundColor = [UIColor whiteColor];
        _xDatas = xDatas;
        _fillDatas = fillDatas;
        _frameArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //第一行矩形，并填弃颜色
    /*
    if ([self.weiZhiName containsString:@"跨度"] || [self.weiZhiName containsString:@"和值"]){
        CGContextSetLineWidth(context, 2.0);//线的宽度
        CGContextSetFillColorWithColor(context, RGB_Color(255, 255, 226, 1.0).CGColor);//填充颜色
        CGContextAddRect(context,CGRectMake(first_width + two_width + FormWidth * 5, 0, FormWidth, FormHeight * _xDatas.count));//画方框
        CGContextDrawPath(context, kCGPathFill);
    }
    */
    
    //矩形，并填弃颜色
    
    
    if ([self.weiZhiName containsString:@"跨度"] || [self.weiZhiName containsString:@"和值"]) {
        for (NSInteger i = 0; i < 5; i ++) {
            if (i == 0) {
                CGContextSetFillColorWithColor(context, RGB_Color(119, 140, 194, 1.0).CGColor);//填充颜色
            }else if (i == 1){
                CGContextSetFillColorWithColor(context, RGB_Color(138, 195, 202, 1.0).CGColor);//填充颜色
            }else if (i == 2){
                CGContextSetFillColorWithColor(context, RGB_Color(143, 146, 196, 1.0).CGColor);//填充颜色
            }else if (i == 3){
                CGContextSetFillColorWithColor(context, RGB_Color(64, 143, 213, 1.0).CGColor);//填充颜色
            }else if (i == 4){
                CGContextSetFillColorWithColor(context, RGB_Color(117, 169, 216, 1.0).CGColor);//填充颜色
            }else{
                
                CGContextSetFillColorWithColor(context, RGB_Color(247, 247, 247, 1.0).CGColor);//填充颜色
            }
            CGContextSetLineWidth(context, 2.0);//线的宽度
//            CGContextAddRect(context,CGRectMake(0, FormHeight * i, first_width, FormHeight));//画方框
            CGContextAddRect(context,CGRectMake(first_width + two_width + FormWidth * 5 + (FormWidth * i), 0, FormWidth, FormHeight * _xDatas.count));//画方框
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    
    
    
    // 画横线线条
    for (int i=0; i <= _xDatas.count; i++) {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:231/255.0 green:229/255.0 blue:226/255.0 alpha:1.0].CGColor);
        CGContextSetLineWidth(context, .4);
        CGContextMoveToPoint(context, 0, i*FormHeight);
        CGContextAddLineToPoint(context, [[UIScreen mainScreen] bounds].size.width, i*FormHeight);
        CGContextDrawPath(context, kCGPathStroke);
        if (i == _xDatas.count) {
            self.view_heigth = i * FormHeight;
        }
        
    }
    
    
    
    
    //设置号码
    for (int j = 0; j < _xDatas.count; j++) {
        
        if (j < _xDatas.count){
            NSArray *smallArray = _xDatas[j];
            for (int i = 0; i<smallArray.count; i++){
                NSString *period = smallArray[i];
                if (i == 0) {//期号
                    CGSize size = [self calculaTetextSize:period andSize:CGSizeMake(first_width, FormHeight)];
                    [period drawInRect:CGRectMake((first_width-size.width)/2.0,(FormHeight-size.height)/2.0+j*FormHeight, first_width, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]}];
                }else if (i == 1){//开奖号码
                    CGSize size = [self calculaTetextSize:period andSize:CGSizeMake(two_width, FormHeight)];
                    [period drawInRect:CGRectMake((two_width-size.width)/2.0+first_width,(FormHeight-size.height)/2.0+j*FormHeight, two_width, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]}];
                }else{
                    CGSize size = [self calculaTetextSize:period andSize:CGSizeMake(FormWidth, FormHeight)];
                    
                    if ([self.weiZhiName containsString:@"和值"] || [self.weiZhiName containsString:@"跨度"]){
                        if (i > 6) {
                            [period drawInRect:CGRectMake((FormWidth-size.width)/2.0+(i - 2)*FormWidth+first_width + two_width,(FormHeight-size.height)/2.0+j*FormHeight, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                        }else{
                           [period drawInRect:CGRectMake((FormWidth-size.width)/2.0+(i - 2)*FormWidth+first_width + two_width,(FormHeight-size.height)/2.0+j*FormHeight, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor]}];
                        }
                        
                    }else{
//                        period = [period stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                       [period drawInRect:CGRectMake((FormWidth-size.width)/2.0+(i - 2)*FormWidth+first_width + two_width,(FormHeight-size.height)/2.0+j*FormHeight, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor]}];
                    }
                    
                    if ([self.weiZhiName containsString:@"单号走势"]) {
                        if ([period containsString:@"-"]) {
                            period = [period stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            [period drawInRect:CGRectMake((FormWidth-size.width)/2.0+(i - 2)*FormWidth+first_width + two_width,(FormHeight-size.height)/2.0+j*FormHeight, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor]}];
                        }else{
                            CGPoint point = CGPointMake((FormWidth-size.width)/2.0+(i - 2)*FormWidth+first_width + two_width, (FormHeight-size.height)/2.0+j*FormHeight + 7);
                            NSString *str = NSStringFromCGPoint(point);
                            //保存圆中心的位置 给下面的连线
                            [_frameArr addObject:str];
                        }
                    }else if ([self.weiZhiName containsString:@"多号走势"]){
                        if (period.length > 0) {
                            CGPoint point = CGPointMake((FormWidth-size.width)/2.0+(i - 2)*FormWidth+first_width + two_width, (FormHeight-size.height)/2.0+j*FormHeight + 7);
                            NSString *str = NSStringFromCGPoint(point);
                            //保存圆中心的位置 给下面的连线
                            [_frameArr addObject:str];
                        }
                        period = [period stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        [period drawInRect:CGRectMake((FormWidth-size.width)/2.0+(i - 2)*FormWidth+first_width + two_width,(FormHeight-size.height)/2.0+j*FormHeight, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor]}];
                    }
                }
                
                
            }

        }
        
        //画竖向线条
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:231/255.0 green:229/255.0 blue:226/255.0 alpha:1.0].CGColor);
        CGContextSetLineWidth(context, .4);
        if (j == 0) {
            CGContextMoveToPoint(context,j*FormWidth, 0);
            CGContextAddLineToPoint(context, j*FormWidth, _xDatas.count*FormHeight);
        }else if (j == 1) {
            CGContextMoveToPoint(context, first_width, 0);
            CGContextAddLineToPoint(context, first_width, _xDatas.count*FormHeight);
        }else if (j == 2){
            CGContextMoveToPoint(context, two_width + first_width, 0);
            CGContextAddLineToPoint(context, two_width + first_width, _xDatas.count*FormHeight);
        }else{

            CGContextMoveToPoint(context,(first_width + two_width) + (j - 3)*FormWidth, 0);
            CGContextAddLineToPoint(context, (first_width + two_width) + (j - 3)*FormWidth, _xDatas.count*FormHeight);
            
            
        }
        
        
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    
    //绘制连线
    if ([self.weiZhiName containsString:@"单号走势"]) {
        for (int i=0; i<_frameArr.count; i++) {
            NSString *str = [_frameArr objectAtIndex:i];
            CGPoint point = CGPointFromString(str);
            // 设置画笔颜色
            CGContextSetStrokeColorWithColor(context, RGB_Color(131, 208, 249, 1.0).CGColor);
            CGContextSetLineWidth(context, 1);
            if (i==0) {
                
                // 画笔的起始坐标
                CGContextMoveToPoint(context, point.x + 3, point.y);
                
            }else{
                NSString *str1 = [_frameArr objectAtIndex:i-1];
                CGPoint point1 = CGPointFromString(str1);
                CGContextMoveToPoint(context, point1.x + 3, point1.y);
                CGContextAddLineToPoint(context, point.x + 3,  point.y);
            }
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    
    
    // 画填充圆
    if ([self.weiZhiName containsString:@"单号"] || [self.weiZhiName containsString:@"多号"]) {
        for (int i = 0; i<_frameArr.count; i++){
            NSString *str = [_frameArr objectAtIndex:i];
            CGPoint point = CGPointFromString(str);
            CGContextSetStrokeColorWithColor(context, RGB_Color(87, 189, 247, 1.0).CGColor);
            CGContextDrawPath(context, kCGPathStroke);
            //填满整个圆
            if (self.ispk10 == YES) {
                CGContextAddArc(context, point.x + 4, point.y, 10, 0, M_PI*2, 1);
            }else{
                CGContextAddArc(context, point.x + 3, point.y, 10, 0, M_PI*2, 1);
            }
            
            CGContextSetFillColorWithColor(context, RGB_Color(87, 189, 247, 1.0).CGColor);
            CGContextDrawPath(context, kCGPathFill);
            
            if (i < _fillDatas.count) {
                NSString *numberStr = _fillDatas[i];
                //画内容
                if (self.ispk10 == YES){
                    [numberStr drawInRect:CGRectMake(point.x - 3,point.y - 7, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                }else{
                   [numberStr drawInRect:CGRectMake(point.x,point.y - 7, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                }
                
            }
        }
    }
    
    
    
    if (self.heightBlock) {
        self.heightBlock(self.view_heigth);
    }
}
- (CGSize )calculaTetextSize:(NSString *)text andSize:(CGSize)size{
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName :[UIFont systemFontOfSize:12],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil].size;
    return contentSize;
}

@end
