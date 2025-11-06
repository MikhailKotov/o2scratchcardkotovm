//
//  GlassCard.swift
//  ScratchCardKit
//
//  Created by Mykhailo Kotov on 06/11/2025.
//

import SwiftUI

public struct GlassCard<Content: View>: View {
  let content: Content
  let corner: CGFloat
  public init(corner: CGFloat = 24, @ViewBuilder content: () -> Content) {
    self.content = content(); self.corner = corner
  }
  public var body: some View {
    content
      .padding(16)
      .labelStyle(.iconOnly)
      .foregroundColor(.white)
      .glassEffect(Glass.clear.interactive(), in: .rect(cornerRadius: 16.0))
  }
}

#Preview {
  @Previewable @State var isOn: Bool = true
  ZStack {
    LinearGradient(
      gradient: Gradient(colors: [O2Color.primaryBlue, O2Color.secondaryBlue]),
      startPoint: .top, endPoint: .bottom)
    GlassCard(corner: 12) {
      Button(action: {
        isOn = !isOn
        print("zzz 1 \(isOn)")
      }, label: {
        ZStack {
          Text("Hold me 2 seconds")
            .font(.footnote)
            .padding(.bottom, 100)
          Label("gift", systemImage: "gift")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .font(.title)
          Toggle("", isOn: $isOn)
            .labelsHidden()
            .glassEffect()
            .padding(.top, 100)
        }
      })
    }
    .padding(32)
    .frame(height: 300)
  }
  .ignoresSafeArea()
}
