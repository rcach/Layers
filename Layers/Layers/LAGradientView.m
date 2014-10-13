//
//  LAGradientView.m
//  Layers
//
//  Created by René Cacheaux on 10/13/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "LAGradientView.h"

@implementation LAGradientView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef myContext = UIGraphicsGetCurrentContext();
  CGContextSaveGState(myContext);
  CGContextClipToRect(myContext, self.bounds);
  
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
  myStartPoint.x = CGRectGetMidX(self.bounds);
  myStartPoint.y = 0.0;
  myEndPoint.x = CGRectGetMidX(self.bounds);
  myEndPoint.y = CGRectGetMaxY(self.bounds);
  CGContextDrawLinearGradient(myContext, myGradient, myStartPoint, myEndPoint, kCGGradientDrawsAfterEndLocation);
  
  CFRelease(myGradient);
  CFRelease(myColorspace);
  
  CGContextRestoreGState(myContext);
}

@end
