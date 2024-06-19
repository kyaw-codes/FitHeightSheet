//
//  SheetView.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 14/06/2024.
//

import SwiftUI

struct SheetView: View {
  @Environment(\.fitHeightSheetDismiss) private var dismiss
  var emoji: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Hello there \(emoji ?? "👋")")
        .font(.title.bold())
      
      Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl. Suspendisse sapien quam, vulputate eu vestibulum in, sagittis in sem. Suspendisse nibh ante.")
      
      Button {
        dismiss()
      } label: {
        Text("Dismiss")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
          .background {
            RoundedRectangle(cornerRadius: 8)
              .fill(.blue)
          }
          .foregroundStyle(.white)
      }
      .padding(.top)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(.regularMaterial)
    
  }
}
