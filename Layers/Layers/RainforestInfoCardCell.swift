//
//  RainforestInfoCardCell.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class RainforestInfoCardCell: UICollectionViewCell {
  var titleLabel: UILabel!
  
  var backgroundGradientLayer: CAGradientLayer!
  let textAreaHeight: CGFloat = 300.0
  
  
  var contentNode: ASDisplayNode!
  
  var backgroundImageNode: ASImageNode!
  var featureImageNode: ASImageNode!
  var descriptionTextNode: ASTextNode!
  
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentNode = ASDisplayNode(layerClass: LAAnimatedDisplayLayer.self)
    contentNode.layerBacked = true
//    contentNode.layer.opacity = 0.0
    
    titleLabel = UILabel(frame: CGRectZero)
    
    
    backgroundImageNode = ASImageNode()
    backgroundImageNode.layerBacked = true
    backgroundImageNode.imageModificationBlock = { input in
      let tintColor = UIColor(white: 0.5, alpha: 0.3)
      return input.applyBlurWithRadius(30, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    backgroundImageNode.contentMode = .ScaleAspectFill
    
    featureImageNode = ASImageNode()
    featureImageNode.layerBacked = true
    featureImageNode.contentMode = UIViewContentMode.ScaleAspectFit
//    featureImageNode.layer.shadowOffset = CGSizeMake(0, 2)
//    featureImageNode.layer.shadowOpacity = 0.5
//    featureImageNode.layer.shadowColor = UIColor.blackColor().CGColor
//    featureImageNode.layer.shadowRadius = 2
    
    descriptionTextNode = ASTextNode()
    descriptionTextNode.layerBacked = true
    descriptionTextNode.backgroundColor = UIColor.clearColor()
    
    
    backgroundGradientLayer = CAGradientLayer()
    backgroundGradientLayer.backgroundColor = UIColor.clearColor().CGColor
    backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
    let arrayColors: [AnyObject] = [
      UIColor(white: 0, alpha: 0.6).CGColor,
      UIColor(white: 0, alpha: 0)
    ]
    backgroundGradientLayer.colors = arrayColors
    
    constructViewHierarchy()
  }
  
  func constructViewHierarchy() {
    contentView.layer.addSublayer(contentNode.layer)
    
    contentNode.addSubnode(backgroundImageNode)
    contentNode.addSubnode(featureImageNode)
    contentNode.addSubnode(descriptionTextNode)

//    contentView.addSubview(titleLabel)
  }
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    if let featureImageViewFrame = featureImageViewFrameWithWidth(size.width) {
      return CGSize(width: size.width, height: featureImageViewFrame.maxY + textAreaHeight)
    }
    return CGSize(width: size.width, height: 10.0)
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentNode.frame = contentView.bounds
    contentNode.shouldRasterizeDescendants = true
    
    backgroundImageNode.frame = contentNode.bounds
    
    if let featureImageViewFrame = featureImageViewFrameWithWidth(contentNode.bounds.width) {
      featureImageNode.frame = featureImageViewFrame
//      featureImageNode.layer.shadowPath = UIBezierPath(rect: featureImageNode.bounds).CGPath
    } else {
      featureImageNode.frame = CGRectZero
//      featureImageNode.layer.shadowPath = UIBezierPath(rect: CGRectZero).CGPath
    }
    
//    backgroundGradientLayer.frame = featureImageNode.bounds
    contentView.layer.insertSublayer(backgroundGradientLayer, above: featureImageNode.layer)
    
    titleLabel.frame = CGRectInset(CGRectMake(0, featureImageNode.frame.maxY - 80.0, contentNode.bounds.width, 80), 20, 20)
    
    descriptionTextNode.frame = CGRectMake(24.0, featureImageNode.frame.maxY + 20.0, contentNode.bounds.width - 48.0, textAreaHeight)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    // TODO: Cancel expensive operations.
//    backgroundImageNode.hidden = true
//    featureImageNode.hidden = true
    contentNode.preventOrCancelDisplay = true
    contentNode.layer.contents = nil;
  }
  
  
  func featureImageViewFrameWithWidth(width: CGFloat) -> CGRect? {
    // TODO: Handle 1.0 scale.
    if let image = featureImageNode.image {
      let height = (image.size.height / image.size.width) * width
      return CGRectMake(0, 0, width, height)
    }
    return nil
  }
  
  func updateTitle(title: String, andDescription description: NSString) {
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Justified
    
    var titleTextShadow = NSShadow()
    titleTextShadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
    titleTextShadow.shadowOffset = CGSize(width: 0, height: 2)
    titleTextShadow.shadowBlurRadius = 3.0
    
    
    var descriptionTextShadow = NSShadow()
    descriptionTextShadow.shadowColor = UIColor(white: 0.0, alpha: 0.3)
    descriptionTextShadow.shadowOffset = CGSize(width: 0, height: 1)
    descriptionTextShadow.shadowBlurRadius = 3.0
    
    
    let titleAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Heavy", size: 30), NSForegroundColorAttributeName: UIColor.whiteColor(), NSShadowAttributeName: titleTextShadow, NSParagraphStyleAttributeName: paragraphStyle]
    titleLabel.attributedText = NSAttributedString(string: title, attributes: titleAttributes)
    
    let descriptionAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 16), NSShadowAttributeName: descriptionTextShadow, NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSParagraphStyleAttributeName: paragraphStyle]
    descriptionTextNode.attributedString = NSAttributedString(string: description, attributes: descriptionAttributes)
  }
  
}
