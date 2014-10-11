//
//  NodeFactory.swift
//  Layers
//
//  Created by René Cacheaux on 9/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

class NodeFactory {
  class func createNewContentNode() -> ASDisplayNode {
    let contentNode = createNewFadeInNode()
    contentNode.shouldRasterizeDescendants = true
    return contentNode
  }
  
  class func createNewTitleNodeWithString(title: String) -> ASTextNode {
    let titleTextNode = createNewTextNode()
    titleTextNode.backgroundColor = UIColor.clearColor()
    
    var titleTextShadow = NSShadow()
    titleTextShadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
    titleTextShadow.shadowOffset = CGSize(width: 0, height: 2)
    titleTextShadow.shadowBlurRadius = 3.0
    
    let titleAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Heavy", size: 30),
                           NSForegroundColorAttributeName: UIColor.whiteColor(),
                           NSShadowAttributeName: titleTextShadow,
                           NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
    
    titleTextNode.attributedString = NSAttributedString(string: title, attributes: titleAttributes)
    
    return titleTextNode
  }
  
  
  class func createNewDescriptionNodeWithString(description: String) -> ASTextNode {
    let descriptionTextNode = createNewTextNode()
    descriptionTextNode.backgroundColor = UIColor.clearColor()
    
    var descriptionTextShadow = NSShadow()
    descriptionTextShadow.shadowColor = UIColor(white: 0.0, alpha: 0.3)
    descriptionTextShadow.shadowOffset = CGSize(width: 0, height: 1)
    descriptionTextShadow.shadowBlurRadius = 3.0
    
    let descriptionAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 16), NSShadowAttributeName: descriptionTextShadow, NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
    
    descriptionTextNode.attributedString = NSAttributedString(string: description, attributes: descriptionAttributes)
    
    return descriptionTextNode
  }
  
  class func createNewFeatureImageNodeWithImage(image: UIImage) -> ASImageNode {
    let featureImageNode = createNewImageNode()
    featureImageNode.contentMode = UIViewContentMode.ScaleAspectFit
    featureImageNode.image = image
    return featureImageNode
  }
  
  class func createNewBackgroundImageNodeWithImage(image: UIImage) -> ASImageNode {
    let backgroundImageNode = createNewImageNode()
    backgroundImageNode.contentMode = .ScaleAspectFill
    backgroundImageNode.image = image
    backgroundImageNode.imageModificationBlock = { [weak backgroundImageNode] (input: UIImage!) -> UIImage in
      let tintColor = UIColor(white: 0.5, alpha: 0.3)
      if input == nil {
        return input
      }
      
      let blurredImageOrNil = input.applyBlurWithRadius(30, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil, didCancel: {
        if backgroundImageNode == nil || backgroundImageNode!.isCancelled() {
          return true
        } else {
          return false
        }
      })
      
      if blurredImageOrNil != nil {
        return blurredImageOrNil
      } else {
        return image
      }
    }
    return backgroundImageNode
  }
  
  
  class func createNewGradientNode() -> LAGradientNode {
    let gradientNode = LAGradientNode()
    gradientNode.layerBacked = true
    return gradientNode
  }
  
  class func createNewTextNode() -> ASTextNode {
    let textNode = ASTextNode()
    textNode.layerBacked = true
    return textNode
  }
  
  class func createNewImageNode() -> ASImageNode {
    let imageNode = ASImageNode()
    imageNode.layerBacked = true
    return imageNode
  }
  
  class func createNewFadeInNode() -> ASDisplayNode {
    let displayNode = ASDisplayNode(layerClass: LAAnimatedDisplayLayer.self)
    displayNode.layerBacked = true
    return displayNode
  }
  
}

extension NSParagraphStyle {
  class func justifiedParagraphStyle() -> NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Justified
    return paragraphStyle.copy() as NSParagraphStyle
  }
}