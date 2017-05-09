//
//  WebSocketManager.m
//  YYMobileCore
//
//  Created by liusilan on 2017/4/7.
//  Copyright © 2017年 YY.inc. All rights reserved.
//

#import "WebSocketManager.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"

@interface WebSocketManager ()
{
    HTTPServer *_httpServer;
}
@end

@implementation WebSocketManager

+ (instancetype)sharedManager {
    static WebSocketManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WebSocketManager new];
    });
    
    return manager;
}

- (void)startServer {
    
    if (_httpServer.isRunning) {
        return;
    }
    
    _httpServer = [[HTTPServer alloc] init];
    
    // Tell server to use our custom MyHTTPConnection class.
    [_httpServer setConnectionClass:[MyHTTPConnection class]];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [_httpServer setType:@"_http._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [_httpServer setPort:12345];
    
    //	[httpServer setDocumentRoot:webPath];
    
    // Start the server (and check for problems)
    
    NSError *error;
    if(![_httpServer start:&error])
    {
        NSLog(@"start server error:%@", error.localizedDescription);
    }
}

- (void)stopServer {

    if (_httpServer && _httpServer.isRunning) {
        [_httpServer stop];
    }
}

@end
