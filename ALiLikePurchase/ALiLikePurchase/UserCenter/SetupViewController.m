//
//  SetupViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/20.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "SetupViewController.h"
#import "UIColor+DD.h"
#import "NavigationView.h"
#import "BSFitdpiUtil.h"
#import "SetUpTableViewCell.h"
#import "ModifyPhoneViewController.h"
#import "AboutUsViewController.h"
#import "RegisterViewController.h"
#import "SVProgressHUD.h"
#import "InstallmentWebViewController.h"

static NSString *const kSetUpTableViewCellIdentifier = @"SetUpTableViewCell";

@interface SetupViewController ()<UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    UIImageView * img;
}


@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)UIButton *logoutButton;

@property(nonatomic, strong)NSArray *dataList;

@property(nonatomic, strong)UIImage *pView;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
     [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLogin:) name:NOTIFICATIONLOGIN object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    User *user = [[DataManager shareInstance]getUser];
    if (user != nil) {
        [[DataManager shareInstance]getCustomerInfo:@{@"appToken":user.appToken} callBack:^(NSObject *object) {
            [self.tableView reloadData];
        }];
    }
    [super viewWillAppear:animated];
}

#pragma mark - UI
-(void)initUI{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
    [self.view addSubview:self.navigationView];
    [self.navigationView setTitle:@"设置"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logoutButton];
}

-(void)initData{
    self.dataList = @[@[@{@"title":@"头像", @"isReturn":@"1", @"isword":@"0", @"isImageView":@"1", @"isTextF":@"0",@"type":@"0"},
                        @{@"title":@"昵称", @"isReturn":@"0", @"isword":@"1", @"isImageView":@"0", @"isTextF":@"0", @"type":@"1"},
                        @{@"title":@"绑定手机号", @"isReturn":@"1", @"isword":@"1", @"isImageView":@"0", @"isTextF":@"0", @"type":@"3"},
                        @{@"title":@"绑定微信号", @"isReturn":@"1", @"isword":@"1", @"isImageView":@"0", @"isTextF":@"0", @"type":@"4"}
                        ],@[
                          @{@"title":@"关于我们", @"isReturn":@"1", @"isword":@"0", @"isImageView":@"0", @"isTextF":@"0", @"type":@"5"},
                          @{@"title":@"清除缓存", @"isReturn":@"1", @"isword":@"1", @"isImageView":@"0", @"isTextF":@"0", @"type":@"6"}
                          ]];
}


#pragma mark -  UITableViewDelegate & UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 22;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 22;
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 2;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                tableViewH = 60;
            }
                break;
            case 1:
            {
                tableViewH = 50;
            }
                break;
            case 2:
            {
                tableViewH = 50;
            }
                break;
            case 3:
            {
                tableViewH = 50;
            }
                break;
            case 4:
            {
                tableViewH = 52;
            }
                break;
            default:
                break;
        }
        
    }else{
        switch (indexPath.row) {
            case 0:{
                tableViewH = 52;
            }
                break;
            case 1:
            {
                tableViewH = 52;
            }
                break;
        }
    }
    
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *modelArray = [self.dataList objectAtIndex:indexPath.section];

    SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSetUpTableViewCellIdentifier forIndexPath:indexPath];
    
   
    User *user = [[DataManager shareInstance]getUser];
    [cell setModel:[modelArray objectAtIndex:indexPath.row]];
    [cell setUser:user];
     [cell setImage:self.pView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                [self openImage];
            }
                break;
            case 1:
            {
            }
                break;
         
            case 2:
            {
                ModifyPhoneViewController *modifyPhoneVC = [[ModifyPhoneViewController alloc]init];
                
                [self.navigationController pushViewController:modifyPhoneVC animated:YES];
            }
                break;
            case 3:
            {
                User *user = [[DataManager shareInstance]getUser];
                if (user.wxPubOpenId == nil || user.wxPubOpenId.length == 0) {
                    SendAuthReq* req =[[SendAuthReq alloc ] init];
                    req.scope = @"snsapi_userinfo" ;
                    req.state = @"123" ;
                    [WXApi sendReq:req];
                }
            }
                break;
            default:
                break;
        }
        
    }else{
        switch (indexPath.row) {
            case 0:{
                AboutUsViewController *aboutVC = [[AboutUsViewController alloc]init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            case 1:
            {
                [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                    [self.tableView reloadData];
                }];
            }
                break;
        }
    }
}


-(void)openImage{
       //把状态栏隐藏起来
   //    UIApplication *app = [UIApplication sharedApplication];
   //    app.statusBarHidden = YES;
   
       //构建图像选择器
       UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
       //设置代理为本身（实现了UIImagePickerControllerDelegate协议）
       pickerController.delegate = self;
       //是否允许对选中的图片进行编辑
       pickerController.allowsEditing = YES;
   
       //设置图像来源类型(先判断系统中哪种图像源是可用的)
       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                 pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
             }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                     pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                 }else {
                        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                     }
        //打开模态视图控制器选择图像
         [self presentModalViewController:pickerController animated:YES];
}

-(void)editedImage:(UIImage *)image
 {
     self.pView = image;
     [self.tableView reloadData];
    
}

 #pragma -
 #pragma Delegate methods
 -(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
 {
      [picker dismissModalViewControllerAnimated:YES];
      [self performSelector:@selector(editedImage:) withObject:image afterDelay:.5];
  }

 -(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
 {
      [picker dismissModalViewControllerAnimated:YES];
  }

#pragma mark - NavigationViewDelegate

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - getter / setter

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigatorHeight,ScreenWidth, 408) style:UITableViewStyleGrouped];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SetUpTableViewCell class]) bundle:nil] forCellReuseIdentifier:kSetUpTableViewCellIdentifier];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        

    }
    return _tableView;
}

-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationNormalView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}


-(UIButton *)logoutButton{
    if (_logoutButton == nil) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutButton setFrame:CGRectMake(15, CGRectGetMaxY(self.tableView.frame)+17, ScreenWidth - 34, 44)];
        [_logoutButton setBackgroundColor:[UIColor colorWithHexString:@"#FB5754"]];
        [_logoutButton addTarget:self action:@selector(logout) forControlEvents:(UIControlEventTouchUpInside)];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    return _logoutButton;
}

-(void)logout{
    BOOL flag = [[DataManager shareInstance]clearUser];
    if (flag == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.tabBarController.tabBar setHidden:NO];
    }
}


-(void)finishLogin:(NSNotification *) notification{
    NSDictionary *dic = notification.userInfo;
    
    [[DataManager shareInstance]weixinAuthorization:dic callBack:^(NSDictionary *result) {
        NSString *str = result[@"type"];
        if ([str isEqualToString:@"message"] == YES) {
            Message *model = result[@"model"];
            
            if ([model.code isEqualToString:@"1"] == YES) {
                RegisterViewController *registerVC = [[RegisterViewController alloc]init];
                [registerVC setJumpType:JumpPageWeiXinType];
                registerVC.openid = dic[@"openid"];
                registerVC.dataModel = dic;
                [self.navigationController pushViewController:registerVC animated:YES];
            }else{
                [SVProgressHUD showInfoWithStatus:model.reason];
            }
        }else{
            
            InstallmentWebViewController *webVC = [[InstallmentWebViewController alloc]init];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }];
    
}

- (void)dealloc {
    //移除所有观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
