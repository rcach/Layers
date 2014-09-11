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
  var descriptionTextView: UITextView!
  var featureImageView: UIImageView!
  var backgroundImageView: UIImageView!
  var backgroundGradientLayer: CAGradientLayer!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    titleLabel = UILabel(frame: CGRectZero)
    descriptionTextView = UITextView()
    featureImageView = UIImageView()
    
    backgroundImageView = UIImageView()
    
    constructViewHierarchy()
    
    // TODO: Add shadow
    titleLabel.textColor = UIColor.whiteColor()
    titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 30)
    titleLabel.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
    titleLabel.shadowOffset = CGSize(width: 0, height: 2)
    
    backgroundImageView.contentMode = .ScaleAspectFill
    
    featureImageView.contentMode = UIViewContentMode.ScaleAspectFit
    featureImageView.layer.shadowOffset = CGSizeMake(0, 2)
    featureImageView.layer.shadowOpacity = 0.5
    featureImageView.layer.shadowColor = UIColor.blackColor().CGColor
    featureImageView.layer.shadowRadius = 2
    
    
    // TODO: Add shadow
//    var shadow = NSShadow()
//    shadow.shadowColor = UIColor(white: 0.0, alpha: 0.8)
//    shadow.shadowOffset = CGSize(width: 1, height: 3)
//    shadow.shadowBlurRadius = 2.0
    
    descriptionTextView.font = UIFont(name: "AvenirNext-Medium", size: 16)
    descriptionTextView.textAlignment = .Justified
    descriptionTextView.textColor = UIColor.whiteColor()
    descriptionTextView.backgroundColor = UIColor.clearColor()
    descriptionTextView.scrollEnabled = false
    
//    descriptionTextView.textContainer.exclusionPaths = [UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 90, height: 90), byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 40, height: 40))]
    
    backgroundGradientLayer = CAGradientLayer()
    backgroundGradientLayer.backgroundColor = UIColor.clearColor().CGColor
    backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
    let arrayColors: [AnyObject] = [
      UIColor(white: 0, alpha: 0.6).CGColor,
      UIColor(white: 0, alpha: 0)
    ]
    backgroundGradientLayer.colors = arrayColors
  }
  
  func constructViewHierarchy() {
    contentView.addSubview(backgroundImageView)
    contentView.addSubview(featureImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionTextView)
  }
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    if let featureImageViewFrame = featureImageViewFrameWithWidth(size.width) {
      let descriptionTextViewFrame = descriptionTextViewFrameWithWidth(size.width, featureImageViewFrame: featureImageViewFrame)
      return CGSize(width: size.width, height: descriptionTextViewFrame.maxY + 20.0)
    }
    return CGSize(width: size.width, height: 10.0)
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    backgroundImageView.frame = bounds
    
    if let featureImageViewFrame = featureImageViewFrameWithWidth(self.bounds.width) {
      featureImageView.frame = featureImageViewFrame
      featureImageView.layer.shadowPath = UIBezierPath(rect: featureImageView.bounds).CGPath
    } else {
      featureImageView.frame = CGRectZero
      featureImageView.layer.shadowPath = UIBezierPath(rect: CGRectZero).CGPath
    }
    
    backgroundGradientLayer.frame = featureImageView.bounds
    contentView.layer.insertSublayer(backgroundGradientLayer, above: featureImageView.layer)
    
    titleLabel.frame = CGRectInset(CGRectMake(0, featureImageView.frame.maxY - 70.0, self.bounds.width, 70), 20, 20)
    
    descriptionTextView.frame = descriptionTextViewFrameWithWidth(self.bounds.width, featureImageViewFrame: featureImageView.frame)
  }
  
  
  func featureImageViewFrameWithWidth(width: CGFloat) -> CGRect? {
    // TODO: Handle 1.0 scale.
    if let image = featureImageView.image {
      let height = (image.size.height / image.size.width) * width
      return CGRectMake(0, 0, width, height)
    }
    return nil
  }
  
  func descriptionTextViewFrameWithWidth(width: CGFloat, featureImageViewFrame: CGRect) -> CGRect {
    let margin: CGFloat = 20.0
    let insetWidth: CGFloat = width - margin
    let textViewHeight = descriptionTextView.sizeThatFits(CGSize(width: insetWidth, height: CGFloat(FLT_MAX)))
    return CGRectMake(margin/2.0, featureImageViewFrame.height + margin, insetWidth, textViewHeight.height)
  }
}
