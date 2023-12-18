//
//  SwiftUIView.swift
//  EX
//
//  Created by Thuyen Trinh on 04/12/2023.
//

import SwiftUI

struct HomeScreen: View {
  @StateObject private var vm: HomeVM = .init()

  var body: some View {
    NavigationStack {
      VStack {
        Text("No content yet")
      }
      .navigationTitle("Home")
    }
  }
}

#Preview {
  HomeScreen()
}
