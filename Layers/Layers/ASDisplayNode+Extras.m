//
//  ASDisplayNode+ASDisplayNode_Extras.m
//  Layers
//
//  Created by René Cacheaux on 10/10/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "ASDisplayNode+Extras.h"

@implementation ASDisplayNode (ASDisplayNode_Extras)

- (BOOL)isCancelled {
  if (self.preventOrCancelDisplay) {
    return YES;
  } else {
    return NO;
  }
}

@end
