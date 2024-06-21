//
//  FitHeightSheetWithItemModifire.swift
//
//
//  Created by Kyaw Zay Ya Lin Tun on 14/06/2024.
//

import SwiftUI
import Combine

struct FitHeightSheetWithItemModifire<Body: View, Item>: ViewModifier {
  @Binding var item: Item?
  
  @State private var dragOffsetY = CGFloat.zero
  @State private var offsetY = CGFloat.zero
  @State private var contentHeight = CGFloat.zero
  @State private var contentHeightChanged = false

  @State private  var isPresented = false
  
  @Environment(\.fitInteractiveDismissDisabled) private var fitInteractiveDismissDisabled
  
  private let backdropColor: Color
  private let backdropOpacity: CGFloat
  private let presentAnimation: AnimationConfiguration
  private let dismissAnimation: AnimationConfiguration
  private let topContentInset: CGFloat
  private let dismissThreshold: CGFloat
  
  private var body: (Item) -> Body
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
            item = nil
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
    item: Binding<Item?>,
    backdropStyle: BackdropStyle,
    presentAnimation: AnimationConfiguration,
    dismissAnimation: AnimationConfiguration,
    topContentInset: CGFloat,
    dismissThreshold: CGFloat,
    onDismiss: (() -> Void)?,
    @ViewBuilder _ body: @escaping (Item) -> Body
  ) {
    self._item = item
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
      if isPresented {
        Rectangle()
          .fill(backdropColor)
          .opacity(
            contentHeightChanged ? backdropOpacity : calculate(
              backdropOpacity: backdropOpacity,
              offsetY: offsetY,
              contentHeight: contentHeight,
              availableContentHeight: availableContentHeight
            )
          )
          .ignoresSafeArea()
          .allowsHitTesting(isPresented)
          .onTapGesture {
            guard !fitInteractiveDismissDisabled else { return }
            withAnimation(isPresented ? presentAnimation.value : dismissAnimation.value) {
              item = nil
            }
          }
          .zIndex(3)
          .transition(.opacity)
        
        Group {
          if let item {
            body(item)
          } else {
            EmptyView()
          }
        }
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
          contentHeightChanged = contentHeight != .zero && $0 != contentHeight
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
        item = nil
      }
    }
    .onReceive(Just(item)) { item in
      // This one is very tricky, even though it isPresented, we will have to reverse the animation value
      withAnimation(isPresented ? dismissAnimation.value : presentAnimation.value) {
        isPresented = item != nil
      }
    }
  }
  
  private func onChangeOfIsPresented() {
    if !isPresented {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      onDismiss?()
    }
  }
}
