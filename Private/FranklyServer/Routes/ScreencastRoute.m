//
//  ScreencastRoute.m
//  iLessPainfulServer
//
//  Created by Karl Krukow on 27/08/11.
//  Copyright (c) 2011 Trifork. All rights reserved.
//

#import "ScreencastRoute.h"
#import "NoContentResponse.h"
#import "HTTPDataResponse.h"

@interface ScreencastRoute()
- (void) startRecording;
- (NSString *) stopRecording;
@end


@implementation ScreencastRoute 


- (void) setParameters:(NSDictionary*) parameters {
    _params = [parameters retain];
}
- (void) setConnection:(HTTPConnection *)connection {
    _conn = connection;
}

- (void) dealloc {
    [_params release];_params=nil;
    _conn=nil;
    [super dealloc];
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    NSLog(@"screencast supports post");
    return [method isEqualToString:@"POST"];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    NSString* action = [_params objectForKey:@"action"];
    if ([action isEqualToString:@"start"]) {
        NSLog(@"starting screencast");
        [self startRecording];
        return [[[NoContentResponse alloc] init] autorelease];
    }
    else if ([action isEqualToString:@"stop"]) {
                NSLog(@"stopping screencast");
        NSString* path = [self stopRecording];
        NSData *data = [NSData dataWithContentsOfFile:path];
        HTTPDataResponse* fr = [[HTTPDataResponse alloc] initWithData:data];
        return [fr autorelease];
    } else {
        return nil;
    }
    
}


- (void) startRecording {
    _screenCapture = [[ScreenCaptureView alloc] init];
    [_screenCapture startRecording];
    [_screenCapture recordFrame];

}
- (NSString *) stopRecording {
    NSString* resPath = [_screenCapture stopRecording];
    
    [_screenCapture release];
    _screenCapture = nil;
    return resPath;
}


@end
