//
//  KJAudioRecord.h
//  KJPCMPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger,KJCaptureSessionPreset) {
    KJCaptureSessionPreset640x480,
    KJCaptureSessionPresetiFrame960x540,
    KJCaptureSessionPreset1280x720,
};

@protocol KJAudioRecordDelegate <NSObject>
- (void)audioWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end

@interface KJAudioRecord : NSObject

@property (nonatomic, strong) id<KJAudioRecordDelegate> delegate;
@property (nonatomic, strong) AVCaptureSession *session;//管理对象

- (instancetype)initCaptureWithSessionPreset:(KJCaptureSessionPreset)preset;
- (void)start;
- (void)stop;

@end
