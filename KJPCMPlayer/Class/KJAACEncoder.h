//
//  KJAACEncoder.h
//  KJPCMPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol KJAACSendDelegate <NSObject>
- (void)sendData:(NSMutableData *)data;
@end

@interface KJAACEncoder : NSObject

@property (nonatomic, strong) id<KJAACSendDelegate> delegate;
-(void)encodeSmapleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
