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
  let lifeforms = allLifeforms()
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    nodeConstructionQueue.maxConcurrentOperationCount = 1
//    let flowLayout = collectionView?.collectionViewLayout as UICollectionViewFlowLayout
//    flowLayout.estimatedItemSize = CGSize(width: 320.0, height: 600.0)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lifeforms.count
  }
  
  // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as RainforestInfoCardCell
    
    let lifeform = lifeforms[indexPath.item]
    
    cell.removeAllContentViewSublayers()
    cell.featureImageOptional = UIImage(named: lifeform.imageName)
    if let oldNodeConstructionOperation = cell.nodeConstructionOperation {
      oldNodeConstructionOperation.cancel()
    }
    
    nodeConstructionQueue.addOperation(cell.nodeConstructionOperationWithLifeform(lifeform))
    return cell
  }
  
}

