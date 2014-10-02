//
//  RainforestCollectionViewLayout.swift
//  LayersCollectionViewPlayground
//
//  Created by René Cacheaux on 10/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation


public class RainforestCollectionViewLayout: UICollectionViewLayout {
  var allLayoutAttributes = [UICollectionViewLayoutAttributes]()
  let cellDefaultHeight = 10
  let cellWidth = 320
  // TODO: Turn this into a struct.
  let interCellHorizontalSpacing = 20
  let interCellVerticalSpacing = 10
  var contentMaxY: CGFloat = 0
  
  // TODO: Make a layout metrics protocol for this.
  class TwoColumnLayout {
    class func numberOfRowsForNumberOfItems(numberOfItems: Int) -> Int {
      var isOdd: Bool = numberOfItems%2 > 0
      var numberOfRows = numberOfItems/2
      
      if isOdd {
        numberOfRows++
      }
      
      return numberOfRows
    }
    
    // TODO: Return tupe with row and column
    class func rowForItemAtIndex(index: Int) -> Int {
      return ((index + 1)/2 + (index + 1)%2) - 1
    }
    
    class func columnForItemAtIndex(index: Int) -> Int {
      return index%2
    }
    
    class func indexForItemAboveItemAtIndex(index: Int) -> Int {
      var aboveItemIndex = index - 2
      return aboveItemIndex >= 0 ? aboveItemIndex : index
    }
  }
  
  override public func prepareLayout() {
    super.prepareLayout()
    if self.allLayoutAttributes.count == 0 {
      self.populateLayoutAttributes()
    }
  }
  
  func populateLayoutAttributes() {
    if self.collectionView == nil {
      return
    }
    let collectionView = self.collectionView!
    
    self.allLayoutAttributes.removeAll(keepCapacity: true)
    for i in 0 ..< collectionView.numberOfItemsInSection(0) {
      let la = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i, inSection: 0))
      let row = TwoColumnLayout.rowForItemAtIndex(i)
      let column = TwoColumnLayout.columnForItemAtIndex(i)
      let x = (column * self.cellWidth) + (self.interCellHorizontalSpacing * (column + 1))
      let y = (row * self.cellDefaultHeight) + (self.interCellVerticalSpacing * (row + 1))
      la.frame = CGRect(x: x, y: y, width: self.cellWidth, height: self.cellDefaultHeight)
      self.allLayoutAttributes.append(la)
    }
    if let lastLayoutAttributes = self.allLayoutAttributes.last {
      self.contentMaxY = lastLayoutAttributes.frame.maxY
    }
  }
  
  override public func collectionViewContentSize() -> CGSize {
    if self.collectionView == nil {
      return CGSizeZero
    }
    let collectionView = self.collectionView!
    
    let height = TwoColumnLayout.numberOfRowsForNumberOfItems(collectionView.numberOfItemsInSection(0)) * self.cellDefaultHeight
    return CGSize(width: 660, height: 9000)
  }
  
  override public func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for i in 0 ..< self.allLayoutAttributes.count {
      let la = self.allLayoutAttributes[i]
      if rect.contains(la.frame) {
        layoutAttributes.append(la)
      }
    }
    return self.allLayoutAttributes
  }
  
  override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
    if indexPath.item >= self.allLayoutAttributes.count { return nil }
    return self.allLayoutAttributes[indexPath.item]
  }
  
  override public func shouldInvalidateLayoutForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
    return true
  }
  
  override public func invalidationContextForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
    
    
    let indexForItemAbove = TwoColumnLayout.indexForItemAboveItemAtIndex(originalAttributes.indexPath.item)
    let layoutAttributesForItemAbove = self.allLayoutAttributes[indexForItemAbove]
    
    if originalAttributes.indexPath.item == 4 {
      println("Cell at i4, above la: \n \(layoutAttributesForItemAbove) \n\n ")
    }
    
    if originalAttributes.indexPath.item > 1 {
      preferredAttributes.frame.origin.y = layoutAttributesForItemAbove.frame.maxY + CGFloat(self.interCellVerticalSpacing)
    } else {
      preferredAttributes.frame.origin.y = 0
    }
    
    
    self.allLayoutAttributes[originalAttributes.indexPath.item] = preferredAttributes

    if originalAttributes.indexPath.item == 9 {
      println(self.allLayoutAttributes)
    }
    
    
    let ic = super.invalidationContextForPreferredLayoutAttributes(preferredAttributes, withOriginalAttributes: originalAttributes)
    ic.invalidateItemsAtIndexPaths([originalAttributes.indexPath])
    
//    if preferredAttributes.frame.maxY > self.contentMaxY {
//     ic.contentSizeAdjustment = CGSize(width: 0, height: preferredAttributes.frame.maxY - self.contentMaxY)
//      self.contentMaxY = preferredAttributes.frame.maxY
//    }
    
    return ic
  }
  
  
  
}
