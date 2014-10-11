//
//  ViewController.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit


class RainforestViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  let nodeConstructionQueue = NSOperationQueue()
  let lifeforms = allLifeforms()
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    nodeConstructionQueue.maxConcurrentOperationCount = 1
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lifeforms.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as RainforestCardCell
    
    let lifeform = lifeforms[indexPath.item]
    
    cell.removeAllContentViewSublayers()
    let image = UIImage(named: lifeform.imageName)
    cell.featureImageSizeOptional = image.size
    if let oldNodeConstructionOperation = cell.nodeConstructionOperation {
      oldNodeConstructionOperation.cancel()
    }
    
    nodeConstructionQueue.addOperation(cell.nodeConstructionOperationWithLifeform(lifeform, image: image))
    return cell
  }
  
}

