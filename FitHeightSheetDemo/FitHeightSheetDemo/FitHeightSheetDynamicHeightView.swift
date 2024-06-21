//
//  FitHeightSheetDynamicHeightView.swift
//  FitHeightSheetDemo
//
//  Created by Kyaw Zay Ya Lin Tun on 21/06/2024.
//

import SwiftUI
import FitHeightSheet

struct FitHeightSheetDynamicHeightView: View {
  @Environment(\.fitHeightSheetDismiss) private var dismiss
  @State private var showSheet = false
  @State private var readMore = false
  
  var body: some View {
    Button("Show sheet") {
      showSheet.toggle()
    }
    .fitHeightSheet(isPresented: $showSheet) {
      VStack(alignment: .leading, spacing: 12) {
        Text("Hello there 👋")
          .font(.title.bold())
        
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl. Suspendisse sapien quam, vulputate eu vestibulum in, sagittis in sem. Suspendisse nibh ante.")
        
        if readMore {
          Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius consectetur pellentesque. Praesent ornare velit sit amet lectus egestas, vitae condimentum ex tincidunt. Proin ut tincidunt nisl.")
        }
        
        Button(readMore ? "Read less" : "Read more") {
          withAnimation {
            readMore = !readMore
          }
        }
        
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
}

#Preview {
  FitHeightSheetDynamicHeightView()
}
