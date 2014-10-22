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
  var placeholderLayer: CALayer!
  var backgroundImageNode: ASImageNode?
  var contentLayer: CALayer?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    placeholderLayer = CALayer()
    placeholderLayer.contents = UIImage(named: "cardPlaceholder")!.CGImage
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
    
    backgroundImageNode?.preventOrCancelDisplay = true
    contentLayer?.removeFromSuperlayer()
    contentLayer = nil
    backgroundImageNode = nil
  }
  
  //MARK: Cell Content
  func configureCellDisplayWithCardInfo(cardInfo: RainforestCardInfo) {
    //MARK: Image Size Section
    let image = UIImage(named: cardInfo.imageName)!
    featureImageSizeOptional = image.size
    
    //MARK: Node Creation Section
    let backgroundImageNode = ASImageNode()
    backgroundImageNode.image = image
    backgroundImageNode.contentMode = .ScaleAspectFill
    backgroundImageNode.layerBacked = true
    backgroundImageNode.imageModificationBlock = { input in
      if input == nil {
        return input
      }
      if let blurredImage = input.applyBlurWithRadius(30, tintColor: UIColor(white: 0.5, alpha: 0.3),
        saturationDeltaFactor: 1.8, maskImage: nil, didCancel:{ return false }) {
          return blurredImage
      } else {
        return image
      }
    }
    
    //MARK: Node Layout Section
    backgroundImageNode.frame = FrameCalculator.frameForContainer(featureImageSize: image.size)
    
    //MARK: Node Layer and Wrap Up Section
    self.contentView.layer.addSublayer(backgroundImageNode.layer)
    backgroundImageNode.setNeedsDisplay()
    self.backgroundImageNode = backgroundImageNode
    self.contentLayer = backgroundImageNode.layer
  }
  
}
