//
//  RainforestCollectionViewLayout.swift
//  LayersCollectionViewPlayground
//
//  Created by René Cacheaux on 10/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation


protocol RainforestLayoutMetrics {
  func numberOfRowsForNumberOfItems(numberOfItems: Int) -> Int
  func rowForItemAtIndex(index: Int) -> Int
  func columnForItemAtIndex(index: Int) -> Int
  func indexForItemAboveItemAtIndex(index: Int) -> Int
  func contentWidth(cellWidth: Int, horizontalSpacing: Int) -> Int
  func interCellHorizontalSpacing() -> Int
}

class TwoColumnLayoutMetrics: RainforestLayoutMetrics {
  func numberOfRowsForNumberOfItems(numberOfItems: Int) -> Int {
    var isOdd: Bool = numberOfItems%2 > 0
    var numberOfRows = numberOfItems/2
    
    if isOdd {
      numberOfRows++
    }
    
    return numberOfRows
  }
  
  func rowForItemAtIndex(index: Int) -> Int {
    return ((index + 1)/2 + (index + 1)%2) - 1
  }
  
  func columnForItemAtIndex(index: Int) -> Int {
    return index%2
  }
  
  func indexForItemAboveItemAtIndex(index: Int) -> Int {
    var aboveItemIndex = index - 2
    return aboveItemIndex >= 0 ? aboveItemIndex : index
  }
  
  func contentWidth(cellWidth: Int, horizontalSpacing: Int) -> Int {
    return horizontalSpacing + cellWidth + horizontalSpacing + cellWidth + horizontalSpacing
  }
  
  func interCellHorizontalSpacing() -> Int {
    return 20
  }
}


class OneColumnLayoutMetrics: RainforestLayoutMetrics {
  func numberOfRowsForNumberOfItems(numberOfItems: Int) -> Int {
    return numberOfItems
  }
  
  func rowForItemAtIndex(index: Int) -> Int {
    return index
  }
  
  func columnForItemAtIndex(index: Int) -> Int {
    return 0
  }
  
  func indexForItemAboveItemAtIndex(index: Int) -> Int {
    var aboveItemIndex = index - 1
    return aboveItemIndex >= 0 ? aboveItemIndex : index
  }
  
  func contentWidth(cellWidth: Int, horizontalSpacing: Int) -> Int {
    return horizontalSpacing + cellWidth + horizontalSpacing
  }
  
  func interCellHorizontalSpacing() -> Int {
    return 0
  }
}

enum RainforestLayoutType {
  case OneColumn
  case TwoColumn
  
  func metrics() -> RainforestLayoutMetrics {
    switch self {
    case OneColumn:
      return OneColumnLayoutMetrics()
    case TwoColumn:
      return TwoColumnLayoutMetrics()
    }
  }
}

class RainforestCollectionViewLayout: UICollectionViewLayout {
  var allLayoutAttributes = [UICollectionViewLayoutAttributes]()
  let cellDefaultHeight = 10
  let cellWidth = Int(FrameCalculator.cardWidth)
  let interCellVerticalSpacing = 10
  var contentMaxY: CGFloat = 0
  let layoutType: RainforestLayoutType
  let layoutMetrics: RainforestLayoutMetrics
  
   init(type: RainforestLayoutType) {
    layoutType = type
    layoutMetrics = type.metrics()
    super.init()
  }
  
  override init() {
    layoutType = .TwoColumn
    layoutMetrics = layoutType.metrics()
    super.init()
  }
  
  required init(coder aDecoder: NSCoder) {
    layoutType = .TwoColumn
    layoutMetrics = layoutType.metrics()
    super.init(coder: aDecoder)
  }
  
  override func prepareLayout() {
    super.prepareLayout()
    if allLayoutAttributes.count == 0 {
      populateLayoutAttributes()
    }
  }
  
  func populateLayoutAttributes() {
    if self.collectionView == nil {
      return
    }
    let collectionView = self.collectionView!
    
    allLayoutAttributes.removeAll(keepCapacity: true)
    for i in 0 ..< collectionView.numberOfItemsInSection(0) {
      let la = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i, inSection: 0))
      let row = layoutMetrics.rowForItemAtIndex(i)
      let column = layoutMetrics.columnForItemAtIndex(i)
      let x = (column * cellWidth) + (layoutMetrics.interCellHorizontalSpacing() * (column + 1))
      let y = (row * cellDefaultHeight) + (interCellVerticalSpacing * (row + 1))
      la.frame = CGRect(x: x, y: y, width: cellWidth, height: cellDefaultHeight)
      allLayoutAttributes.append(la)
      if la.frame.maxY > contentMaxY {
        contentMaxY = ceil(la.frame.maxY)
      }
    }
  }
  
  override func collectionViewContentSize() -> CGSize {
    if self.collectionView == nil {
      return CGSizeZero
    }
    let collectionView = self.collectionView!
    
    let contentWidth = layoutMetrics.contentWidth(cellWidth, horizontalSpacing: layoutMetrics.interCellHorizontalSpacing())
    return CGSize(width: contentWidth, height: Int(contentMaxY))
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for i in 0 ..< allLayoutAttributes.count {
      let la = allLayoutAttributes[i]
      if rect.contains(la.frame) {
        layoutAttributes.append(la)
      }
    }
    return allLayoutAttributes
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
    if indexPath.item >= allLayoutAttributes.count { return nil }
    return allLayoutAttributes[indexPath.item]
  }
  
  override func shouldInvalidateLayoutForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
    return true
  }
  
  override func invalidationContextForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
    
    let indexForItemAbove = layoutMetrics.indexForItemAboveItemAtIndex(originalAttributes.indexPath.item)
    let layoutAttributesForItemAbove = allLayoutAttributes[indexForItemAbove]
    
    if originalAttributes.indexPath.item != indexForItemAbove {
      preferredAttributes.frame.origin.y = layoutAttributesForItemAbove.frame.maxY + CGFloat(interCellVerticalSpacing)
    } else {
      preferredAttributes.frame.origin.y = 0
    }
    
    allLayoutAttributes[originalAttributes.indexPath.item] = preferredAttributes
    
    let invalidationContext = super.invalidationContextForPreferredLayoutAttributes(preferredAttributes, withOriginalAttributes: originalAttributes)
    invalidationContext.invalidateItemsAtIndexPaths([originalAttributes.indexPath])
    
    if preferredAttributes.frame.maxY > contentMaxY {
     invalidationContext.contentSizeAdjustment = CGSize(width: 1, height: preferredAttributes.frame.maxY - contentMaxY)
      contentMaxY = ceil(preferredAttributes.frame.maxY)
      invalidationContext.contentOffsetAdjustment = CGPoint(x: 0, y: 1)
    }
    
    return invalidationContext
  }
  
}
