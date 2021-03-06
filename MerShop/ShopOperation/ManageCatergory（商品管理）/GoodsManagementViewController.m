//
//  GoodsManagementViewController.m
//  MerShop
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GoodsManagementViewController.h"
#import "GoodsTableViewCell.h"
#import "ManageCatergoryViewController.h"
#import "CreateNewGoodsViewController.h"
#import "GoodsModel.h"
#import "PhoneNumberView.h"
#import "CreateGoodsViewController.h"
#import "NewCatergoryViewController.h"


#define ButtonWidth     IFAutoFitPx(194)

@interface GoodsManagementViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,PhoneNumberViewDelegate,GoodsTableViewCellDelegate>
@property (nonatomic ,strong)UIScrollView *leftScrollView;
@property (nonatomic ,strong)UITableView *mainTable;
@property (nonatomic ,strong)UIView *leftView;
@property (nonatomic ,strong)NSMutableArray *btnArr;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,strong)ZJTopImageBottomTitleButton *bottomBtn1;
@property (nonatomic ,strong)ZJTopImageBottomTitleButton *bottomBtn2;
@property (nonatomic ,assign)NSInteger storeId;
@property (nonatomic ,strong)NSMutableArray *leftDataSource;
@property (nonatomic ,strong)NSMutableArray *rightDataSource;
@property (nonatomic ,strong)UIView *clearView;
@property (nonatomic ,strong)PhoneNumberView *upView;
@property (nonatomic ,strong)NSString *catergoryName;
@property (nonatomic ,assign)NSInteger *catergoryId;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,assign)NSInteger classID;

@end

@implementation GoodsManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle:@"商品管理"];
    _storeId = StoreId;
    [self setRightUI];
//    [self requestCatergory];
    self.classID = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestCatergory];
    [self requestGoods:self.classID];
}

- (void)requestCatergory{
    [self.leftDataSource removeAllObjects];
    [Http_url POST:@"goods_class_list" dict:@{@"store_id":@(_storeId)} showHUD:YES WithSuccessBlock:^(id data) {
        NSLog(@"获取成功");
        NSArray *arr = [data objectForKey:@"data"];
        if (arr.count == 0){
            [self.leftScrollView setHidden:YES];
            [self.mainTable setHidden:YES];
            [self addClassView];
        }else{
            [self.leftScrollView setHidden:NO];
            [self.mainTable setHidden:NO];
            [self.leftDataSource addObjectsFromArray:arr];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:arr forKey:@"classArray"];
            [user synchronize];
            [self setLeftUI];
        }
        
    } WithFailBlock:^(id data) {
        
    }];
}

- (void)addClassView{
    _clearView = [[UIView alloc]initWithFrame:XFrame(0, ViewStart_Y, Screen_W, Screen_H-ViewStart_Y)];
    [_clearView setBackgroundColor:BlackColor];
    [_clearView setAlpha:0.5];
    [_clearView setHidden:NO];
    [self.view addSubview:_clearView];
    
    _upView = [[PhoneNumberView alloc]init];
    [_upView setFrame:XFrame(IFAutoFitPx(96), IFAutoFitPx(456)+ViewStart_Y, IFAutoFitPx(560), IFAutoFitPx(292))];
    _upView.layer.cornerRadius = IFAutoFitPx(8);
    [_upView setViewTitle:@"温馨提示" subTitle:@"是否新建商品分类？" cancel:@"否" ensure:@"是"];
    _upView.layer.masksToBounds = YES;
    _upView.delegate = self;
    [_upView setBackgroundColor:[UIColor whiteColor]];
    [_upView setHidden:NO];
    [self.view addSubview:_upView];
}

- (void)requestGoods:(NSInteger )classId{
    [self.rightDataSource removeAllObjects];
    [Http_url POST:@"goods_list" dict:@{@"store_id":@(_storeId),@"class_id":@(classId)} showHUD:YES WithSuccessBlock:^(id data) {
        NSLog(@"获取成功");
        NSArray *arr = [[data objectForKey:@"data"] objectForKey:@"goods_list"];
        if (![arr isKindOfClass:[NSNull class]]){
            self.dataArray = [arr mutableCopy];
            for (NSDictionary *dict in arr){
                GoodsModel *model = [[GoodsModel alloc]initWithDictionary:dict error:nil];
                [self.rightDataSource addObject:model];
            }
            [self.mainTable reloadData];
        }else{
            
        }
        
    } WithFailBlock:^(id data) {
        
    }];
}

- (void)setRightUI{
    _mainTable = [[UITableView alloc]init];
    [_mainTable setFrame:XFrame(IFAutoFitPx(200), ViewStart_Y, Screen_W-IFAutoFitPx(200), Screen_H-ViewStart_Y-IFAutoFitPx(108))];
    [_mainTable setBackgroundColor:[UIColor whiteColor]];
    [_mainTable setTableFooterView:[[UIView alloc]init]];
    [_mainTable setDelegate:self];
    [_mainTable setDataSource:self];
    [_mainTable setRowHeight:UITableViewAutomaticDimension];
    [self.view addSubview:_mainTable];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:XFrame(0, CGRectGetMaxY(_mainTable.frame), Screen_W, IFAutoFitPx(108))];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    XViewLayerCB(backgroundView, 0, 0.5, LineColor);
    [self.view addSubview:backgroundView];
    
    
    _bottomBtn1  = [[ZJTopImageBottomTitleButton alloc]init];
    [_bottomBtn1 setFrame:XFrame(IFAutoFitPx(30), IFAutoFitPx(14), (Screen_W-IFAutoFitPx(90))/2, IFAutoFitPx(80))];
    [_bottomBtn1 setTitle:@"管理分类" forState:(UIControlStateNormal)];
    [_bottomBtn1 setImage:[UIImage imageNamed:@"editmenu_glfl_1"] forState:(UIControlStateNormal)];
    [_bottomBtn1.titleLabel setFont:XFont(12)];
    [_bottomBtn1 setTitleColor:IFThemeBlueColor forState:(UIControlStateNormal)];
    [_bottomBtn1 addTarget:self action:@selector(goManage) forControlEvents:(UIControlEventTouchUpInside)];
//    _bottomBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    XViewLayerCB(_bottomBtn1, 3, 0.5, LineColor);
    [backgroundView addSubview:_bottomBtn1];
    
    _bottomBtn2  = [[ZJTopImageBottomTitleButton alloc]init];
    [_bottomBtn2 setFrame:XFrame(IFAutoFitPx(30)+CGRectGetMaxX(_bottomBtn1.frame), IFAutoFitPx(14), (Screen_W-IFAutoFitPx(90))/2, IFAutoFitPx(80))];
    [_bottomBtn2 setTitle:@"新建商品" forState:(UIControlStateNormal)];
    [_bottomBtn2 setImage:[UIImage imageNamed:@"editmenu_add_1"] forState:(UIControlStateNormal)];
    [_bottomBtn2.titleLabel setFont:XFont(12)];
    [_bottomBtn2 setTitleColor:IFThemeBlueColor forState:(UIControlStateNormal)];
//    _bottomBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    XViewLayerCB(_bottomBtn2, 3, 0.5, LineColor);
    [_bottomBtn2 addTarget:self action:@selector(goCreateNewGoodsVC) forControlEvents:(UIControlEventTouchUpInside)];
    [backgroundView addSubview:_bottomBtn2];
    
}

- (void)setLeftUI{
    _btnArr = [NSMutableArray arrayWithCapacity:0];
    
    _leftScrollView = [[UIScrollView alloc]init];
    [_leftScrollView setFrame:XFrame(0, ViewStart_Y, IFAutoFitPx(200), Screen_H-ViewStart_Y-IFAutoFitPx(108))];
    [_leftScrollView setContentSize:CGSizeMake(IFAutoFitPx(200), IFAutoFitPx(96)*_leftDataSource.count)];
    [_leftScrollView setBackgroundColor:LineColor];
    [_leftScrollView setDelegate:self];
    [_leftScrollView setScrollEnabled:YES];
    [self.view addSubview:_leftScrollView];
    
    
    for (NSInteger i = 0;i <_leftDataSource.count; i++){
        UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [leftBtn setTag:i];
        [leftBtn.titleLabel setFont:XFont(16)];
        [leftBtn setFrame:XFrame(IFAutoFitPx(6), i*IFAutoFitPx(96), ButtonWidth, IFAutoFitPx(96))];
        NSString *title = [[_leftDataSource objectAtIndex:i] objectForKey:@"stc_name"];
        [leftBtn setTitle:title forState:(UIControlStateNormal)];
        [leftBtn setTitleColor:GrayColor forState:(UIControlStateNormal)];
        [leftBtn.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
        [leftBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        if(i == 0){
            [leftBtn setTitleColor:IFThemeBlueColor forState:(UIControlStateNormal)];
            [leftBtn setBackgroundColor:[UIColor whiteColor]];
            _leftView = [[UIView alloc]init];
            [_leftView setFrame:XFrame(0, 0, IFAutoFitPx(6), IFAutoFitPx(96))];
            [_leftView setBackgroundColor:IFThemeBlueColor];
            [_leftScrollView addSubview:_leftView];
            
        }
        [_btnArr addObject:leftBtn];
        [_leftScrollView addSubview:leftBtn];
    }
}

//底部按钮Action
- (void)goManage{
    ManageCatergoryViewController *vc = [[ManageCatergoryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goCreateNewGoodsVC{
    CreateNewGoodsViewController *VC = [[CreateNewGoodsViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

//当没有分类的时候，弹窗是否创建新的分类
- (void)cancelCall:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)playCall:(UIButton *)sender{
    NewCatergoryViewController *vc = [[NewCatergoryViewController alloc]init];
    [_clearView setHidden:YES];
    [_upView setHidden:YES];
    [self.navigationController pushViewController:vc animated:YES];
}


//点击左侧分类，刷新商品数据
- (void)clickBtn:(UIButton *)sender{
    _index = sender.tag;
    for (UIButton *btn in _btnArr){
        if (btn.tag == _index){
            [btn setTitleColor:IFThemeBlueColor forState:(UIControlStateNormal)];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [_leftView setFrame:XFrame(0, IFAutoFitPx(96)*_index, IFAutoFitPx(6), IFAutoFitPx(96))];
        }else{
            [btn setTitleColor:GrayColor forState:(UIControlStateNormal)];
            [btn setBackgroundColor:LineColor];
        }
    }
    NSDictionary *classDict = self.leftDataSource[_index];
    if(classDict != nil){
        self.classID = [[classDict objectForKey:@"stc_id"] integerValue];
        [self requestGoods:self.classID];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rightDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsTableViewCell *cell = (GoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GoodsTableViewCell"];
    if (!cell){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GoodsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    GoodsModel *model;
    if (kISNullArray(self.rightDataSource)){
        
    }else{
        model = self.rightDataSource[indexPath.row];
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setDataWithModel:model];
    return cell;
}

//商品上下架
- (void)upShelfAction:(id)data{
    GoodsTableViewCell *cell = (GoodsTableViewCell *)data;
    GoodsModel *model = self.rightDataSource[cell.tag];
    NSInteger goods_Id = model.goods_id;
    NSDictionary *dict = @{@"goods_id":@(goods_Id),
                           @"store_id":@(StoreId)
                           };
    NSString *title;
    if (model.goods_state == 1){
        title = @"确定下架该商品吗？";
    }else{
        title = @"确定上架该商品吗";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"让我再想想吧！");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [Http_url POST:@"chgoods_state" dict:dict showHUD:YES WithSuccessBlock:^(id data) {
            if ([[data objectForKey:@"code"] integerValue] == 200){
                [[IFUtils share]showErrorInfo:[data objectForKey:@"msg"]];
                if (model.goods_state == 1){
                    NSLog(@"已下架");
                    NSMutableDictionary *d = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[cell.tag]];
                    [d setValue:@(0) forKey:@"goods_state"];
                    GoodsModel *model = [[GoodsModel alloc]initWithDictionary:d error:nil];
                    [self.dataArray removeObjectAtIndex:cell.tag];
                    [self.dataArray insertObject:d atIndex:cell.tag];
                    [self.rightDataSource removeObjectAtIndex:cell.tag];
                    [self.rightDataSource insertObject:model atIndex:cell.tag];
                    [cell.orangeView setHidden:NO];
                    [cell.upShelf setTitle:@"上架" forState:(UIControlStateNormal)];
                }else if (model.goods_state == 0){
                    NSLog(@"已上架");
                    NSMutableDictionary *d = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[cell.tag]];
                    [d setValue:@(1) forKey:@"goods_state"];
                    GoodsModel *model = [[GoodsModel alloc]initWithDictionary:d error:nil];
                    [self.dataArray removeObjectAtIndex:cell.tag];
                    [self.dataArray insertObject:d atIndex:cell.tag];
                    [self.rightDataSource removeObjectAtIndex:cell.tag];
                    [self.rightDataSource insertObject:model atIndex:cell.tag];
                    [cell.orangeView setHidden:YES];
                    [cell.upShelf setTitle:@"下架" forState:(UIControlStateNormal)];
                }
                [self.mainTable reloadData];
            }
        } WithFailBlock:^(id data) {
            
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//编辑商品
- (void)edite:(id)data{
    GoodsTableViewCell *cell = (GoodsTableViewCell *)data;
    CreateNewGoodsViewController *vc = [[CreateNewGoodsViewController alloc]init];
    vc.className = [self.leftDataSource[_index] objectForKey:@"stc_name"];
    vc.classId = [[self.leftDataSource[_index] objectForKey:@"stc_id"] integerValue];
    vc.tempDict = self.dataArray[cell.tag];
    vc.tempStr = @"编辑";
    [self.navigationController pushViewController:vc animated:YES];
}

//删除商品
- (void)deleteGoods:(id)data{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除该商品吗？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"让我再想想吧！");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        GoodsTableViewCell *cell = (GoodsTableViewCell *)data;
        GoodsModel *model = self.rightDataSource[cell.tag];
        NSInteger goods_Id = model.goods_id;
        NSDictionary *dict = @{@"goods_id":@(goods_Id),
                               @"store_id":@(StoreId)
                               };
        [Http_url POST:@"del_goods" dict:dict showHUD:YES WithSuccessBlock:^(id data) {
            if ([[data objectForKey:@"code"] integerValue] == 200){
                [self.rightDataSource removeObjectAtIndex:cell.tag];
                [self.dataArray removeObjectAtIndex:cell.tag];
                [self.mainTable reloadData];
            }
        } WithFailBlock:^(id data) {
            
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)leftDataSource{
    if (!_leftDataSource){
        _leftDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _leftDataSource;
}
- (NSMutableArray *)rightDataSource{
    if (!_rightDataSource){
        _rightDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _rightDataSource;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
@end
