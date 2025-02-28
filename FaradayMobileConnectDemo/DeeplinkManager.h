// DeeplinkManager.h
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeeplinkManager : NSObject

+ (instancetype)shared;  // Singleton method
@property (nonatomic, strong, nullable) NSURL *deeplinkURL;

@end

NS_ASSUME_NONNULL_END
