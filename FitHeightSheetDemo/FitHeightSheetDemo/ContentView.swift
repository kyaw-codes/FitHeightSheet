//
//  ContentView.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 29/05/2024.
//

import SwiftUI
import FitHeightSheet

/*
struct MainView: View {
  @State private var currentTab = 0
  @State private var showSheet = false
  
  var body: some View {
    TabView(selection: $currentTab) {
      ContentView($showSheet)
        .tag(0)
        .tabItem {
          Label("Home", systemImage: "house")
        }
      
      Text("Profile")
        .tag(0)
        .tabItem {
          Label("Profile", systemImage: "person")
        }
      
      Text("Search")
        .tag(0)
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
      
      Text("Settings")
        .tag(0)
        .tabItem {
          Label("Settings", systemImage: "gear")
        }
    }
    .fitHeightSheet(isPresented: $showSheet) {
      SheetView()
    }
  }
}
 */

struct Str: Identifiable, ExpressibleByStringLiteral {
  var text: String
  var id = UUID()
  
  init(stringLiteral value: StringLiteralType) {
    text = value
  }
}

struct ContentView: View {
  @State private var text: Str?
  
//  init(_ showSheet: Binding<Bool>) {
//    self._showSheet = showSheet
//  }
  
  var body: some View {
    NavigationStack {
      List {
        Button("Show sheet") {
          text = "Hello there 👋"
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
//      .fitHeightSheet(item: $text) { item in
//        Text("\(item)")
//      }
      .fitHeightSheet(item: $text) { text in
        AnotherSheetView(title: text.text)
      }
    }
    
  }
}

struct AnotherSheetView: View {
  @Environment(\.fitHeightSheetDismiss) private var dismiss
  
  var title: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .font(.title.bold())
      
      //      TextField("Type something here...", text: $text)
      Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl. Suspendisse sapien quam, vulputate eu vestibulum in, sagittis in sem. Suspendisse nibh ante.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl. Suspendisse sapien quam, vulputate eu vestibulum in, sagittis in sem. Suspendisse nibh ante.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl. Suspendisse sapien quam, vulputate eu vestibulum in, sagittis in sem. Suspendisse nibh ante.")
      
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

struct SheetView: View {
  @Environment(\.fitHeightSheetDismiss) private var dismiss
  
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Hello there 👋")
        .font(.title.bold())
      
      //      TextField("Type something here...", text: $text)
      Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl. Suspendisse sapien quam, vulputate eu vestibulum in, sagittis in sem. Suspendisse nibh ante.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl. Suspendisse sapien quam, vulputate eu vestibulum in, sagittis in sem. Suspendisse nibh ante.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl. Suspendisse sapien quam, vulputate eu vestibulum in, sagittis in sem. Suspendisse nibh ante.")
      
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

#Preview {
  ContentView()
}
