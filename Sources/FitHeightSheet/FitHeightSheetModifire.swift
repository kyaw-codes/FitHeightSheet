//
//  FitHeightSheetModifire.swift
//
//
//  Created by Kyaw Zay Ya Lin Tun on 14/06/2024.
//

import SwiftUI

struct FitHeightSheetModifire<Body: View>: ViewModifier {
  @Binding var isPresented: Bool
  @State private var internalPresented: Bool = false
  @State private var dragOffsetY = CGFloat.zero
  @State private var offsetY = CGFloat.zero
  @State private var contentHeight = CGFloat.zero
  
  @Environment(\.fitInteractiveDismissDisabled) private var fitInteractiveDismissDisabled
  
  private let backdropColor: Color
  private let backdropOpacity: CGFloat
  private let presentAnimation: AnimationConfiguration
  private let dismissAnimation: AnimationConfiguration
  private let topContentInset: CGFloat
  private let dismissThreshold: CGFloat
  
  private var body: () -> Body
  private var onDismiss: (() -> Void)?
  
  private var availableContentHeight: CGFloat {
    FitHeightSheet.availableContentHeight(topContentInset: topContentInset)
  }
  
  private var gesture: some Gesture {
    DragGesture(minimumDistance: 5)
      .onChanged { value in
        dragOffsetY = value.translation.height
      }
      .onEnded { value in
        guard !fitInteractiveDismissDisabled else {
          withAnimation(presentAnimation.value) {
            dragOffsetY = 0
            offsetY = 0
          }
          return
        }
        
        if offsetY > (contentHeight * dismissThreshold) {
          withAnimation(isPresented ? presentAnimation.value : dismissAnimation.value) {
            isPresented.toggle()
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dragOffsetY = 0
          }
        } else {
          withAnimation(isPresented ? presentAnimation.value : dismissAnimation.value) {
            dragOffsetY = 0
            offsetY = 0
          }
        }
      }
  }
  
  init(
    isPresented: Binding<Bool>,
    backdropStyle: BackdropStyle,
    presentAnimation: AnimationConfiguration,
    dismissAnimation: AnimationConfiguration,
    topContentInset: CGFloat,
    dismissThreshold: CGFloat,
    onDismiss: (() -> Void)?,
    @ViewBuilder _ body: @escaping () -> Body
  ) {
    self._isPresented = isPresented
    self.backdropColor = backdropStyle.color
    self.backdropOpacity = backdropStyle.opacity
    self.presentAnimation = presentAnimation
    self.dismissAnimation = dismissAnimation
    self.topContentInset = topContentInset
    self.dismissThreshold = dismissThreshold
    self.onDismiss = onDismiss
    self.body = body
  }
  
  func body(content: Content) -> some View {
    ZStack {
      content
        .zIndex(1)
      
      // Backdrop view
      if internalPresented {
        Rectangle()
          .fill(backdropColor)
          .opacity(
            calculate(
              backdropOpacity: backdropOpacity,
              offsetY: offsetY,
              contentHeight: contentHeight,
              availableContentHeight: availableContentHeight
            )
          )
          .ignoresSafeArea()
          .allowsHitTesting(internalPresented)
          .onTapGesture {
            guard !fitInteractiveDismissDisabled else { return }
            withAnimation(isPresented ? presentAnimation.value : dismissAnimation.value) {
              isPresented = false
            }
          }
          .zIndex(3)
          .transition(.opacity)
        
        body()
          .background(
            GeometryReader {
              Color.clear
                .preference(key: ContentHeightKey.self, value: $0.size.height)
                .preference(key: OffsetYKey.self, value: $0.frame(in: .global).minY)
            }
          )
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          .padding(.top, topContentInset)
          .onPreferenceChange(ContentHeightKey.self) {
            contentHeight = $0
          }
          .onPreferenceChange(OffsetYKey.self) { offsetY in
            let height = UIScreen.main.bounds.height - min(availableContentHeight, contentHeight) - topContentInset
            self.offsetY = offsetY - height
          }
          .offset(y: max(0, dragOffsetY))
          .gesture(gesture)
          .zIndex(3)
          .transition(.move(edge: .bottom).combined(with: .opacity))
      }
    }
    .onChange(of: isPresented) { _ in
      onChangeOfIsPresented()
    }
    .onReceive(NotificationCenter.default.publisher(for: .fitHeightSheetDismiss)) { _ in
      withAnimation(isPresented ? presentAnimation.value : dismissAnimation.value) {
        isPresented = false
      }
    }
  }
  
  private func onChangeOfIsPresented() {
    if !isPresented {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      onDismiss?()
    }
    withAnimation(isPresented ? presentAnimation.value : dismissAnimation.value) {
      internalPresented = isPresented
    }
  }
}
