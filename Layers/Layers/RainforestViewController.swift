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
  let rainforestCardsInfo = getAllCardInfo()
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundView = UIImageView(image: UIImage(named: "background"))
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return rainforestCardsInfo.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as RainforestCardCell
    let cardInfo = rainforestCardsInfo[indexPath.item]
    cell.configureCellForDisplay(cardInfo: cardInfo, nodeConstructionQueue: nodeConstructionQueue)
    return cell
  }
}

