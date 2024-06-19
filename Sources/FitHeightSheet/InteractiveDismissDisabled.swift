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
  public func fitInteractiveDismissDisabled(_ isDisabled: Bool = true) -> some View {
    environment(\.fitInteractiveDismissDisabled, isDisabled)
  }
}
