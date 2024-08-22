//
//  KJAACDecoder.h
//  KJPCMPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import <Foundation/Foundation.h>

@interface KJAACDecoder : NSObject

- (BOOL)initAACDecoderWithSampleRate:(int)sampleRate channel:(int)channel bit:(int)bit;
- (void)AACDecoderWithMediaData:(NSData *)mediaData sampleRate:(int)sampleRate completion:(void(^)(uint8_t *out_buffer, size_t out_buffer_size))completion;
- (void)releaseAACDecoder;

@end
