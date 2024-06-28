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
  @State private var dismissThreshold: CGFloat = 0.5
  @State private var backdropColor = Color.cyan
  @State private var backdropOpacity: CGFloat = 0.5

  var body: some View {
    Form {
      Section {
        Button {
          showSheet.toggle()
        } label: {
          Text("Show sheet")
            .tint(.primary)
        }
      }
      .listRowBackground(Rectangle().fill(.regularMaterial))
      
      Section() {
        ColorPicker("Backdrop color", selection: $backdropColor)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Backdrop opacity: \(String(format: "%.2f", arguments: [backdropOpacity * 100]))%")
          Slider(value: $backdropOpacity, in: 0.2 ... 0.9)
        }
      }
      .listRowBackground(Rectangle().fill(.regularMaterial))

      Section {
        
        Toggle("Interactive dismiss disabled", isOn: $interactiveDismissDisabled)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Dismiss threshold: \(String(format: "%.2f", arguments: [dismissThreshold * 100]))%")
          Slider(value: $dismissThreshold, in: 0.2 ... 0.9)
        }
      }
      .listRowBackground(Rectangle().fill(.regularMaterial))
    }
    .background(
      RadialGradient(colors: [.blue, .purple], center: .bottom, startRadius: 70, endRadius: 400)
    )
    .scrollContentBackground(.hidden)
    .fitHeightSheet(
      isPresented: $showSheet,
      backdropStyle: .init(color: backdropColor, opacity: 0.7),
      presentAnimation: .init(animation: .snappy),
      dismissAnimation: .init(animation: .interactiveSpring),
      dismissThreshold: dismissThreshold
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
