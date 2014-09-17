//
//  RainforestInfoCardCell.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class RainforestInfoCardCell: UICollectionViewCell {
  var nodeConstructionOperation: NSBlockOperation?
  var titleLabel: UILabel!
  
  var featureImageOptional: UIImage?
  
  var contentNode: ASDisplayNode?
  var backgroundBlurNode: ASImageNode?
  
  var backgroundGradientLayer: CAGradientLayer!
  let textAreaHeight: CGFloat = 300.0
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleLabel = UILabel(frame: CGRectZero)
    
//    featureImageNode.layer.shadowOffset = CGSizeMake(0, 2)
//    featureImageNode.layer.shadowOpacity = 0.5
//    featureImageNode.layer.shadowColor = UIColor.blackColor().CGColor
//    featureImageNode.layer.shadowRadius = 2
    
//    backgroundGradientLayer = CAGradientLayer()
//    backgroundGradientLayer.backgroundColor = UIColor.clearColor().CGColor
//    backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//    backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
//    let arrayColors: [AnyObject] = [
//      UIColor(white: 0, alpha: 0.6).CGColor,
//      UIColor(white: 0, alpha: 0)
//    ]
//    backgroundGradientLayer.colors = arrayColors
    
  }

  
  override func sizeThatFits(size: CGSize) -> CGSize {
    if let featureImageViewFrame = featureImageViewFrameWithWidth(size.width) {
      return CGSize(width: size.width, height: featureImageViewFrame.maxY + textAreaHeight)
    }
    return CGSize(width: size.width, height: 10.0)
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()

//    backgroundGradientLayer.frame = featureImageNode.bounds
//    contentView.layer.insertSublayer(backgroundGradientLayer, above: featureImageNode.layer)
    
//    titleLabel.frame = CGRectInset(CGRectMake(0, featureImageNode.frame.maxY - 80.0, contentNode.bounds.width, 80), 20, 20)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    // TODO: Cancel expensive operations.
//    backgroundImageNode.hidden = true
//    featureImageNode.hidden = true
    contentNode?.recursiveSetPreventOrCancelDisplay(true)
    backgroundBlurNode?.preventOrCancelDisplay = true
    if let operation = nodeConstructionOperation {
      operation.cancel()
    }
    contentNode?.layer.removeFromSuperlayer()
    contentNode = nil
  }
  
  
  func featureImageViewFrameWithWidth(width: CGFloat) -> CGRect? {
    // TODO: Handle 1.0 scale.
    if let image = featureImageOptional {
      let height = (image.size.height / image.size.width) * width
      return CGRectMake(0, 0, width, height)
    }
    return nil
  }
  
}
