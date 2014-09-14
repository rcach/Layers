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
  let textAreaHeight: CGFloat = 300.0
  
  var backgroundImageNode: ASImageNode!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    titleLabel = UILabel(frame: CGRectZero)
    descriptionTextView = UITextView()
    featureImageView = UIImageView()
   
    backgroundImageView = UIImageView()
    backgroundImageNode = ASImageNode()
    backgroundImageNode.imageModificationBlock = { input in return input.applyLightEffect() }
    
    constructViewHierarchy()
    
    backgroundImageView.contentMode = .ScaleAspectFill
    
    featureImageView.contentMode = UIViewContentMode.ScaleAspectFit
    featureImageView.layer.shadowOffset = CGSizeMake(0, 2)
    featureImageView.layer.shadowOpacity = 0.5
    featureImageView.layer.shadowColor = UIColor.blackColor().CGColor
    featureImageView.layer.shadowRadius = 2
    
    descriptionTextView.textAlignment = .Justified
    descriptionTextView.backgroundColor = UIColor.clearColor()
    descriptionTextView.scrollEnabled = false
    
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
//    contentView.addSubview(backgroundImageView)
    contentView.addSubview(backgroundImageNode.view)
    contentView.addSubview(featureImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionTextView)
  }
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    if let featureImageViewFrame = featureImageViewFrameWithWidth(size.width) {
      return CGSize(width: size.width, height: featureImageViewFrame.maxY + textAreaHeight)
    }
    return CGSize(width: size.width, height: 10.0)
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    backgroundImageView.frame = bounds
    backgroundImageNode.frame = bounds
    
    if let featureImageViewFrame = featureImageViewFrameWithWidth(self.bounds.width) {
      featureImageView.frame = featureImageViewFrame
      featureImageView.layer.shadowPath = UIBezierPath(rect: featureImageView.bounds).CGPath
    } else {
      featureImageView.frame = CGRectZero
      featureImageView.layer.shadowPath = UIBezierPath(rect: CGRectZero).CGPath
    }
    
    backgroundGradientLayer.frame = featureImageView.bounds
    contentView.layer.insertSublayer(backgroundGradientLayer, above: featureImageView.layer)
    
    titleLabel.frame = CGRectInset(CGRectMake(0, featureImageView.frame.maxY - 80.0, self.bounds.width, 80), 20, 20)
    
    descriptionTextView.frame = CGRectMake(10.0, featureImageView.frame.maxY + 20.0, self.bounds.width - 20.0, textAreaHeight)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    // TODO: Cancel expensive operations.
    backgroundImageNode.hidden = true
  }
  
  
  func featureImageViewFrameWithWidth(width: CGFloat) -> CGRect? {
    // TODO: Handle 1.0 scale.
    if let image = featureImageView.image {
      let height = (image.size.height / image.size.width) * width
      return CGRectMake(0, 0, width, height)
    }
    return nil
  }
  
  func updateTitle(title: String, andDescription description: NSString) {
    var titleTextShadow = NSShadow()
    titleTextShadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
    titleTextShadow.shadowOffset = CGSize(width: 0, height: 2)
    titleTextShadow.shadowBlurRadius = 3.0
    
    
    var descriptionTextShadow = NSShadow()
    descriptionTextShadow.shadowColor = UIColor(white: 0.0, alpha: 0.3)
    descriptionTextShadow.shadowOffset = CGSize(width: 0, height: 1)
    descriptionTextShadow.shadowBlurRadius = 3.0
    
    
    let titleAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Heavy", size: 30), NSForegroundColorAttributeName: UIColor.whiteColor(), NSShadowAttributeName: titleTextShadow]
    titleLabel.attributedText = NSAttributedString(string: title, attributes: titleAttributes)
    
    let descriptionAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 16), NSShadowAttributeName: descriptionTextShadow, NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor()]
    descriptionTextView.attributedText = NSAttributedString(string: description, attributes: descriptionAttributes)
  }
  
}
