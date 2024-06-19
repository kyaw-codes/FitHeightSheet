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
            SheetPresentationWithBoolView()
          }
          
          NavigationLink(".fitHeightSheet(item:content:)") {
            SheetPresentationWithOptionalValueView()
          }
          
          NavigationLink("TabView Example") {
            SheetWithTabView()
          }
        }
        
        Section("Advanced usage") {
          NavigationLink("Sheet customizations") {
            SheetWithCustomizations()
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
