//
//  SheetWithCustomizations.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 19/06/2024.
//

import SwiftUI
import FitHeightSheet

struct SheetWithCustomizations: View {
  @State private var showSheet = false
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.blue, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()
      
      Button {
        showSheet.toggle()
      } label: {
        Text("Show sheet")
          .padding(.horizontal)
          .padding(.vertical, 8)
          .background(Capsule().fill(.white))
      }
    }
    .fitHeightSheet(
      isPresented: $showSheet,
      backdropStyle: .init(color: .cyan, opacity: 0.7),
      presentAnimation: .init(animation: .easeOut),
      dismissAnimation: .init(animation: .easeIn),
      dismissThreshold: 0.7
    ){
      SheetView()
    }
  }
}

#Preview {
  SheetWithCustomizations()
}
