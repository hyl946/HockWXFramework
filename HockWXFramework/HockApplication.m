//
//  HockApplication.m
//  HockWXFramework
//
//  Created by Loren on 2017/11/21.
//  Copyright © 2017年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaptainHook.h"

#pragma mark - 微信
//修改步数
unsigned int stepCount;
@interface WCDeviceStepObject
- (unsigned int)hkStepCount;
- (unsigned int)m7StepCount;
@end
CHDeclareClass(WCDeviceStepObject)
CHOptimizedMethod(0, self, unsigned int, WCDeviceStepObject,m7StepCount){
    //change the value
    return stepCount;
}

CHConstructor{
    CHLoadLateClass(WCDeviceStepObject);
    CHClassHook(0, WCDeviceStepObject, m7StepCount);
}

//获取收发短信
@interface CMessageWrap
@property (nonatomic, strong) NSString* m_nsContent;
@property (nonatomic, assign) NSInteger m_uiMessageType;
@end
CHDeclareClass(CMessageMgr)
CHMethod2(void, CMessageMgr, AsyncOnAddMsg, NSString*, msg, MsgWrap, CMessageWrap*, msgWrap){
    NSString* content = [msgWrap m_nsContent];
    if([msgWrap m_uiMessageType] == 1){
        NSLog(@"收到消息: %@", content);
    }
    if([content hasPrefix:@"##"]){
        NSMutableString * mutableMessage = [NSMutableString stringWithString:content];
        [mutableMessage deleteCharactersInRange:NSMakeRange(0, 2)];
        unsigned int step = [mutableMessage intValue];
        stepCount = step;
    }
    CHSuper2(CMessageMgr, AsyncOnAddMsg, msg, MsgWrap, msgWrap);
}
CHConstructor{
    CHLoadLateClass(CMessageMgr);
    CHClassHook2(CMessageMgr, AsyncOnAddMsg, MsgWrap);
}
