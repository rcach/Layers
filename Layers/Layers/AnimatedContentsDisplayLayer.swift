//
//  AnimatedContentsDisplayLayer.swift
//  Layers
//
//  Created by René Cacheaux on 10/19/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class AnimatedContentsDisplayLayer: _ASDisplayLayer {
  
  override func actionForKey(event: String!) -> CAAction! {
    if let action = super.actionForKey(event) {
      return action
    }
    
    if event == "contents" && contents == nil {
      let transition = CATransition()
      transition.duration = 0.6
      transition.type = kCATransitionFade
      return transition
    }
    
    return nil
  }
  
}
