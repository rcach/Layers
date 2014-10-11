//
//  RainforestCardCell.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class RainforestCardCell: UICollectionViewCell {
  var nodeConstructionOperation: NSBlockOperation?
  
  var featureImageSizeOptional: CGSize?
  
  var contentNode: ASDisplayNode?
  var backgroundBlurNode: ASImageNode?
  
  let textAreaHeight: CGFloat = 300.0
  
  var contentLayer: CALayer?
  var placeholderLayer: CALayer?
  
  var cardView: RainforestCardView
  
  required init(coder aDecoder: NSCoder) {
    cardView = RainforestCardView()
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.placeholderLayer = CALayer()
    self.placeholderLayer?.contents = UIImage(named: "placeholder").CGImage
    self.placeholderLayer?.contentsGravity = kCAGravityCenter
    self.placeholderLayer?.contentsScale = UIScreen.mainScreen().scale
    self.placeholderLayer?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1).CGColor
    self.contentView.layer.addSublayer(self.placeholderLayer)
  }

  //MARK: Layout
  override func sizeThatFits(size: CGSize) -> CGSize {
    return threadSafeSizeThatFits(size)
  }
  
  func threadSafeSizeThatFits(size: CGSize) -> CGSize {
    if let featureImageViewFrame = featureImageViewFrameWithWidth(size.width) {
      return CGSize(width: size.width, height: featureImageViewFrame.maxY + textAreaHeight)
    } else {
      return CGSize(width: size.width, height: 10.0)
    }
  }
  
  func featureImageViewFrameWithWidth(width: CGFloat) -> CGRect? {
    // TODO: Handle 1.0 scale.
    if let imageSize = featureImageSizeOptional {
      let height = (imageSize.height / imageSize.width) * width
      return CGRectMake(0, 0, width, height)
    }
    return nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    self.placeholderLayer?.frame = self.bounds
    CATransaction.commit()
  }
  
  func layoutCellContent() {
    
  }
  
  //MARK: Cell Reuse
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
  
  //TODO: Remove this method.
  func removeAllContentViewSublayers() {
    if let sublayers = self.contentView.layer.sublayers {
      for layer in sublayers as [CALayer] {
        if layer !== self.placeholderLayer {
          layer.removeFromSuperlayer()
        }
      }
    }
  }
  
  //MARK: Nodes
  func nodeConstructionOperationWithLifeform(lifeform: RainforestCardInfo, image: UIImage) -> NSOperation {
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
      let lifeformImage = image
      
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
      
      //TODO: Rename contentNode to container node.
      //TODO: Pass in image size straight up, without grabbing image from node.
      contentNode.frame = FrameCalculator.frameForContainer(featureImageSize: featureImageNode.image.size)
      backgroundImageNode.frame = FrameCalculator.frameForBackgroundImage(containerBounds: contentNode.bounds)
      //TODO: Pass in image size straight up, without grabbing image from node.
      featureImageNode.frame = FrameCalculator.frameForFeatureImage(featureImageSize: featureImageNode.image.size, containerFrameWidth: contentNode.frame.size.width)
      gradientNode.frame = FrameCalculator.frameForGradient(featureImageFrame: featureImageNode.frame)
      titleTextNode.frame = FrameCalculator.frameForTitleText(containerBounds: contentNode.bounds, featureImageFrame: featureImageNode.frame)
      descriptionTextNode.frame = FrameCalculator.frameForDescriptionText(containerBounds: contentNode.bounds, featureImageFrame: featureImageNode.frame)
      
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

}
