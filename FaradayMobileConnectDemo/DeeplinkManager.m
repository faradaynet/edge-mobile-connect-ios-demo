// DeeplinkManager.m
#import "DeeplinkManager.h"

@implementation DeeplinkManager

+ (instancetype)shared {
    static DeeplinkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DeeplinkManager alloc] init];
    });
    return sharedInstance;
}

@end
