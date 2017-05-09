#import "MyWebSocket.h"
#import "HTTPLogging.h"
#import "WebSocketManager.h"

static NSString *HeartBeat = @"heartBeat";

@interface MyWebSocket ()
{
    dispatch_source_t _heartBeatRecvTimer;
    dispatch_queue_t _heartBeatRecvQueue;
}
@end

@implementation MyWebSocket

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didOpen
{
	[super didOpen];
    
    [self startHeartBeatRecvTimer];
    
    [self sendBinaryData];
}

- (void)didReceiveMessage:(NSString *)msg
{
    if (msg && msg.length > 0) {
        
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSString *messageType = [dict objectForKey:@"messageType"];
            if (messageType && messageType.length > 0) {
                if ([messageType isEqualToString:@"heartBeat"]) {
                    [self startHeartBeatRecvTimer];
                }
            }
        }
    }
}

- (void)didReceiveData:(NSData *)data {
    NSInteger headerLen = 4;

    if (data && data.length >= headerLen) {
        NSData *headerData = [data subdataWithRange:NSMakeRange(0, headerLen)];
        if (headerData && headerData.length > 0) {
        
            uint32_t appId;
            [headerData getBytes:&appId length:sizeof(uint32_t)];
            
            NSData *realData = [data subdataWithRange:NSMakeRange(headerLen, data.length - headerLen)];
            
            NSString *text = [[NSString alloc] initWithData:realData encoding:NSUTF8StringEncoding];
            
            NSLog(@"appid:%d,text:%@", appId, text);
        }
    }
}

- (void)didClose
{
	[super didClose];
    
    [self timerHandle];
}

- (void)sendBinaryData {
    NSMutableData *data = [NSMutableData dataWithCapacity:0];
    
    uint32_t appId = 29999;
    [data appendBytes:&appId length:sizeof(uint32_t)];
    
    NSString *text = @"what";
    [data appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self sendData:data isBinary:YES];
}

#pragma mark - heartBeat

// 心跳回包计时器
- (void)startHeartBeatRecvTimer
{
    [self stopHeartBeatRecvTimer];
    
    __weak typeof(self) wself = self;
    if (!_heartBeatRecvQueue) {
        _heartBeatRecvQueue = dispatch_queue_create("com.yy.mobile.heatBeatRecv", DISPATCH_QUEUE_SERIAL);
    }
    
    _heartBeatRecvTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _heartBeatRecvQueue);
    dispatch_source_set_timer(_heartBeatRecvTimer, dispatch_walltime(NULL, 8 * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, (1ull * NSEC_PER_SEC) / 10);
    
    dispatch_source_set_event_handler(_heartBeatRecvTimer, ^{
        [wself timerHandle];
    });
    dispatch_resume(_heartBeatRecvTimer);
}

- (void)stopHeartBeatRecvTimer {

    if (_heartBeatRecvTimer) {
        dispatch_source_cancel(_heartBeatRecvTimer);
        _heartBeatRecvTimer = nil;
    }
}

// 超时未收到回包，关闭连接
- (void)timerHandle
{
    [self stopHeartBeatRecvTimer];
    
    [self stop];
}
@end
