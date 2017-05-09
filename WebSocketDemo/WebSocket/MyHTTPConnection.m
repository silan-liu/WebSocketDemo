#import "MyHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPResponse.h"
#import "HTTPDynamicFileResponse.h"
#import "GCDAsyncSocket.h"
#import "MyWebSocket.h"
#import "HTTPLogging.h"

@implementation MyHTTPConnection

- (WebSocket *)webSocketForURI:(NSString *)path
{	
	if([path isEqualToString:@"/service"])
	{
		return [[MyWebSocket alloc] initWithRequest:request socket:asyncSocket];		
	}
	
	return [super webSocketForURI:path];
}

@end
