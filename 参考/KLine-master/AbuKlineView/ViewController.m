//
//  ViewController.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "KLineSubCalculate.h"
@interface ViewController ()<KlineTitleViewDelegate>

@property (nonatomic, strong) NSString              * currentRequestType;

@property (nonatomic, strong) KlineTitleView        * klineTitleView;

@property (nonatomic, assign) KLINETYPE               currentType;

@property (nonatomic, strong) AbuKlineView          * kLineView;

@property (nonatomic,strong)  KLineModel            * model;

@property (nonatomic,strong)  NSMutableArray        * dataSource;

@property (nonatomic,assign) UIInterfaceOrientation orientation;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = NO;
    [self supportRotion:UIInterfaceOrientationPortrait];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationLandscapeLeft;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.currentType = K_LINE_1MIN;
    [self buildKLineTitleView];
    [self.view addSubview:self.kLineView];
    [self addKLineSubView];
      [self requestKLineViewHistoryListWithType:self.currentType];
}

- (void)buildKLineTitleView
{
    [self.view addSubview:self.klineTitleView];
    
}

- (void)addKLineSubView
{
    WS(weakSelf);
    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        [self.klineTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.view).offset(100);
            make.height.mas_offset(30);
        }];
        [self.kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(132);
            make.right.equalTo(weakSelf.view.mas_right);
            make.left.equalTo(weakSelf.view.mas_left);
            make.height.mas_offset(ChartViewHigh);
        }];
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        [self.klineTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.view).offset(40);
            make.height.mas_offset(30);
        }];
        [self.kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(72);
            make.right.equalTo(weakSelf.view.mas_right);
            make.left.equalTo(weakSelf.view.mas_left);
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
    }
}

- (void)selectIndex:(KLINETYPE)type
{
    if (type == self.currentType) {
        return;
    }
    [self requestKLineViewHistoryListWithType:type];
    self.currentType = type;
}



- (void)requestKLineViewHistoryListWithType:(KLINETYPE)type
{
     if (type == K_LINE_1MIN)
    {
        [self loadStockDataWithJson:@"stock1"];
        self.currentRequestType = @"M1";
    }
    else if (type == K_LINE_5MIN)
    {
        [self loadStockDataWithJson:@"stock5"];
        self.currentRequestType = @"M5";
    }
    else if (type == K_LINE_15MIN)
    {
        [self loadStockDataWithJson:@"stock15"];
        self.currentRequestType = @"M15";
    }
    else if (type == K_LINE_30MIN)
    {
        [self loadStockDataWithJson:@"stock30"];
        self.currentRequestType = @"M30";
    }
    else if (type == K_LINE_1HOUR || type == K_LINE_60MIN)
    {
         [self loadStockDataWithJson:@"stock60"];
        self.currentRequestType = @"H1";
    }
    else if (type == K_LINE_DAY)
    {
        [self loadStockDataWithJson:@"stockDay"];
        self.currentRequestType = @"D1";
    }
}

- (void)loadStockDataWithJson:(NSString *)json
{
    NSString *Path = [[NSBundle mainBundle] pathForResource:json ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:Path];
    
    NSDictionary * stockDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (IsDictionaryNull(stockDict)) {
        return;
    }
    if (self.dataSource) {
        [self.dataSource removeAllObjects];
    }
    NSArray * stockData = stockDict[@"d"][@"p"];
    for (int i = 0; i < stockData.count; i++)
    {
        NSDictionary * dic = stockData[i];
        KLineModel * model = [[KLineModel alloc]init];
        model.closePrice = [dic[@"c"] floatValue];
        model.openPrice = [dic[@"o"] floatValue];
        model.highPrice = [dic[@"h"] floatValue];
        model.lowPrice = [dic[@"l"] floatValue];
        model.date = [self changeDtaForMatMmDd:dic[@"t"] range:NSMakeRange(14, 2)];
        model.timestamp = (NSInteger)[self changeTime:model.date];
        model.timeStr = [self updateTime:[NSString stringWithFormat:@"%ld",(long)model.timestamp]];
        model.volumn = dic[@"v"];
        if (i % 16 == 0)
        {
            model.isDrawDate = YES;
        }
        [self.dataSource addObject:model];
    }
    self.dataSource = [[[KLineSubCalculate sharedInstance] initializeQuotaDataWithArray:self.dataSource KPIType:4] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.kLineView.dataArray = self.dataSource;
    });
}

- (NSString *)changeDtaForMatMmDd:(NSString *)data range:(NSRange)range
{
    NSArray * timeArray = [data componentsSeparatedByString:@"T"];
    NSString * time = [timeArray.firstObject stringByAppendingString:[NSString stringWithFormat:@" %@",timeArray.lastObject]];
    return time;
}

- (long)changeTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *lastDate = [formatter dateFromString:time];
    long firstStamp = [lastDate timeIntervalSince1970];
    return firstStamp;
}

-(NSString*)updateTime:(NSString*)time{
    
    NSString *format = nil;
    if ([self.currentRequestType containsString:@"D"]||[self.currentRequestType containsString:@"W"]||[self.currentRequestType isEqualToString:@"MN"]) {
        format = @"MM-dd";
    }else if ([self.currentRequestType containsString:@"M"]||[self.currentRequestType containsString:@"H"])
    {
        format = @"MM-dd HH:mm";
    }
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    int timeval = [time intValue];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeval];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

- (KlineTitleView *)klineTitleView
{
    if (!_klineTitleView) {
        _klineTitleView = [[KlineTitleView alloc] initWithklineTitleArray:@[@"1分",@"5分",@"15分",@"30分",@"1小时",@"日K"] typeArray:@[@34,@1,@2,@3,@37,@5]];
        _klineTitleView.delegate = self;
    }
    return _klineTitleView;
}

- (UIInterfaceOrientation)orientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (AbuKlineView *)kLineView
{
    if (!_kLineView) {
        _kLineView = [[AbuKlineView alloc]init];
    }
    return _kLineView;
}




@end
