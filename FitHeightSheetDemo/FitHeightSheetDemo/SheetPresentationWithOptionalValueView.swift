//
//  SheetPresentationWithOptionalValueView.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 14/06/2024.
//

import SwiftUI

struct EmojiWrapper: Identifiable, ExpressibleByStringLiteral {
  var emoji: String
  var id = UUID()
  
  init(stringLiteral value: StringLiteralType) {
    emoji = value
  }
}
