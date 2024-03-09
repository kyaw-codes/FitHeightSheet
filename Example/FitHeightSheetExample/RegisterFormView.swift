//
//  RegisterFormView.swift
//  FitHeightSheetExample
//
//  Created by Kyaw Zay Ya Lin Tun on 10/03/2024.
//

import SwiftUI
import FitHeightSheet

struct RegisterFormView: View {
  @Environment(\.fitHeightSheetDismiss) private var fitHeightSheetDismiss
  
  @State private var firstName = ""
  @State private var lastName = ""
  @State private var email = ""
  @State private var password = ""
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("Register")
        .font(.title.bold())
      TextField("First name", text: $firstName)
        .textFieldStyle(.roundedBorder)
      
      TextField("Last name", text: $lastName)
        .textFieldStyle(.roundedBorder)
      
      TextField("Email", text: $email)
        .textFieldStyle(.roundedBorder)
      
      TextField("Password", text: $password)
        .textFieldStyle(.roundedBorder)
    }
    .foregroundColor(.white)
    .padding()
    .navigationTitle("Register")
    .background(
      LinearGradient(
        colors: [.pink, .red],
        startPoint: .top,
        endPoint: .bottom
      )
    )
  }
}

#Preview {
  RegisterFormView()
}
