//
//  ContentView.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 29/05/2024.
//

import SwiftUI
import FitHeightSheet

struct ContentView: View {
  @Environment(\.fitHeightSheetDismiss) private var dismiss
  @State private var showSheet = false
  
  var body: some View {
    VStack {
      Button("Show me") {
        showSheet.toggle()
      }
    }
    .padding()
    .fitHeightSheet(isPresented: $showSheet) {
      VStack {
        Text("Yoo")
          .padding(.vertical, 40)
        Button("Dismiss") {
          dismiss()
        }
        .padding()
      }
      .frame(maxWidth: .infinity)
      .background(Color.white)
    }
  }
}

#Preview {
  ContentView()
}
