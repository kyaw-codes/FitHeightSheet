//
//  ContentView.swift
//  FitHeightSheetExample
//
//  Created by Kyaw Zay Ya Lin Tun on 10/03/2024.
//

import SwiftUI
import FitHeightSheet

struct ContentView: View {
  @State private var isFormShowing = false
  
  var body: some View {
    VStack {
      Button("Show form") {
        isFormShowing.toggle()
      }
    }
    .fitHeightSheet(isPresented: $isFormShowing) {
      RegisterFormView()
    }
  }
}

#Preview {
  ContentView()
}
