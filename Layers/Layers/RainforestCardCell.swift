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
  
  var containerNode: ASDisplayNode?
  var backgroundBlurNode: ASImageNode?
  
  var contentLayer: CALayer?
  var placeholderLayer: CALayer?

  
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
    if let featureImageSize = featureImageSizeOptional {
      return FrameCalculator.sizeThatFits(size, withImageSize: featureImageSize)
    } else {
      //TODO: Assert
      return CGSize(width: size.width, height: 0)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    self.placeholderLayer?.frame = self.bounds
    CATransaction.commit()
  }
  
  //MARK: Cell Reuse
  override func prepareForReuse() {
    super.prepareForReuse()
    
    // TODO: Cancel expensive operations.
    containerNode?.recursiveSetPreventOrCancelDisplay(true)
    backgroundBlurNode?.preventOrCancelDisplay = true
    if let operation = nodeConstructionOperation {
      operation.cancel()
    }
    contentLayer?.removeFromSuperlayer()
    contentLayer = nil
    containerNode = nil
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
  func nodeConstructionOperationWithCardInfo(cardInfo: RainforestCardInfo, image: UIImage) -> NSOperation {
    let nodeConstructionOperation = NSBlockOperation()
    nodeConstructionOperation.addExecutionBlock { [unowned nodeConstructionOperation, weak self] in
      
      
      
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
      // TODO: Does Swift automatically promote weak capture var to Strong?
      let cell = self!
      
      
      
      // 1: Build all subnodes
      let featureImageNode = ASImageNode()
      featureImageNode.layerBacked = true
      featureImageNode.contentMode = UIViewContentMode.ScaleAspectFit
      featureImageNode.image = image
      
      let backgroundImageNode = ASImageNode()
      backgroundImageNode.layerBacked = true
      backgroundImageNode.contentMode = .ScaleAspectFill
      backgroundImageNode.image = image
      backgroundImageNode.imageModificationBlock = { [weak backgroundImageNode] (input: UIImage!) -> UIImage in
        if input == nil {
          return input
        }
        
        let tintColor = UIColor(white: 0.5, alpha: 0.3)
        let didCancelBlur: () -> Bool = {
          return backgroundImageNode == nil || backgroundImageNode!.isCancelled()
        }
        
        if let blurredImage = input.applyBlurWithRadius(30, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil, didCancel:didCancelBlur) {
          return blurredImage
        } else {
          return image
        }
      }
      
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
      
      
      
      // 2: Build container node and construct node hierarchy
      let containerNode = ASDisplayNode(layerClass: LAAnimatedDisplayLayer.self)
      containerNode.layerBacked = true
      containerNode.shouldRasterizeDescendants = true
      
      containerNode.addSubnode(backgroundImageNode)
      containerNode.addSubnode(featureImageNode)
      containerNode.addSubnode(gradientNode)
      containerNode.addSubnode(titleTextNode)
      containerNode.addSubnode(descriptionTextNode)
      
      
      
      // 3: Layout nodes
      containerNode.frame = FrameCalculator.frameForContainer(featureImageSize: image.size)
      backgroundImageNode.frame = FrameCalculator.frameForBackgroundImage(containerBounds: containerNode.bounds)
      featureImageNode.frame = FrameCalculator.frameForFeatureImage(featureImageSize: image.size, containerFrameWidth: containerNode.frame.size.width)
      gradientNode.frame = FrameCalculator.frameForGradient(featureImageFrame: featureImageNode.frame)
      titleTextNode.frame = FrameCalculator.frameForTitleText(containerBounds: containerNode.bounds, featureImageFrame: featureImageNode.frame)
      descriptionTextNode.frame = FrameCalculator.frameForDescriptionText(containerBounds: containerNode.bounds, featureImageFrame: featureImageNode.frame)
      
      
      
      // 4: Fast return if operation cancelled
      if nodeConstructionOperation.cancelled {
        return
      }
      
      
      
      // 5: Get on main thread and add container node's layer to cell's content view
      dispatch_async(dispatch_get_main_queue()) {
        if nodeConstructionOperation.cancelled {
          return
        }
        if cell.nodeConstructionOperation !== nodeConstructionOperation {
          return
        }
        cell.containerNode = containerNode
        cell.backgroundBlurNode = backgroundImageNode
        cell.contentLayer = containerNode.layer
        cell.contentView.layer.addSublayer(cell.contentLayer)
        containerNode.layer.setNeedsDisplay()
      }
    }

    
    // TODO: Method doesn't say that this assignment happens.
    self.nodeConstructionOperation = nodeConstructionOperation
    return nodeConstructionOperation
  }

}
