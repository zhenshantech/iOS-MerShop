//
//  Http_url.h
//  MerShop
//
//  Created by mac on 2019/3/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Http_url : NSObject
//POST
+ (void)POST:(NSString *)httpUrl dict:(NSDictionary *)dict  showHUD:(BOOL)show WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;;

+ (void)POST:(NSString *)httpUrl image:(UIImage *)image showHUD:(BOOL)show WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

@end

