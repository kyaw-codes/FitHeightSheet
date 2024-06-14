//
//  HomeView.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 14/06/2024.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    NavigationStack {
      List {
        Section("Simple usage") {
          NavigationLink(".fitHeightSheet(isPresented:content:)") {
            
          }
        }
      }
      .navigationTitle("FitHeightSheet Demo")
    }
  }
}

#Preview {
  HomeView()
}
