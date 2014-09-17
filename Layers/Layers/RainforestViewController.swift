//
//  ViewController.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

// TODO: Lay out top row according to top layout guide.
class RainforestViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  let nodeConstructionQueue = NSOperationQueue()
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    nodeConstructionQueue.maxConcurrentOperationCount = 1
    let flowLayout = collectionView?.collectionViewLayout as UICollectionViewFlowLayout
    flowLayout.estimatedItemSize = CGSize(width: 320.0, height: 600.0)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 32
  }
  
  // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as RainforestInfoCardCell
    
    if indexPath.item == 0 {
      cell.featureImageOptional = UIImage(named: "a01")
    } else if indexPath.item == 1 {
      cell.featureImageOptional = UIImage(named: "a02")
    } else if indexPath.item < 10 {
      cell.featureImageOptional = UIImage(named: "a0\(indexPath.item)")
    } else {
      cell.featureImageOptional = UIImage(named: "a\(indexPath.item)")
    }
    
    if let oldNodeConstructionOperation = cell.nodeConstructionOperation {
      oldNodeConstructionOperation.cancel()
    }
    
    let nodeConstructionOperation = NSBlockOperation()
    cell.nodeConstructionOperation = nodeConstructionOperation
    nodeConstructionOperation.addExecutionBlock {
      [unowned nodeConstructionOperation, unowned cell] in
      if nodeConstructionOperation.cancelled { return }

      
      let contentNode = ASDisplayNode(layerClass: LAAnimatedDisplayLayer.self)
      contentNode.layerBacked = true
      contentNode.shouldRasterizeDescendants = true
      
      let backgroundImageNode = ASImageNode()
      backgroundImageNode.layerBacked = true
      
      backgroundImageNode.imageModificationBlock = { [nodeConstructionOperation] input in
        let tintColor = UIColor(white: 0.5, alpha: 0.3)
        return input.applyBlurWithRadius(30, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil, node:backgroundImageNode)
      }
      backgroundImageNode.contentMode = .ScaleAspectFill
      
      let featureImageNode = ASImageNode()
      featureImageNode.layerBacked = true
      featureImageNode.contentMode = UIViewContentMode.ScaleAspectFit
      
      let descriptionTextNode = ASTextNode()
      descriptionTextNode.layerBacked = true
      descriptionTextNode.backgroundColor = UIColor.clearColor()
      
      if nodeConstructionOperation.cancelled { return }
      
      var title: String
      var description: String
      
      if indexPath.item == 0 {
        title = "Harpy Eagle"
        description = "The harpy eagle (Harpia harpyja) is a Neotropical species of eagle. It is sometimes known as the American harpy eagle to distinguish it from the Papuan eagle which is sometimes known as the New Guinea harpy eagle or Papuan harpy eagle.[3] It is the largest and most powerful raptor found in the Americas,[4] and among the largest extant species of eagles in the world."
        featureImageNode.image = UIImage(named: "a01")
        backgroundImageNode.image = UIImage(named: "a01")
        
      } else if indexPath.item == 1 {
        title = "Chameleon"
        description = "Chameleons or chamaeleons (family Chamaeleonidae) are a distinctive and highly specialized clade of lizards. The approximately 160 species of chameleon come in a range of colors, and many species have the ability to change colors. Chameleons are distinguished by their zygodactylous feet; their very long, highly modified, rapidly extrudable tongues;"
        featureImageNode.image = UIImage(named: "a02")
        backgroundImageNode.image = UIImage(named: "a02")
      } else if indexPath.item < 10 {
        title = "Blue Morpho"
        description = "The Menelaus Blue Morpho (Morpho menelaus) is an iridescent tropical butterfly of Central and South America. It has a wing span of 15 cm (5.9 in). The adult drinks juice from rotten fruit with its long proboscis, which is like a sucking tube. The adult males have brighter colours than the females."
        featureImageNode.image = UIImage(named: "a0\(indexPath.item)")
        backgroundImageNode.image = UIImage(named: "a0\(indexPath.item)")
      } else {
        title = "Chameleon"
        description = "The Menelaus Blue Morpho (Morpho menelaus) is an iridescent tropical butterfly of Central and South America. It has a wing span of 15 cm (5.9 in). The adult drinks juice from rotten fruit with its long proboscis, which is like a sucking tube. The adult males have brighter colours than the females."
        featureImageNode.image = UIImage(named: "a\(indexPath.item)")
        backgroundImageNode.image = UIImage(named: "a\(indexPath.item)")
      }
      
      var paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .Justified
      
      var titleTextShadow = NSShadow()
      titleTextShadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
      titleTextShadow.shadowOffset = CGSize(width: 0, height: 2)
      titleTextShadow.shadowBlurRadius = 3.0
      
      
      var descriptionTextShadow = NSShadow()
      descriptionTextShadow.shadowColor = UIColor(white: 0.0, alpha: 0.3)
      descriptionTextShadow.shadowOffset = CGSize(width: 0, height: 1)
      descriptionTextShadow.shadowBlurRadius = 3.0
      
      
//      let titleAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Heavy", size: 30), NSForegroundColorAttributeName: UIColor.whiteColor(), NSShadowAttributeName: titleTextShadow, NSParagraphStyleAttributeName: paragraphStyle]
//      titleLabel.attributedText = NSAttributedString(string: title, attributes: titleAttributes)
      
      let descriptionAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 16), NSShadowAttributeName: descriptionTextShadow, NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSParagraphStyleAttributeName: paragraphStyle]
      descriptionTextNode.attributedString = NSAttributedString(string: description, attributes: descriptionAttributes)

      
      
      if nodeConstructionOperation.cancelled { return }
      
      
      // Layout
      //TODO Maybe move this UIKit call onto main thread before this block.
      let width: CGFloat = 320.0
      let size = cell.sizeThatFits(CGSizeMake(width, CGFloat.max))
      contentNode.frame = CGRect(x: 0.0, y: 0.0, width: width, height: size.height)
      backgroundImageNode.frame = contentNode.bounds
      
      
      
      var featureImageViewFrameWithWidth: CGRect?
      if let image = featureImageNode.image {
        let height = (image.size.height / image.size.width) * width
        featureImageViewFrameWithWidth = CGRectMake(0, 0, width, height)
      }
      
      if let featureImageViewFrame = cell.featureImageViewFrameWithWidth(contentNode.bounds.width) {
        featureImageNode.frame = featureImageViewFrame
        //      featureImageNode.layer.shadowPath = UIBezierPath(rect: featureImageNode.bounds).CGPath
      } else {
        featureImageNode.frame = CGRectZero
        //      featureImageNode.layer.shadowPath = UIBezierPath(rect: CGRectZero).CGPath
      }
      descriptionTextNode.frame = CGRectMake(24.0, featureImageNode.frame.maxY + 20.0, contentNode.bounds.width - 48.0, cell.textAreaHeight)
      
      
      contentNode.addSubnode(backgroundImageNode)
      contentNode.addSubnode(featureImageNode)
      contentNode.addSubnode(descriptionTextNode)
      
      
      if nodeConstructionOperation.cancelled { return }

      
      dispatch_async(dispatch_get_main_queue()) {
        cell.contentNode = contentNode
        cell.backgroundBlurNode = backgroundImageNode
        cell.contentView.layer.addSublayer(contentNode.layer)
        contentNode.layer.setNeedsDisplay()
      }

    }
    nodeConstructionQueue.addOperation(nodeConstructionOperation)
    
    
    return cell
  }
  
}

