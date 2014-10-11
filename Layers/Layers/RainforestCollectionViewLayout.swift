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
  
  // TODO: Return tuple with row and column
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
  
  // TODO: Return tuple with row and column
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


// TODO: Remove public from everywhere in this file
public class RainforestCollectionViewLayout: UICollectionViewLayout {
  var allLayoutAttributes = [UICollectionViewLayoutAttributes]()
  let cellDefaultHeight = 10
  let cellWidth = 320
  // TODO: Turn this into a struct.
//  let interCellHorizontalSpacing = 20
  let interCellVerticalSpacing = 10
  var contentMaxY: CGFloat = 0
  let layoutType: RainforestLayoutType
  let layoutMetrics: RainforestLayoutMetrics
  
   init(type: RainforestLayoutType) {
    self.layoutType = type
    self.layoutMetrics = type.metrics()
    super.init()
  }
  
  override init() {
    self.layoutType = .TwoColumn
    self.layoutMetrics = self.layoutType.metrics()
    super.init()
  }
  
  required public init(coder aDecoder: NSCoder) {
    self.layoutType = .TwoColumn
    self.layoutMetrics = self.layoutType.metrics()
    super.init(coder: aDecoder)
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
      let row = self.layoutMetrics.rowForItemAtIndex(i)
      let column = self.layoutMetrics.columnForItemAtIndex(i)
      let x = (column * self.cellWidth) + (self.layoutMetrics.interCellHorizontalSpacing() * (column + 1))
      let y = (row * self.cellDefaultHeight) + (self.interCellVerticalSpacing * (row + 1))
      la.frame = CGRect(x: x, y: y, width: self.cellWidth, height: self.cellDefaultHeight)
      self.allLayoutAttributes.append(la)
      if la.frame.maxY > self.contentMaxY {
        self.contentMaxY = ceil(la.frame.maxY)
      }
    }
  }
  
  override public func collectionViewContentSize() -> CGSize {
    if self.collectionView == nil {
      return CGSizeZero
    }
    let collectionView = self.collectionView!
    
//    println("\n\n CALCULATED CONTENT SIZE: \(CGSize(width: 660, height: height)) \n\n ")
    let contentWidth = self.layoutMetrics.contentWidth(self.cellWidth, horizontalSpacing: self.layoutMetrics.interCellHorizontalSpacing())
    return CGSize(width: contentWidth, height: Int(self.contentMaxY))
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
    
    let indexForItemAbove = self.layoutMetrics.indexForItemAboveItemAtIndex(originalAttributes.indexPath.item)
    let layoutAttributesForItemAbove = self.allLayoutAttributes[indexForItemAbove]
    
//    if originalAttributes.indexPath.item == 4 {
//      println("Cell at i4, above la: \n \(layoutAttributesForItemAbove) \n\n ")
//    }
    
    if originalAttributes.indexPath.item != indexForItemAbove {
      preferredAttributes.frame.origin.y = layoutAttributesForItemAbove.frame.maxY + CGFloat(self.interCellVerticalSpacing)
    } else {
      preferredAttributes.frame.origin.y = 0
    }
    
    self.allLayoutAttributes[originalAttributes.indexPath.item] = preferredAttributes

    if originalAttributes.indexPath.item == 9 {
//      println(self.allLayoutAttributes)
//      println("\n\n ACTUAL CONTENT SIZE: \(self.collectionView?.contentSize) \n\n ")
    }
    
    let ic = super.invalidationContextForPreferredLayoutAttributes(preferredAttributes, withOriginalAttributes: originalAttributes)
    ic.invalidateItemsAtIndexPaths([originalAttributes.indexPath])
    
    if preferredAttributes.frame.maxY > self.contentMaxY {
     ic.contentSizeAdjustment = CGSize(width: 1, height: preferredAttributes.frame.maxY - self.contentMaxY)
      self.contentMaxY = ceil(preferredAttributes.frame.maxY)
      ic.contentOffsetAdjustment = CGPoint(x: 0, y: 1)
    }
    
    return ic
  }
  
}
