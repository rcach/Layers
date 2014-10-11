//
//  NodeFramesetter.swift
//  Layers
//
//  Created by René Cacheaux on 9/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

class FrameCalculator {
  class var textAreaHeight: CGFloat {
    //TODO: This constant is also inside the cell class, consolidate.
    return 300.0
  }

  class func frameForDescriptionText(#containerBounds: CGRect, featureImageFrame: CGRect) -> CGRect {
    return CGRectMake(24.0, featureImageFrame.maxY + 20.0, containerBounds.width - 48.0, textAreaHeight)
  }
  
  class func frameForTitleText(#containerBounds: CGRect, featureImageFrame: CGRect) -> CGRect {
    return CGRectInset(CGRectMake(0, featureImageFrame.maxY - 70.0, containerBounds.width, 70), 20, 20)
  }
  
  class func frameForGradient(#featureImageFrame: CGRect) -> CGRect {
    return featureImageFrame
  }
  
  class func frameForFeatureImage(#featureImageSize: CGSize, containerFrameWidth: CGFloat) -> CGRect {
    let imageFrameSize = aspectSizeForWidth(containerFrameWidth, originalSize: featureImageSize)
    return CGRect(x: 0, y: 0, width: imageFrameSize.width, height: imageFrameSize.height)
  }
  
  class func frameForBackgroundImage(#containerBounds: CGRect) -> CGRect {
    return containerBounds
  }
  
  class func frameForContainer(#featureImageSize: CGSize) -> CGRect {
    let containerWidth: CGFloat = 320.0 //TODO: Remove hardcoded value?
    let size = sizeThatFits(CGSizeMake(containerWidth, CGFloat.max), withImageSize: featureImageSize)
    return CGRect(x: 0, y: 0, width: containerWidth, height: size.height)
  }
  
  //TODO: Consolodate into one method inside Cell or call from cell.
  class func sizeThatFits(size: CGSize, withImageSize imageSize: CGSize) -> CGSize {
    let imageFrameSize = aspectSizeForWidth(size.width, originalSize: imageSize)
    return CGSize(width: size.width, height: imageFrameSize.height + textAreaHeight)
  }
  
  class func aspectSizeForWidth(width: CGFloat, originalSize: CGSize) -> CGSize {
    let height =  ceil((originalSize.height / originalSize.width) * width)
    return CGSize(width: width, height: height)
  }
  
}
