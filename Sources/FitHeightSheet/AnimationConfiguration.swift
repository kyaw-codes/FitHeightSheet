//
//  AnimationConfiguration.swift
//  
//
//  Created by Kyaw Zay Ya Lin Tun on 12/06/2024.
//

import SwiftUI

/// `AnimationConfiguration` is a struct that encapsulates an animation and its associated delay. This configuration can be used to create animations with specified delays, providing greater control over the timing of animations in your application.
public struct AnimationConfiguration {
  let animation: Animation
  var delay: TimeInterval = 0
  
  var value: Animation {
    animation.delay(delay)
  }
  
  /// Creates a new AnimationConfiguration instance.
  /// - Parameters:
  ///   - animation: The base SwiftUI `Animation` to be used.
  ///   - delay: The delay, in seconds, before the animation starts. The default value is 0.
  public init(animation: Animation, delay: TimeInterval = 0) {
    self.animation = animation
    self.delay = delay
  }
}
