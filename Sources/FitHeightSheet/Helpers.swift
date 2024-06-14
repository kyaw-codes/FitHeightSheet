//
//  Helpers.swift
//
//
//  Created by Kyaw Zay Ya Lin Tun on 14/06/2024.
//

import SwiftUI

struct ContentHeightKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct OffsetYKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

func calculate(backdropOpacity: CGFloat, offsetY: CGFloat, contentHeight: CGFloat, availableContentHeight: CGFloat) -> CGFloat {
  backdropOpacity - ((offsetY / min(contentHeight, availableContentHeight)) * 0.9)
}

func availableContentHeight(topContentInset: CGFloat) -> CGFloat {
  let safeAreaTop = UIApplication.shared.connectedScenes
    .filter { $0.activationState == .foregroundActive }
    .first(where: { $0 is UIWindowScene })
    .flatMap({ $0 as? UIWindowScene })?
    .windows
    .first(where: \.isKeyWindow)?
    .safeAreaInsets.top ?? 0
  return UIScreen.main.bounds.height - topContentInset - safeAreaTop
}
