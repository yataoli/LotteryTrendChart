//
//  ViewController.m
//  LotteryTrendChart
//
//  Created by 飞鸽 on 2020/10/15.
//
#define YT_Status_Height_one [[UIApplication sharedApplication] statusBarFrame].size.height

#define YT_Status_Height (YT_Status_Height_one == 0 ? 44:YT_Status_Height_one)

#define YT_StatusAndNavBar_Height (YT_Status_Height > 20 ? 88:64)

#define YT_Bottom_Margin (YT_Status_Height > 20  ? 34:0)
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define scrollView_height (SCREEN_HEIGHT - YT_StatusAndNavBar_Height - YT_Bottom_Margin)

#import "ViewController.h"
#import "YTKaiJiangLiShiModel.h"
#import "DanHaoZouShiView.h"
#import "Caipiaozoushiview.h"
@interface ViewController ()
@property (nonatomic,strong) NSMutableArray *needNumberArray;
@property (nonatomic,strong) NSMutableArray *selectNumberArray;
@property (nonatomic,strong) NSMutableArray *huiTuDataArray;
@property (nonatomic,strong) NSMutableArray *danHaoHuiTuDataArray;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataSourceBottom;
@property (nonatomic,strong) DanHaoZouShiView *danHaoZouShiBottomView;
@property (nonatomic,strong) Caipiaozoushiview *caipiaozoushiview;
@property (nonatomic,strong) UIScrollView *zouShiHoaMaBgScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"走势图";
    self.zouShiHoaMaBgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YT_StatusAndNavBar_Height, SCREEN_WIDTH, SCREEN_HEIGHT - YT_StatusAndNavBar_Height - YT_Bottom_Margin)];
    self.zouShiHoaMaBgScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.zouShiHoaMaBgScrollView];
    
    self.needNumberArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectNumberArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.huiTuDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.danHaoHuiTuDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.dataSourceBottom = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"lotteryData" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:txtPath];
    NSDictionary *kaijiangdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    [self.needNumberArray removeAllObjects];
    NSArray *OldIssues = kaijiangdic[@"content"];
    for (NSDictionary *dic in OldIssues) {
        YTKaiJiangLiShiModel *model = [[YTKaiJiangLiShiModel alloc] init];
        model.GameWinningNumber = dic[@"winNo"];
        //处理开奖号码
        if (![model.GameWinningNumber containsString:@","] && model.GameWinningNumber.length == 5) {
            NSMutableString *string = [[NSMutableString alloc] initWithString:model.GameWinningNumber];
            [string insertString:@"," atIndex:1];
            [string insertString:@"," atIndex:3];
            [string insertString:@"," atIndex:5];
            [string insertString:@"," atIndex:7];
            model.GameWinningNumber = string;
        }
        model.GameSerialNumber = dic[@"numero"];
        model.GameSerialNumber = [model.GameSerialNumber substringFromIndex:model.GameSerialNumber.length - 4];
        NSString *Position = @"-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1";
        NSString *string = [NSString stringWithFormat:@"%@|%@|%@,",model.GameSerialNumber,model.GameWinningNumber,Position];
        [self.needNumberArray addObject:string];
    }
    if (self.needNumberArray.count > 0) {
        [self zhengLiHaoMaData];
    }
}
#pragma mark - 整理号码数据
- (void)zhengLiHaoMaData{
    [self.selectNumberArray removeAllObjects];
    [self.huiTuDataArray removeAllObjects];
    [self.danHaoHuiTuDataArray removeAllObjects];
    [self.dataSource removeAllObjects];
    [self.dataSourceBottom removeAllObjects];

    for (NSString *numberStr in self.needNumberArray) {
        
        NSInteger selectIndex = 0;//选择的第几位号码
        //开奖的期号
        NSString *qiHaoStr = [numberStr componentsSeparatedByString:@"|"][0];
        
        //开奖号码选中的位置
        NSString *kaiJiangHaoMa = [numberStr componentsSeparatedByString:@"|"][1];
        NSArray *kaiJiangHaoMaArray = [kaiJiangHaoMa componentsSeparatedByString:@","];
        NSString *selecteStr = kaiJiangHaoMaArray[selectIndex];
        [self.selectNumberArray addObject:selecteStr];
        //需要展示的号码
        NSString *haoMaStr = @"-1,-1,-1,-1,-1,-1,-1,-1,-1,-1";
        NSArray *array = [haoMaStr componentsSeparatedByString:@","];
        NSMutableArray *needArray = [[NSMutableArray alloc] initWithArray:array];
        [needArray replaceObjectAtIndex:selecteStr.intValue withObject:selecteStr];
        NSMutableArray *newNeedArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSString *kaijiangqihao = [NSString stringWithFormat:@"%@期",qiHaoStr];
        [newNeedArray addObject:kaijiangqihao];
        [newNeedArray addObjectsFromArray:needArray];
        [newNeedArray insertObject:@"-2" atIndex:1];
        [self.huiTuDataArray addObject:newNeedArray];
        
    }
    
    
    
    NSInteger length = 12;
    
    NSMutableArray *tempHuiTuArray = [[NSMutableArray alloc] initWithArray:[[self.huiTuDataArray reverseObjectEnumerator] allObjects]];
    for (NSInteger k = 2; k < length; k ++) {
        NSInteger j = 1;
        for (NSInteger i = 0; i < tempHuiTuArray.count; i ++) {
            NSMutableArray *smallArray = tempHuiTuArray[i];
            NSString  *string = smallArray[k];
            if ([string isEqualToString:@"-1"]) {
                [smallArray replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"-%@",@(j ++)]];
            }else{
                j = 1;
            }
            
            
        }
    }
    if (tempHuiTuArray.count > 0) {
        [self.huiTuDataArray removeAllObjects];
        [self.huiTuDataArray addObjectsFromArray:[[tempHuiTuArray reverseObjectEnumerator] allObjects]];
    }
    
    //处理底部的显示数据
    //出现次数
    NSMutableArray *ciShuNeedArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *lianZhongNeedArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *yiLouNeedArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *pinJunYiLouNeedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [ciShuNeedArray addObject:@"出现次数"];
    [ciShuNeedArray insertObject:@"-2" atIndex:1];
    
    [lianZhongNeedArray addObject:@"最大连中"];
    [lianZhongNeedArray insertObject:@"-2" atIndex:1];
    
    [yiLouNeedArray addObject:@"最大遗漏"];
    [yiLouNeedArray insertObject:@"-2" atIndex:1];
    
    [pinJunYiLouNeedArray addObject:@"平均遗漏"];
    [pinJunYiLouNeedArray insertObject:@"-2" atIndex:1];
    
    
    
    for (NSInteger i = 0; i < 10; i ++) {
        NSInteger ciShu = 0;
        NSInteger maxLianZhong = 0;
        NSInteger lianZhong = 0;
        
        NSMutableArray *yilouarray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *pjyilouarray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSArray *smallArray in self.huiTuDataArray) {
            NSArray *tempArray = [smallArray subarrayWithRange:NSMakeRange(2, 10)];
            NSString *string = tempArray[i];
            [yilouarray addObject:string];
            if (string.intValue >= 0) {
                ciShu ++;
                lianZhong ++;
            }else{
                lianZhong = 0;
                [pjyilouarray addObject:string];
            }
            maxLianZhong = maxLianZhong > lianZhong ? maxLianZhong : lianZhong;
            
            
            
        }
        [ciShuNeedArray addObject:[NSString stringWithFormat:@"%@",@(ciShu)]];
        [lianZhongNeedArray addObject:[NSString stringWithFormat:@"%@",@(maxLianZhong)]];
        
        //最大遗漏
        int maxValueYiLou = [[yilouarray valueForKeyPath:@"@max.intValue"] intValue];
        [yiLouNeedArray addObject:[NSString stringWithFormat:@"%@",@(maxValueYiLou)]];
        
        //平均遗漏
        if (ciShu == 0) {
            NSInteger pinJun = self.needNumberArray.count / 1;
            [pinJunYiLouNeedArray addObject:[NSString stringWithFormat:@"%@",@(pinJun)]];
        }else{
            NSInteger pinJun = self.needNumberArray.count / ciShu;
            [pinJunYiLouNeedArray addObject:[NSString stringWithFormat:@"%@",@(pinJun)]];
        }
        
    }
    [self.danHaoHuiTuDataArray addObject:ciShuNeedArray];
    [self.danHaoHuiTuDataArray addObject:lianZhongNeedArray];
    [self.danHaoHuiTuDataArray addObject:yiLouNeedArray];
    [self.danHaoHuiTuDataArray addObject:pinJunYiLouNeedArray];

    [self createZouShiTuView];
}
#pragma mark - 创建走势图
- (void)createZouShiTuView{
    
    [self.danHaoZouShiBottomView removeFromSuperview];
    self.danHaoZouShiBottomView = nil;
    [self.caipiaozoushiview removeFromSuperview];
    self.caipiaozoushiview = nil;
    
    
    {
        BOOL ispk10 = NO;
        
        CGFloat formheight = (SCREEN_WIDTH - 70 - 0)/10;
        self.zouShiHoaMaBgScrollView.frame = CGRectMake(0, YT_StatusAndNavBar_Height, SCREEN_WIDTH, SCREEN_HEIGHT - YT_StatusAndNavBar_Height - formheight * 4 - YT_Bottom_Margin);
        NSMutableArray *nilArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.danHaoZouShiBottomView = [[DanHaoZouShiView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - formheight * 4 - YT_Bottom_Margin, SCREEN_WIDTH, formheight * 4) andxDatas:self.danHaoHuiTuDataArray andfillDatas:nilArray andIsPk10:ispk10 andWeiZhi:@"单号走势-万位"];
        [self.view addSubview:self.danHaoZouShiBottomView];
        
    
        
    
        self.caipiaozoushiview = [[Caipiaozoushiview alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5000) andxDatas:self.huiTuDataArray andfillDatas:self.selectNumberArray andIsPk10:ispk10 andWeiZhi:@"单号走势-万位"];
        __weak typeof(self) weakSelf = self;
        self.caipiaozoushiview.heightBlock = ^(CGFloat height) {
            weakSelf.zouShiHoaMaBgScrollView.contentSize = CGSizeMake(0, height);
        };
        [self.zouShiHoaMaBgScrollView addSubview:self.caipiaozoushiview];
    
    }
}
@end
