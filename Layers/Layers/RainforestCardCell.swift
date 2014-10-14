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
  var backgroundBlurNode: ASImageNode?
  var contentLayer: CALayer?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.layer.borderColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 0.2).CGColor
    contentView.layer.borderWidth = 1
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
  }
  
  //MARK: Cell Reuse
  override func prepareForReuse() {
    super.prepareForReuse()
    
    backgroundBlurNode?.preventOrCancelDisplay = true
    contentLayer?.removeFromSuperlayer()
    contentLayer = nil
    backgroundBlurNode = nil
  }
  
  //MARK: Subviews
  func configureCellDisplayWithCardInfo(cardInfo: RainforestCardInfo) {
    let image = UIImage(named: cardInfo.imageName)
    featureImageSizeOptional = image.size
    
    // Build all subnodes
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
        
        if let blurredImage = input.applyBlurWithRadius(30, tintColor: tintColor,
                                                        saturationDeltaFactor: 1.8, maskImage: nil,
                                                        didCancel:didCancelBlur) {
          return blurredImage
        } else {
          return image
        }
      }
    
    // Layout nodes
    backgroundImageNode.frame = FrameCalculator.frameForContainer(featureImageSize: image.size)
    
    // Add node layer to content view and finish up configuring cell
    contentView.layer.addSublayer(backgroundImageNode.layer)
    backgroundBlurNode = backgroundImageNode
    contentLayer = backgroundImageNode.layer
    
    // Tell the node to display, this will occure asynchronously potentially across many main thread run loops
    backgroundImageNode.setNeedsDisplay()
    
  }
  
}
