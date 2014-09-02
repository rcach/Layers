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
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as RainforestInfoCardCell
    
    if indexPath.item == 0 {
      cell.descriptionTextView.text = "The harpy eagle (Harpia harpyja) is a Neotropical species of eagle. It is sometimes known as the American harpy eagle to distinguish it from the Papuan eagle which is sometimes known as the New Guinea harpy eagle or Papuan harpy eagle.[3] It is the largest and most powerful raptor found in the Americas,[4] and among the largest extant species of eagles in the world. "
      cell.featureImageView.image = UIImage(named: "harp")
      cell.backgroundImageView.image = UIImage(named: "harp").applyLightEffect()
      cell.titleLabel.text = "Harpy Eagle"
    } else if indexPath.item == 1 {
      cell.descriptionTextView.text = "Chameleons or chamaeleons (family Chamaeleonidae) are a distinctive and highly specialized clade of lizards. The approximately 160 species of chameleon come in a range of colors, and many species have the ability to change colors. Chameleons are distinguished by their zygodactylous feet; their very long, highly modified, rapidly extrudable tongues;"
      cell.featureImageView.image = UIImage(named: "animal")
      cell.backgroundImageView.image = UIImage(named: "animal").applyLightEffect()
      cell.titleLabel.text = "Chameleon"
    } else {
      cell.descriptionTextView.text = "The Menelaus Blue Morpho (Morpho menelaus) is an iridescent tropical butterfly of Central and South America. It has a wing span of 15 cm (5.9 in). The adult drinks juice from rotten fruit with its long proboscis, which is like a sucking tube. The adult males have brighter colours than the females."
      cell.featureImageView.image = UIImage(named: "blue")
      cell.backgroundImageView.image = UIImage(named: "blue").applyLightEffect()
      cell.titleLabel.text = "Blue Morpho"
    }
    
    return cell
  }
  
}

