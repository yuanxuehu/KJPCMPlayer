//
//  KJPCMPlayer.h
//  KJPCMPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import <Foundation/Foundation.h>

@interface KJPCMPlayer : NSObject

- (instancetype)initWithSampleRate:(int)sampleRate;
- (void)playWithData:(NSData *)data;

@end
