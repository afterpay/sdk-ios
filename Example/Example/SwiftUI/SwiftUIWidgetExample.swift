//
//  SwiftUIWidgetExample.swift
//  Example
//
//  Created by Huw Rowlands on 26/4/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct ConnectedWidgetExample: View {

  @State var amount: String = "800"

  var body: some View {
    NavigationView {
      ZStack {
        Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all)
        VStack(alignment: .leading) {

          Text("Tokenless mode:")
            .font(.headline)
          AfterpayWidget(amount: amount)
            .overlay(outline)
            .padding(.bottom)

          HStack {
            Text("Total Amount:")
            TextField("Amount", text: $amount)
              .multilineTextAlignment(.trailing)
          }
          Spacer()
        }
        .padding()
        .navigationBarTitle("Tokenless Widget")
      }
    }
  }

}

@available(iOS 13.0, *)
struct TokenlessWidgetExample: View {

  @State var amount: String?

  var body: some View {
    NavigationView {
      ZStack {
        Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all)
        VStack(alignment: .leading) {

          Text("Connected mode:")
            .font(.headline)
          Text("(Provide the token in the code)").font(.caption)
          AfterpayWidget(token: "001.tovn61n9ggthpbm7ogom4k1an209627emu2104b1u398go3r", amount: amount)
            .overlay(outline)
            .padding(.bottom)

          HStack {
            Text("Total Amount:")
            TextField("Amount", text: Binding(get: { amount ?? "" }, set: { amount = $0 }))
              .multilineTextAlignment(.trailing)
          }
          Spacer()
        }
        .padding()
        .navigationBarTitle("Connected Widget")
      }
    }
  }

}

@available(iOS 13.0.0, *)
private let outline: some View = RoundedRectangle(cornerRadius: 10, style: .continuous)
  .stroke(lineWidth: 1)
  .foregroundColor(Color(.separator))

@available(iOS 13.0.0, *)
struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    TokenlessWidgetExample()
    ConnectedWidgetExample()
  }
}
