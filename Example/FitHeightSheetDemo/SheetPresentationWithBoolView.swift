//
//  SheetPresentationWithBoolView.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 29/05/2024.
//

import SwiftUI
import FitHeightSheet

struct SheetPresentationWithBoolView: View {
  @State private var isPresented = false
  
  var body: some View {
    NavigationStack {
      List {
        Button("Show sheet") {
          isPresented.toggle()
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
      .fitHeightSheet(isPresented: $isPresented, onDismiss: { print("onDismiss") }) {
        SheetView()
      }
    }
    
  }
}

#Preview {
  SheetPresentationWithBoolView()
}
