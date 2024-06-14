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
