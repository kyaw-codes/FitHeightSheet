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
  @State private var interactiveDismissDisabled = false
  
  var body: some View {
    Form {
      Section {
        Button {
          showSheet.toggle()
        } label: {
          Text("Show sheet")
            .tint(.primary)
        }
        
        Toggle("Interactive dismiss disabled", isOn: $interactiveDismissDisabled)
      }
      .listRowBackground(Rectangle().fill(.regularMaterial))
    }
    .background(
      RadialGradient(colors: [.blue, .purple], center: .bottom, startRadius: 70, endRadius: 400)
    )
    .scrollContentBackground(.hidden)
    .fitHeightSheet(
      isPresented: $showSheet,
      backdropStyle: .init(color: .cyan, opacity: 0.7),
      presentAnimation: .init(animation: .easeOut),
      dismissAnimation: .init(animation: .easeIn),
      dismissThreshold: 0.7
    ){
      SheetView()
    }
    .fitInteractiveDismissDisabled(interactiveDismissDisabled)
    .navigationTitle("Customizations")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  SheetWithCustomizations()
}
