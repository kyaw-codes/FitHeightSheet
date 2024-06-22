//
//  BackdropStyle.swift
//  
//
//  Created by Kyaw Zay Ya Lin Tun on 12/06/2024.
//

import SwiftUI

/// `BackdropStyle` is a struct designed to define the style of a backdrop. It encapsulates both the color and opacity of the backdrop, allowing for easy customization and reuse of backdrop styles in your application.
public struct BackdropStyle {
  let color: Color
  let opacity: CGFloat
  
  /// Creates a new `BackdropStyle` instance.
  /// - Parameters:
  ///   - color: The color of the backdrop.
  ///   - opacity: The opacity level of the backdrop.
  public init(color: Color, opacity: CGFloat) {
    self.color = color
    self.opacity = opacity
  }
  
  /// A static property providing a default backdrop style. This default style has a black color with an opacity of 0.5, offering a semi-transparent black backdrop.
  ///
  /// By default, fitHeightSheet uses this backdrop style.
  public static let `default`: Self = .init(color: .black, opacity: 0.5)
}
