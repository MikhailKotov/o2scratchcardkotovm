//
//  o2scratchcardkotovmApp.swift
//  o2scratchcardkotovm
//
//  Created by Mykhailo Kotov on 01/11/2025.
//

import SwiftUI
import FeatureMain

import DesignSystem

@main
struct o2scratchcardkotovmApp: App {
  var body: some Scene {
    WindowGroup {
//      RootView()
//        .appGradientBackground()
      MorphingButtonToDetail()
        .appGradientBackground()
    }
  }
}
