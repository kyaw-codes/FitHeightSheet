//
//  SheetWithTabView.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 14/06/2024.
//

import SwiftUI

struct SheetWithTabView: View {
  @State private var selectedTab = 0
  @State private var showSheet = false
  
  var body: some View {
    TabView(selection: $selectedTab) {
      Button("Show sheet") {
        showSheet.toggle()
      }
      .tabItem {
        Label("Sheet", systemImage: "rectangle.stack.fill")
      }
      .tag(0)
      
      Text("One")
        .tabItem {
          Label("One", systemImage: "1.circle.fill")
        }
        .tag(1)
      Text("Two")
        .tabItem {
          Label("Two", systemImage: "2.circle.fill")
        }
        .tag(2)
      Text("Three")
        .tabItem {
          Label("Three", systemImage: "3.circle.fill")
        }
        .tag(3)
    }
    .fitHeightSheet(isPresented: $showSheet) {
      SheetView()
    }
  }
}

#Preview {
  SheetWithTabView()
}
