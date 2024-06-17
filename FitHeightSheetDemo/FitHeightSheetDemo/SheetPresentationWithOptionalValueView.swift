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

struct SheetPresentationWithOptionalValueView: View {
  @State private var emoji: EmojiWrapper?
  
  var body: some View {
    NavigationStack {
      List {
        Button("Show sheet") {
          emoji = "🎉"
        }
      }
      .navigationTitle("FitHeightSheet")
      .navigationBarTitleDisplayMode(.inline)
      .background {
        LinearGradient(
          colors: [.blue, .cyan, .cyan, .yellow], startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()
      }
      .scrollContentBackground(.hidden)
      .fitHeightSheet(item: $emoji) {
        SheetView(emoji: $0.emoji)
      }
    }
  }
}

#Preview {
  SheetPresentationWithOptionalValueView()
}
