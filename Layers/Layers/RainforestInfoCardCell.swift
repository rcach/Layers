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
    descriptionTextView.font = UIFont(name: "AvenirNext-Medium", size: 16)
    descriptionTextView.textAlignment = .Justified
    descriptionTextView.textColor = UIColor.whiteColor()
    descriptionTextView.backgroundColor = UIColor.clearColor()
    
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
    return CGSize(width: 320, height: 500)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    backgroundImageView.frame = bounds
    
    
    // TODO: Handle scale.
    let height = (featureImageView.image.size.height / featureImageView.image.size.width) * 320.0
    featureImageView.frame = CGRectMake(0, 0, 320.0, height)
    featureImageView.layer.shadowPath = UIBezierPath(rect: featureImageView.bounds).CGPath
    
    backgroundGradientLayer.frame = featureImageView.bounds
    contentView.layer.insertSublayer(backgroundGradientLayer, above: featureImageView.layer)
    
    
    
    titleLabel.frame = CGRectInset(CGRectMake(0, featureImageView.frame.size.height - 70.0, 320, 70), 20, 20)
    
    let textViewHeight = descriptionTextView.sizeThatFits(CGSize(width: 300, height: DBL_MAX))
    descriptionTextView.frame = CGRectMake(10, featureImageView.frame.height + 20.0, 300, textViewHeight.height)
    
  }
  
  
  
}
