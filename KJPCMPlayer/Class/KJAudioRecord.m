//
//  KJAudioRecord.m
//  KJPCMPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import "KJAudioRecord.h"

@interface KJAudioRecord() <AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDevice *audioDevice;//设备
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;//输入对象
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;//输出对象
@property (nonatomic, assign) KJCaptureSessionPreset definePreset;

@end

@implementation KJAudioRecord

- (instancetype)initCaptureWithSessionPreset:(KJCaptureSessionPreset)preset {
    if ([super init]) {
        [self initAVcaptureSession];
        self.definePreset = preset;
    }
    return self;
}

- (void)initAVcaptureSession {
    //初始化AVCaptureSession
    self.session = [[AVCaptureSession alloc] init];
    //开始配置
    [self.session beginConfiguration];
    
    NSError *error;
    //获取音频设备对象
    self.audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //初始化捕获输入对象
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.audioDevice error:&error];
    if (error) {
        NSLog(@"录音设备出错");
    }
    //添加音频输入对象到session
    if ([self.session canAddInput:self.audioInput]) {
        [self.session addInput:self.audioInput];
    }
    //初始化输出捕获对象
    self.audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    //添加音频输出对象到session
    if ([self.session canAddOutput:self.audioOutput]) {
        [self.session addOutput:self.audioOutput];
    }
    //创建设置音频输出代理所需要的线程队列
    dispatch_queue_t audioQueue = dispatch_get_global_queue(0, 0);
    [self.audioOutput setSampleBufferDelegate:self queue:audioQueue];
    //提交配置
    [self.session commitConfiguration];
}

- (void)start {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.session startRunning];
        
    });
    
}

- (void)stop {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.session stopRunning];
        
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (captureOutput == self.audioOutput) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioWithSampleBuffer:)]) {
            [self.delegate audioWithSampleBuffer:sampleBuffer];
        }
    }
}

@end
