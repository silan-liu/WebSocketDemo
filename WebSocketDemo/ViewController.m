//
//  ViewController.m
//  WebSocketDemo
//
//  Created by liusilan on 2017/5/8.
//  Copyright © 2017年 silan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIWebView *_webView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [_webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    
    [self.view addSubview:_webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
