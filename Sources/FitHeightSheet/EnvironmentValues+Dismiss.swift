//
//  File.swift
//
//
//  Created by Kyaw Zay Ya Lin Tun on 13/06/2024.
//

import SwiftUI

// MARK: - Dismiss
extension EnvironmentValues {
  /**
   An action that dismisses the current `fitHeightSheet` presentation.
      
   This environment value can be used within a SwiftUI view to perform the dismissal of a `fitHeightSheet`. The closure posts a notification via `NotificationCenter`, which can be observed by subscribers to handle the dismissal.
   
   ```swift
   struct ContentView: View {
     @Environment(\.fitHeightSheetDismiss) private var dismissFitHeightSheet
     @State private var showSheet = false
     
     var body: some View {
       Button("Show sheet") {
         showSheet.toggle()
       }
       .fitHeightSheet(isPresented: $showSheet) {
         SheetContent(onDismiss: {
           // Dismiss the current sheet.
           dismissFitHeightSheet()
         })
       }
     }
   }
   ```
   */
  public var fitHeightSheetDismiss: () -> () {
    get { self[FitHeightSheetDismissKey.self] }
    set { self[FitHeightSheetDismissKey.self] = newValue }
  }
}

extension Notification.Name {
  static let fitHeightSheetDismiss = NSNotification.Name("fit_height_sheet_dismiss")
}

struct FitHeightSheetDismissKey: EnvironmentKey {
  static let defaultValue: () -> () = { NotificationCenter.default.post(.init(name: .fitHeightSheetDismiss)) }
}
