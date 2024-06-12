//
//  AnimationConfiguration.swift
//  
//
//  Created by Kyaw Zay Ya Lin Tun on 12/06/2024.
//

import SwiftUI

public struct AnimationConfiguration {
  let animation: Animation
  var delay: TimeInterval = 0
  
  var value: Animation {
    animation.delay(delay)
  }
  
  public init(animation: Animation, delay: TimeInterval = 0) {
    self.animation = animation
    self.delay = delay
  }
}
