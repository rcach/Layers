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
  
  var featureImageOptional: UIImage?
  
  var contentNode: ASDisplayNode?
  var backgroundBlurNode: ASImageNode?
  
  let textAreaHeight: CGFloat = 300.0
  
  var contentLayer: CALayer?
  var placeholderLayer: CALayer?
  
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.contentView.backgroundColor = UIColor.greenColor()
    self.placeholderLayer = CALayer()
    
    
    let placeholderImage = UIImage(named: "placeholder").resizableImageWithCapInsets(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    self.placeholderLayer?.contents = placeholderImage.CGImage
    self.placeholderLayer?.contentsGravity = kCAGravityCenter
    self.placeholderLayer?.contentsScale = UIScreen.mainScreen().scale
    self.placeholderLayer?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1).CGColor
    
    self.contentView.layer.addSublayer(self.placeholderLayer)
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    if let featureImageViewFrame = featureImageViewFrameWithWidth(size.width) {
      return CGSize(width: size.width, height: featureImageViewFrame.maxY + textAreaHeight)
    }
    return CGSize(width: size.width, height: 10.0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    self.placeholderLayer?.frame = self.bounds
    CATransaction.commit()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    // TODO: Cancel expensive operations.
    contentNode?.recursiveSetPreventOrCancelDisplay(true)
    backgroundBlurNode?.preventOrCancelDisplay = true
    if let operation = nodeConstructionOperation {
      operation.cancel()
    }
    contentLayer?.removeFromSuperlayer()
    contentLayer = nil
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
  
  
  func nodeConstructionOperationWithLifeform(lifeform: RainforestLifeform) -> NSOperation {
    let nodeConstructionOperation = NSBlockOperation()
    nodeConstructionOperation.addExecutionBlock { [unowned nodeConstructionOperation, weak self] in
      if nodeConstructionOperation.cancelled {
        return
      }
      if self == nil {
        return
      }
      if NSThread.isMainThread() {
        return
      }
      
      // TODO: Does Swift automatically promote weak capture var to Strong?
      let realCell = self!
      let lifeformImage = UIImage(named: lifeform.imageName)
      
      let featureImageNode = NodeFactory.createNewFeatureImageNodeWithImage(lifeformImage)
      let backgroundImageNode = NodeFactory.createNewBackgroundImageNodeWithImage(lifeformImage)
      let descriptionTextNode = NodeFactory.createNewDescriptionNodeWithString(lifeform.description)
      let titleTextNode = NodeFactory.createNewTitleNodeWithString(lifeform.name)
      let gradientNode = NodeFactory.createNewGradientNode()
      
      if nodeConstructionOperation.cancelled {
        return
      }
      
      let contentNode = NodeFactory.createNewContentNode()
      contentNode.addSubnode(backgroundImageNode)
      contentNode.addSubnode(featureImageNode)
      contentNode.addSubnode(gradientNode)
      contentNode.addSubnode(titleTextNode)
      contentNode.addSubnode(descriptionTextNode)
      
      if nodeConstructionOperation.cancelled {
        return
      }
      
      NodeFramesetter.layOutRainforestInfoCardNodeHierarchy(contentNode: contentNode, backgroundImageNode: backgroundImageNode, featureImageNode: featureImageNode, gradientNode: gradientNode, titleTextNode: titleTextNode, descriptionTextNode: descriptionTextNode)
      
      if nodeConstructionOperation.cancelled {
        return
      }
      
      dispatch_async(dispatch_get_main_queue()) { [nodeConstructionOperation, realCell] in
        if nodeConstructionOperation.cancelled {
          return
        }
        if realCell.nodeConstructionOperation !== nodeConstructionOperation {
          return
        }
        realCell.contentNode = contentNode
        realCell.backgroundBlurNode = backgroundImageNode
        realCell.contentLayer = contentNode.layer
        realCell.contentView.layer.addSublayer(realCell.contentLayer)
        contentNode.layer.setNeedsDisplay()
      }
      
    }
    // TODO: Method doesn't say that this assignment happens.
    self.nodeConstructionOperation = nodeConstructionOperation
    return nodeConstructionOperation
  }
  
  func removeAllContentViewSublayers() {
    if let sublayers = self.contentView.layer.sublayers {
      for layer in sublayers as [CALayer] {
        if layer !== self.placeholderLayer {
          layer.removeFromSuperlayer()
        }
      }
    }
  }
  
}
