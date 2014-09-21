//
//  NodeFramesetter.swift
//  Layers
//
//  Created by René Cacheaux on 9/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

class NodeFramesetter {
  class var textAreaHeight: CGFloat {
    return 300.0
  }
  
  class func layOutRainforestInfoCardNodeHierarchy(#contentNode: ASDisplayNode, backgroundImageNode: ASImageNode, featureImageNode: ASImageNode, gradientNode: LAGradientNode, titleTextNode: ASTextNode, descriptionTextNode: ASTextNode) {
    let width: CGFloat = 320.0 //TODO: Remove hardcoded value.
    if let image = featureImageNode.image {
      //TODO Maybe move this UIKit call onto main thread before this block.
      let size = sizeThatFits(CGSizeMake(width, CGFloat.max), withImage: image)
      contentNode.frame = CGRect(x: 0.0, y: 0.0, width: width, height: size.height)
      backgroundImageNode.frame = contentNode.bounds
      featureImageNode.frame = frameForImage(image, width: width)
      gradientNode.frame = featureImageNode.frame
      titleTextNode.frame = CGRectInset(CGRectMake(0, featureImageNode.frame.maxY - 70.0, contentNode.bounds.width, 70), 20, 20)
      descriptionTextNode.frame = CGRectMake(24.0, featureImageNode.frame.maxY + 20.0, contentNode.bounds.width - 48.0, textAreaHeight)
    } else {
      // TODO: Add Assert.
      contentNode.frame = CGRectZero
      backgroundImageNode.frame = CGRectZero
      featureImageNode.frame = CGRectZero
      gradientNode.frame = CGRectZero
      titleTextNode.frame = CGRectZero
      descriptionTextNode.frame = CGRectZero
    }
  }

  class func sizeThatFits(size: CGSize, withImage image: UIImage) -> CGSize {
    let imageFrame = frameForImage(image, width: size.width)
    return CGSize(width: size.width, height: imageFrame.maxY + textAreaHeight)
  }
  
  class func frameForImage(image: UIImage, width: CGFloat) -> CGRect {
    let height =  ceil((image.size.height / image.size.width) * width)
    return CGRectMake(0, 0, width, height)
  }
  
}
