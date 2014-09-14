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
                            
  override func viewDidLoad() {
    super.viewDidLoad()
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
      cell.updateTitle("Harpy Eagle", andDescription: "The harpy eagle (Harpia harpyja) is a Neotropical species of eagle. It is sometimes known as the American harpy eagle to distinguish it from the Papuan eagle which is sometimes known as the New Guinea harpy eagle or Papuan harpy eagle.[3] It is the largest and most powerful raptor found in the Americas,[4] and among the largest extant species of eagles in the world.")
      cell.featureImageView.image = UIImage(named: "a01")
      cell.backgroundImageNode.image = UIImage(named: "a01")

    } else if indexPath.item == 1 {
      cell.updateTitle("Chameleon", andDescription: "Chameleons or chamaeleons (family Chamaeleonidae) are a distinctive and highly specialized clade of lizards. The approximately 160 species of chameleon come in a range of colors, and many species have the ability to change colors. Chameleons are distinguished by their zygodactylous feet; their very long, highly modified, rapidly extrudable tongues;")
      cell.featureImageView.image = UIImage(named: "a02")
      cell.backgroundImageNode.image = UIImage(named: "a02")
    } else if indexPath.item < 10 {
      cell.updateTitle("Blue Morpho", andDescription: "The Menelaus Blue Morpho (Morpho menelaus) is an iridescent tropical butterfly of Central and South America. It has a wing span of 15 cm (5.9 in). The adult drinks juice from rotten fruit with its long proboscis, which is like a sucking tube. The adult males have brighter colours than the females.")
      cell.featureImageView.image = UIImage(named: "a0\(indexPath.item)")
      cell.backgroundImageNode.image = UIImage(named: "a0\(indexPath.item)")
    } else {
      cell.updateTitle("Chameleon", andDescription: "The Menelaus Blue Morpho (Morpho menelaus) is an iridescent tropical butterfly of Central and South America. It has a wing span of 15 cm (5.9 in). The adult drinks juice from rotten fruit with its long proboscis, which is like a sucking tube. The adult males have brighter colours than the females.")
      cell.featureImageView.image = UIImage(named: "a\(indexPath.item)")
      cell.backgroundImageNode.image = UIImage(named: "a\(indexPath.item)")
    }
    
    cell.backgroundImageNode.hidden = true
    cell.backgroundImageNode.setNeedsDisplayWithCompletion { cancelled in
      if !cancelled {
        cell.backgroundImageNode.hidden = false
      }
    }
    cell.setNeedsLayout()
    return cell
  }
  
}

