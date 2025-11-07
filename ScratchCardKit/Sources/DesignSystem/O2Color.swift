//
//  O2Color.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 06/11/2025.
//

import SwiftUI

public enum O2Color {
  public static let primaryBlue   = Color(hex: "#0112AA")
  public static let secondaryBlue = Color(hex: "#E5F2FA")
  public static let accentPink    = Color(hex: "#841C59")
  public static let textPrimary   = Color.white
  public static let textSecondary = Color.white.opacity(0.85)
}

extension Color {
  init(hex: String) {
    var str = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0; Scanner(string: str).scanHexInt64(&int)
    // swiftlint:disable identifier_name
    let a, r, g, b: UInt64
    switch str.count {
    case 3: (a, r, g, b) = (255, (int>>8)*17, (int>>4&0xF)*17, (int&0xF)*17)
    case 6: (a, r, g, b) = (255, int>>16, int>>8&0xFF, int&0xFF)
    case 8: (a, r, g, b) = (int>>24, int>>16&0xFF, int>>8&0xFF, int&0xFF)
    default: (a, r, g, b) = (255, 0, 0, 0)
    }
    self = Color(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    // swiftlint:enable identifier_name
  }
}
