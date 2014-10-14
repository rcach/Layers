//
//  LAAnimatedDisplayLayer.m
//  Layers
//
//  Created by René Cacheaux on 10/13/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "LAAnimatedDisplayLayer.h"

#import <QuartzCore/QuartzCore.h>

@implementation LAAnimatedDisplayLayer

+ (id<CAAction>)defaultActionForKey:(NSString *)event {
  id<CAAction> action = [super defaultActionForKey:event];
  if (action) {
    return action;
  }
  
  return (id<CAAction>)[NSNull null];
}

- (id<CAAction>)actionForKey:(NSString *)event {
  id<CAAction> action = [super actionForKey:event];
  if (action) {
    return action;
  }
  
  if ([event isEqualToString:@"contents"] && !self.contents) {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.type = kCATransitionFade;
    return transition;
  }
  
  return nil;
}


@end
