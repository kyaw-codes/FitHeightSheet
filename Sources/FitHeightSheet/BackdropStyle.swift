//
//  BackdropStyle.swift
//  
//
//  Created by Kyaw Zay Ya Lin Tun on 12/06/2024.
//

import SwiftUI

public struct BackdropStyle {
  let color: Color
  let opacity: CGFloat
  
  public init(color: Color, opacity: CGFloat) {
    self.color = color
    self.opacity = opacity
  }
  
  public static let `default`: Self = .init(color: .black, opacity: 0.5)
}
