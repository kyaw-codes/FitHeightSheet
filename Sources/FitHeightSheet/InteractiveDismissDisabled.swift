//
//  InteractiveDismissDisabled.swift
//
//
//  Created by Kyaw Zay Ya Lin Tun on 20/06/2024.
//

import SwiftUI

extension EnvironmentValues {
  var fitInteractiveDismissDisabled: Bool {
    get { self[InteractiveDismissDisabledKey.self] }
    set {
      self[InteractiveDismissDisabledKey.self] = newValue
    }
  }
}

struct InteractiveDismissDisabledKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

extension View {
  /// Conditionally prevents interactive dismissal of fit height.
  /// - Parameter isDisabled: A Boolean value that indicates whether to prevent nonprogrammatic dismissal of the containing view hierarchy when presented in a fitHeightSheet.
  ///
  /// Users can dismiss fit height sheet using built-in gestures, just like native SwiftUI sheet. In particular, a user can dismiss a fit height sheet by dragging it down, or by clicking or tapping outside of the presented view. Use the fitInteractiveDismissDisabled(_:) modifier to conditionally prevent this kind of dismissal. You typically do this to prevent the user from dismissing a presentation before providing needed data or completing a required action.
  public func fitInteractiveDismissDisabled(_ isDisabled: Bool = true) -> some View {
    environment(\.fitInteractiveDismissDisabled, isDisabled)
  }
}
