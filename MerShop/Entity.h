//
//  Entity.h
//  MerShop
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 mac. All rights reserved.
//

#ifndef Entity_h
#define Entity_h


#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define http_devUrlString       @"http://47.111.27.189:2000/v3/"

#define lijing          @"http://47.92.244.60/api/public/index.php/v3/"

#define http_urlString          @"http://47.92.244.60:88/v3/"

#define IFUserDefaults   [NSUserDefaults standardUserDefaults]

#define UserInfoDict   [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]

#define StoreId        [[UserInfoDict objectForKey:@"store_id"] integerValue]//商店ID

#define StoreIdString   [UserInfoDict objectForKey:@"store_id"]

#define img_path    @"http://pqk40fvkr.bkt.clouddn.com/"

#define IFThemeBlueColor toPCcolor(@"#1C98F6")   //APP主题色

#define GrayColor    toPCcolor(@"#666666")

#define BackgroundColor    toPCcolor(@"#f5f5f5")//背景色

#define BlackColor   toPCcolor(@"#000000")

#define LineColor    toPCcolor(@"#E5E5E5")

#define WhiteColor   toPCcolor(@"#FFFFFF")

#define XFrame(xmx,xmy,xw,xh) CGRectMake(xmx,xmy,xw,xh)

#define Screen_W                ([[UIScreen mainScreen] bounds].size.width)

#define Screen_H                ([[UIScreen mainScreen] bounds].size.height)

#define XScreenScale            (Screen_W/320.0)

#define XAutoFitPx(xPx)         (XScreenScale*(xPx))

#define IFAutoFitPx(xPx)        (((xPx)/2.0)/(375.0/320.0)*XScreenScale)

#define getWidth(view) CGRectGetWidth(view.frame)

#define getHeight(view)  CGRectGetHeight(view.frame)

#define getMaxY(view) CGRectGetMaxY(view.frame)

#define getMaxX(view) CGRectGetMaxx(view.frame)

#define getMinX(view) CGRectGetMinX(view.frame)

#define getMinY(view) CGRectGetMinY(view.frame)

#define getMidX(View) CGRectGetMidX(view.frame)

#define getMidY(View) CGRectGetMidY(view.frame)

#define XFont(fontSize)   [UIFont systemFontOfSize:fontSize]

#define StatusBar_H     [UIApplication sharedApplication].statusBarFrame.size.height

#define Tabbar_H        self.tabBarController.tabBar.frame.size.height

#define Navagtion_H     44.0

#define ViewStart_Y         (Navagtion_H+StatusBar_H)

//设置圆角视图
#define XViewLayerCB(viewName,lcR,lbW,lbC)\
[viewName.layer setCornerRadius:lcR];\
[viewName.layer setBorderWidth:lbW];\
[viewName.layer setBorderColor:lbC.CGColor];\
[viewName.layer setMasksToBounds:YES];

//强弱引用
#define LCWeakSelf(type)    __weak typeof(type)  weak##type = type;
#define LCStrongSelf(type)  __strong typeof(type) type = weak##type;

//字符串是否为空
#define kISNullString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kISNullArray(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0 ||[array isEqual:[NSNull null]])
//字典是否为空
#define kISNullDict(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 || [dic isEqual:[NSNull null]])
//是否是空对象
#define kISNullObject(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
//判断对象是否为空,为空则返回默认值
#define kGetNullDefaultObj(_value,_default) ([_value isKindOfClass:[NSNull class]] || !_value || _value == nil || [_value isEqualToString:@"(null)"] || [_value isEqualToString:@"<null>"] || [_value isEqualToString:@""] || [_value length] == 0)?_default:_value

#define UIKIT_STATIC_INLINE    static inline
UIKIT_STATIC_INLINE UIColor *toPCcolor(NSString *pcColorstr)
{
    unsigned int c;
    
    if ([pcColorstr characterAtIndex:0] == '#') {
        
        [[NSScanner scannerWithString:[pcColorstr substringFromIndex:1]] scanHexInt:&c];
        
    } else {
        
        [[NSScanner scannerWithString:pcColorstr] scanHexInt:&c];
        
    }
    
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
}


#endif /* Entity_h */
