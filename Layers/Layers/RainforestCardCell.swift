//
//  RainforestCardCell.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class RainforestCardCell: UICollectionViewCell {
  var featureImageSizeOptional: CGSize?
  var containerNode: ASDisplayNode?, backgroundBlurNode: ASImageNode?
  var contentLayer: CALayer?, placeholderLayer: CALayer!
  var nodeConstructionOperation: NSOperation?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    placeholderLayer = CALayer()
    placeholderLayer.contents = UIImage(named: "cardPlaceholder").CGImage
    placeholderLayer.contentsGravity = kCAGravityCenter
    placeholderLayer.contentsScale = UIScreen.mainScreen().scale
    placeholderLayer.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1).CGColor
    contentView.layer.addSublayer(placeholderLayer)
  }

  //MARK: Layout
  override func sizeThatFits(size: CGSize) -> CGSize {
    if let featureImageSize = featureImageSizeOptional {
      return FrameCalculator.sizeThatFits(size, withImageSize: featureImageSize)
    } else {
      return CGSizeZero
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    placeholderLayer?.frame = bounds
    CATransaction.commit()
  }
  
  //MARK: Cell Reuse
  override func prepareForReuse() {
    super.prepareForReuse()
    
    if let operation = nodeConstructionOperation {
      operation.cancel()
    }
    containerNode?.recursiveSetPreventOrCancelDisplay(true)
    //FIXME: Remove backgroundBlurNode stored property once AsyncDisplayKit pull request #41 is merged.
    backgroundBlurNode?.preventOrCancelDisplay = true
    contentLayer?.removeFromSuperlayer()
    contentLayer = nil
    containerNode = nil
    backgroundBlurNode = nil
  }
  
  //MARK: Subviews
  func configureCellDisplayWithCardInfo(cardInfo: RainforestCardInfo,
      nodeConstructionQueue: NSOperationQueue) {
    if let oldNodeConstructionOperation = nodeConstructionOperation {
      oldNodeConstructionOperation.cancel()
    }
    
    let image = UIImage(named: cardInfo.imageName)
    featureImageSizeOptional = image.size
        
    let newNodeConstructionOperation = nodeConstructionOperationWithCardInfo(cardInfo, image: image)
    nodeConstructionOperation = newNodeConstructionOperation
    nodeConstructionQueue.addOperation(newNodeConstructionOperation)
  }
  
  //MARK: Nodes
  func nodeConstructionOperationWithCardInfo(cardInfo: RainforestCardInfo,
      image: UIImage) -> NSOperation {
    let nodeConstructionOperation = NSBlockOperation()
    nodeConstructionOperation.addExecutionBlock {
      [unowned nodeConstructionOperation, weak self] in
      
      // 0: Preflight check
      if nodeConstructionOperation.cancelled {
        return
      }
      if self == nil {
        return
      }
      if NSThread.isMainThread() {
        return
      }
      let cell = self!
      
      // Build background blur node
      let backgroundImageNode = ASImageNode()
      backgroundImageNode.layerBacked = true
      backgroundImageNode.contentMode = .ScaleAspectFill
      backgroundImageNode.image = image
      backgroundImageNode.imageModificationBlock = { [weak backgroundImageNode] (input: UIImage!) -> UIImage in
        if input == nil {
          return input
        }
        let didCancelBlur: () -> Bool = {
          var isCancelled = false
          let isCancelledClosure = {
            isCancelled = backgroundImageNode == nil || backgroundImageNode!.preventOrCancelDisplay
          }
          if NSThread.isMainThread() {
            isCancelledClosure()
          } else {
            dispatch_sync(dispatch_get_main_queue(), isCancelledClosure)
          }
          return isCancelled
        }
        if let blurredImage = input.applyBlurWithRadius(30, tintColor: UIColor(white: 0.5, alpha: 0.3),
          saturationDeltaFactor: 1.8, maskImage: nil,
          didCancel:didCancelBlur) {
            return blurredImage
        } else {
          return image
        }
      }
      
      let featureImageNode = ASImageNode()
      featureImageNode.layerBacked = true
      featureImageNode.contentMode = .ScaleAspectFit
      featureImageNode.image = image
      
      let descriptionTextNode = ASTextNode()
      descriptionTextNode.layerBacked = true
      descriptionTextNode.backgroundColor = UIColor.clearColor()
      descriptionTextNode.attributedString = NSAttributedString.attributedStringForDescriptionText(cardInfo.description)
      
      let titleTextNode = ASTextNode()
      titleTextNode.layerBacked = true
      titleTextNode.backgroundColor = UIColor.clearColor()
      titleTextNode.attributedString = NSAttributedString.attributesStringForTitleText(cardInfo.name)
      
      let gradientNode = LAGradientNode()
      gradientNode.layerBacked = true
      
      // Build container node and construct node hierarchy
      let containerNode = ASDisplayNode(layerClass: LAAnimatedDisplayLayer.self)
      containerNode.layerBacked = true
      containerNode.shouldRasterizeDescendants = true
      containerNode.borderColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 0.2).CGColor
      containerNode.borderWidth = 1
      
      // Build hierarchy
      containerNode.addSubnode(backgroundImageNode)
      containerNode.addSubnode(featureImageNode)
      containerNode.addSubnode(gradientNode)
      containerNode.addSubnode(titleTextNode)
      containerNode.addSubnode(descriptionTextNode)
      
      // Layout nodes
      containerNode.frame = FrameCalculator.frameForContainer(featureImageSize: image.size)
      backgroundImageNode.frame = FrameCalculator.frameForBackgroundImage(containerBounds: containerNode.bounds)
      featureImageNode.frame = FrameCalculator.frameForFeatureImage(featureImageSize: image.size,
        containerFrameWidth: containerNode.frame.size.width)
      titleTextNode.frame = FrameCalculator.frameForTitleText(containerBounds: containerNode.bounds,
        featureImageFrame: featureImageNode.frame)
      descriptionTextNode.frame = FrameCalculator.frameForDescriptionText(containerBounds: containerNode.bounds,
        featureImageFrame: featureImageNode.frame)
      gradientNode.frame = FrameCalculator.frameForGradient(featureImageFrame: featureImageNode.frame)
      
      // Fast return if operation cancelled
      if nodeConstructionOperation.cancelled {
        return
      }
      
      // Get on main thread and add container node's layer to cell's content view
      dispatch_async(dispatch_get_main_queue()) { [weak nodeConstructionOperation] in
        if nodeConstructionOperation == nil || nodeConstructionOperation!.cancelled {
          return
        }
        if cell.nodeConstructionOperation !== nodeConstructionOperation! {
          return
        }
        cell.contentView.layer.addSublayer(containerNode.layer)
        cell.containerNode = containerNode
        cell.backgroundBlurNode = backgroundImageNode
        cell.contentLayer = containerNode.layer
        
        containerNode.setNeedsDisplay()
      }
    }
    return nodeConstructionOperation
  }
  
}
