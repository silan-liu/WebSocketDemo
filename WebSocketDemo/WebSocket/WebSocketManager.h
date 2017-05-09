//
//  WebSocketManager.h
//  YYMobileCore
//
//  Created by liusilan on 2017/4/7.
//  Copyright © 2017年 YY.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebSocketManager : NSObject

+ (instancetype)sharedManager;
- (void)startServer;
- (void)stopServer;

@end
