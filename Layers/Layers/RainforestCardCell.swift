//
//  RainforestCardCell.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class RainforestCardCell: UICollectionViewCell {
  let featureImageView = UIImageView()
  let backgroundImageView = UIImageView()
  let titleLabel = UILabel()
  let descriptionTextView = UITextView()
  let gradientView = LAGradientView()
  var featureImageSizeOptional: CGSize?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.addSubview(backgroundImageView)
    contentView.addSubview(featureImageView)
    contentView.addSubview(gradientView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionTextView)
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
    
    let featureImageSize = featureImageSizeOptional ?? CGSizeZero
    
    backgroundImageView.frame = FrameCalculator.frameForBackgroundImage(containerBounds: bounds)
    featureImageView.frame = FrameCalculator.frameForFeatureImage(featureImageSize: featureImageSize,
      containerFrameWidth: frame.size.width)
    gradientView.frame = FrameCalculator.frameForGradient(featureImageFrame: featureImageView.frame)
    titleLabel.frame = FrameCalculator.frameForTitleText(containerBounds: bounds,
      featureImageFrame: featureImageView.frame)
    descriptionTextView.frame = FrameCalculator.frameForDescriptionText(containerBounds: bounds,
      featureImageFrame: featureImageView.frame)
  }
  
  //MARK: Cell Reuse
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  //MARK: Subviews
  func configureCellDisplayWithCardInfo(cardInfo: RainforestCardInfo) {
    let image = UIImage(named: cardInfo.imageName)
    featureImageSizeOptional = image.size
    
    featureImageView.contentMode = .ScaleAspectFit
    featureImageView.image = image
    
    backgroundImageView.contentMode = .ScaleAspectFill
    backgroundImageView.image = image.applyBlurWithRadius(30, tintColor: UIColor(white: 0.5, alpha: 0.3),
      saturationDeltaFactor: 1.8, maskImage: nil)
    
    descriptionTextView.backgroundColor = UIColor.clearColor()
    descriptionTextView.editable = false
    descriptionTextView.scrollEnabled = false
    descriptionTextView.attributedText = NSAttributedString.attributedStringForDescriptionText(cardInfo.description)
    
    titleLabel.backgroundColor = UIColor.clearColor()
    titleLabel.attributedText = NSAttributedString.attributesStringForTitleText(cardInfo.name)
    
    gradientView.setNeedsDisplay()
  }
  
}
