import SwiftUI
import Combine

extension View {
  public func fitHeightSheet<Body: View>(
    isPresented: Binding<Bool>,
    backdropStyle: BackdropStyle = .default,
    presentAnimation: AnimationConfiguration = .init(animation: .smooth),
    dismissAnimation: AnimationConfiguration = .init(animation: .bouncy),
    topContentInset: CGFloat = 40,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Body
  ) -> some View {
    modifier(
      FitHeightSheetModifire(
        isPresented: isPresented,
        backdropStyle: backdropStyle,
        presentAnimation: presentAnimation,
        dismissAnimation: dismissAnimation,
        topContentInset: topContentInset,
        onDismiss: onDismiss,
        content
      )
    )
  }
  
  public func fitHeightSheet<Body: View, Item: Identifiable>(
    item: Binding<Item?>,
    backdropStyle: BackdropStyle = .default,
    presentAnimation: AnimationConfiguration = .init(animation: .smooth),
    dismissAnimation: AnimationConfiguration = .init(animation: .bouncy),
    topContentInset: CGFloat = 40,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Body
  ) -> some View {
    modifier(
      FitHeightSheetWithItemModifire(
        item: item.animation(item.wrappedValue != nil ? presentAnimation.value : dismissAnimation.value),
        backdropStyle: backdropStyle,
        presentAnimation: presentAnimation,
        dismissAnimation: dismissAnimation,
        topContentInset: topContentInset,
        onDismiss: onDismiss,
        content
      )
    )
  }
}

// MARK: - Modifire
struct FitHeightSheetModifire<Body: View>: ViewModifier {
  @Binding var isPresented: Bool
  @State private var internalPresented: Bool = false
  @State private var dragOffsetY = CGFloat.zero
  @State private var offsetY = CGFloat.zero
  @State private var contentHeight = CGFloat.zero
  
  private let backdropColor: Color
  private let backdropOpacity: CGFloat
  private let presentAnimation: AnimationConfiguration
  private let dismissAnimation: AnimationConfiguration
  private let topContentInset: CGFloat
  
  private var body: () -> Body
  private var onDismiss: (() -> Void)?
  
  private var safeAreaTop: CGFloat {
    UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .first(where: { $0 is UIWindowScene })
      .flatMap({ $0 as? UIWindowScene })?
      .windows
      .first(where: \.isKeyWindow)?
      .safeAreaInsets.top ?? 0
  }
  
  private var availableContentHeight: CGFloat {
    UIScreen.main.bounds.height - topContentInset - safeAreaTop
  }
  
  private var gesture: some Gesture {
    DragGesture(minimumDistance: 5)
      .onChanged { value in
        dragOffsetY = value.translation.height
      }
      .onEnded { value in
        if offsetY > (contentHeight * 0.5) {
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
    onDismiss: (() -> Void)?,
    @ViewBuilder _ body: @escaping () -> Body
  ) {
    self._isPresented = isPresented
    self.backdropColor = backdropStyle.color
    self.backdropOpacity = backdropStyle.opacity
    self.presentAnimation = presentAnimation
    self.dismissAnimation = dismissAnimation
    self.topContentInset = topContentInset
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
          .opacity(calculateOpacity())
          .ignoresSafeArea()
          .allowsHitTesting(internalPresented)
          .onTapGesture {
            withAnimation(isPresented ? presentAnimation.value : dismissAnimation.value) {
              isPresented = false
            }
          }
          .zIndex(3)
          .transition(.opacity)
      }
      
      if internalPresented {
        body()
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          .padding(.top, topContentInset)
          .background(
            GeometryReader {
              Color.clear
                .preference(key: ContentHeightKey.self, value: $0.size.height)
                .preference(key: OffsetYKey.self, value: $0.frame(in: .global).minY)
            }
          )
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
  
  private func calculateOpacity() -> CGFloat {
    backdropOpacity - ((offsetY / min(contentHeight, availableContentHeight)) * 0.9)
  }
}

struct FitHeightSheetWithItemModifire<Body: View, Item: Identifiable>: ViewModifier {
  @Binding var item: Item?
  
  @State private var dragOffsetY = CGFloat.zero
  @State private var offsetY = CGFloat.zero
  @State private var contentHeight = CGFloat.zero

  private var internalPresented: Bool {
    item != nil
  }
  
  private let backdropColor: Color
  private let backdropOpacity: CGFloat
  private let presentAnimation: AnimationConfiguration
  private let dismissAnimation: AnimationConfiguration
  private let topContentInset: CGFloat
  
  private var body: (Item) -> Body
  private var onDismiss: (() -> Void)?
  
  private var safeAreaTop: CGFloat {
    UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .first(where: { $0 is UIWindowScene })
      .flatMap({ $0 as? UIWindowScene })?
      .windows
      .first(where: \.isKeyWindow)?
      .safeAreaInsets.top ?? 0
  }
  
  private var availableContentHeight: CGFloat {
    UIScreen.main.bounds.height - topContentInset - safeAreaTop
  }
  
  private var gesture: some Gesture {
    DragGesture(minimumDistance: 5)
      .onChanged { value in
        dragOffsetY = value.translation.height
      }
      .onEnded { value in
        if offsetY > (contentHeight * 0.5) {
          withAnimation(internalPresented ? presentAnimation.value : dismissAnimation.value) {
            item = nil
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dragOffsetY = 0
          }
        } else {
          withAnimation(internalPresented ? presentAnimation.value : dismissAnimation.value) {
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
    onDismiss: (() -> Void)?,
    @ViewBuilder _ body: @escaping (Item) -> Body
  ) {
    self._item = item
    self.backdropColor = backdropStyle.color
    self.backdropOpacity = backdropStyle.opacity
    self.presentAnimation = presentAnimation
    self.dismissAnimation = dismissAnimation
    self.topContentInset = topContentInset
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
          .opacity(calculateOpacity())
          .ignoresSafeArea()
          .allowsHitTesting(internalPresented)
          .onTapGesture {
            withAnimation(internalPresented ? presentAnimation.value : dismissAnimation.value) {
              item = nil
            }
          }
          .zIndex(3)
          .transition(.opacity)
      }
      
      if let item {
        body(item)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          .padding(.top, topContentInset)
          .background(
            GeometryReader {
              Color.clear
                .preference(key: ContentHeightKey.self, value: $0.size.height)
                .preference(key: OffsetYKey.self, value: $0.frame(in: .global).minY)
            }
          )
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
    .onChange(of: internalPresented) { _ in
      onChangeOfIsPresented()
    }
    .onReceive(NotificationCenter.default.publisher(for: .fitHeightSheetDismiss)) { _ in
      withAnimation(internalPresented ? presentAnimation.value : dismissAnimation.value) {
        item = nil
      }
    }
  }
  
  private func onChangeOfIsPresented() {
    if !internalPresented {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      onDismiss?()
    }
  }
  
  private func calculateOpacity() -> CGFloat {
    backdropOpacity - ((offsetY / min(contentHeight, availableContentHeight)) * 0.9)
  }
}

private struct ContentHeightKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

private struct OffsetYKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
