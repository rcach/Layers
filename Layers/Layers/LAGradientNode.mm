//
//  LAGradientNode.m
//  Layers
//
//  Created by René Cacheaux on 9/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "LAGradientNode.h"

#import <CoreGraphics/CoreGraphics.h>
#import <AsyncDisplayKit/_ASDisplayLayer.h>


@interface LAGradientNodeDrawParameters : NSObject

@end

@implementation LAGradientNodeDrawParameters

@end


@implementation LAGradientNode


#pragma mark - Drawing

+ (void)drawRect:(CGRect)bounds withParameters:(LAGradientNodeDrawParameters *)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing
{
  CGContextRef myContext = UIGraphicsGetCurrentContext();
  CGContextSaveGState(myContext);
  CGContextClipToRect(myContext, bounds);
  
  CGGradientRef myGradient;
  CGColorSpaceRef myColorspace;
  size_t num_locations = 2;
  CGFloat locations[2] = { 0.5, 0.94 };
  CGFloat components[8] = { 0.0, 0.0, 0.0, 0.0,
                            0.0, 0.0, 0.0, 0.6 };
  
  myColorspace = CGColorSpaceCreateDeviceRGB();
  myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
                                                    locations, num_locations);
  CGPoint myStartPoint, myEndPoint;
  myStartPoint.x = CGRectGetMidX(bounds);
  myStartPoint.y = 0.0;
  myEndPoint.x = CGRectGetMidX(bounds);
  myEndPoint.y = CGRectGetMaxY(bounds);
  CGContextDrawLinearGradient(myContext, myGradient, myStartPoint, myEndPoint, kCGGradientDrawsAfterEndLocation);
  
  CFRelease(myGradient);
  CFRelease(myColorspace);
  
  CGContextRestoreGState(myContext);
}

- (NSObject *)drawParametersForAsyncLayer:(_ASDisplayLayer *)layer
{
  return [[LAGradientNodeDrawParameters alloc] init];
}

@end
