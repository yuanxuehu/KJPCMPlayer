//
//  ViewController.m
//  KJPCMPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KJAudioRecord.h"
#import "KJAACEncoder.h"
#import "KJAACDecoder.h"
#import "KJPCMPlayer.h"

#define SAMPLE_RATE 16000
#define BIT_RATE SAMPLE_RATE*16

@interface ViewController () <KJAudioRecordDelegate,KJAACSendDelegate>

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) KJAudioRecord *captureSession;
@property (nonatomic, strong) KJAACEncoder *aacEncoder;
@property (nonatomic, strong) KJAACDecoder *aacDecoder;
@property (nonatomic, strong) KJPCMPlayer *pcmPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    self.recordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.recordButton.frame = CGRectMake((self.view.frame.size.width-100)/2, 300, 100, 50);
    [self.recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
    [self.recordButton setTitle:@"停止录制" forState:UIControlStateSelected];
    [self.recordButton addTarget:self action:@selector(startAAC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
    
}

- (void)initAACEncoder {
    self.captureSession = [[KJAudioRecord alloc] initCaptureWithSessionPreset:KJCaptureSessionPreset640x480];
    self.captureSession.delegate = self;
    self.aacEncoder = [[KJAACEncoder alloc] init];
    self.aacEncoder.delegate = self;
}

//播放pcm
- (void)decoderAAC:(NSMutableData *)data {
    __weak typeof(self)ws = self;
    //1、aac2pcm
    [self.aacDecoder AACDecoderWithMediaData:data sampleRate:SAMPLE_RATE completion:^(uint8_t *out_buffer, size_t out_buffer_size) {
        NSData *pcm = [NSData dataWithBytes:out_buffer length:out_buffer_size];
        //2、playPCM
        [ws.pcmPlayer playWithData:pcm];
    }];
}

- (void)startAAC:(UIButton *)sender {
    
    UIButton *button = sender;
    button.selected = !button.selected;
    
    if (button.isSelected) {
        //查询麦克风权限
        [self checkMicrophoneAuthority];
    } else {
        [self.captureSession stop];
        self.captureSession = nil;
        self.captureSession.delegate = nil;
        self.captureSession = nil;
        self.aacEncoder.delegate = nil;
        self.aacEncoder = nil;
        [self.aacDecoder releaseAACDecoder];
        self.aacDecoder = nil;
        self.pcmPlayer = nil;
    }
}

- (void)checkMicrophoneAuthority {
   AVAudioSession *audioSession = [AVAudioSession sharedInstance];
   switch (audioSession.recordPermission) {
       case AVAudioSessionRecordPermissionUndetermined: //用户还未选择马克风权限
       {//弹出权限选择
           if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
               [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                   
               }];
           }
       }
           break;
       case AVAudioSessionRecordPermissionDenied: //用户禁止麦克风权限
       {//提示用户跳转设置打开权限
           
           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有权限" message:@"请打开麦克风🎤权限" preferredStyle:UIAlertControllerStyleAlert];
           [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               
           }]];
           [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
               if ([[UIApplication sharedApplication] canOpenURL:url]) {
                   [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
                       
                   }];
               }
           }]];
           [self presentViewController:alert animated:YES completion:nil];
       }
           break;
       case AVAudioSessionRecordPermissionGranted://用户允许麦克风权限
             {
                 //开启音频录制
                 [self initAACEncoder];
                 [self.captureSession start];
                 self.aacDecoder = [[KJAACDecoder alloc] init];
                 [self.aacDecoder initAACDecoderWithSampleRate:SAMPLE_RATE channel:2 bit:BIT_RATE];
                 self.pcmPlayer = [[KJPCMPlayer alloc] initWithSampleRate:SAMPLE_RATE*2];
                 
             }
                 break;
                 
             default:
                 break;
   }
}

#pragma mark - KJAudioRecordDelegate
- (void)audioWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [self.aacEncoder encodeSmapleBuffer:sampleBuffer];
}

#pragma mark - KJAACSendDelegate
- (void)sendData:(NSMutableData *)data {
   //准备发送的音频数据
    
}

@end
