import SwiftUI
import Combine

extension View {
  /**
   The `fitHeightSheet` function is a SwiftUI view modifier that presents a custom sheet with specific height constraints. It provides various customization options including animations, backdrop style, and dismissal behavior.
   
    - Parameters:
      - isPresented: A `Binding<Bool>` that controls whether the sheet is presented (`true`) or dismissed (`false`).
      - backdropStyle: A `BackdropStyle` that defines the appearance of the backdrop. Defaults to `.default`, which is a semi-transparent black backdrop.
      - presentAnimation: An `AnimationConfiguration` that specifies the animation to use when presenting the sheet. Defaults to a `.smooth` animation.
      - dismissAnimation: An `AnimationConfiguration` that specifies the animation to use when dismissing the sheet. Defaults to a `.bouncy` animation.
      - topContentInset: A `CGFloat` value that sets the top content inset for the sheet. Defaults to `40`.
      - dismissThreshold: A `CGFloat` value representing the threshold for dismissing the sheet, relative to the height of the sheet. Defaults to `0.5`.
      - onDismiss: An optional closure `(() -> Void)?` that is called when the sheet is dismissed. Defaults to `nil`.
      - content: A `ViewBuilder` that creates the content of the sheet.
    - Returns: A modified view with the fit height sheet behavior applied.
   
   The fitHeightSheet function provides a flexible way to present a sheet with a specific height in a SwiftUI application. It allows for detailed customization of the presentation and dismissal animations, backdrop style, and content inset, as well as providing an optional closure for handling the dismissal event.
   */
  public func fitHeightSheet<Body: View>(
    isPresented: Binding<Bool>,
    backdropStyle: BackdropStyle = .default,
    presentAnimation: AnimationConfiguration = .init(animation: .smooth),
    dismissAnimation: AnimationConfiguration = .init(animation: .bouncy),
    topContentInset: CGFloat = 40,
    dismissThreshold: CGFloat = 0.5,
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
        dismissThreshold: dismissThreshold,
        onDismiss: onDismiss,
        content
      )
    )
  }
  
  /** This variant of the function uses an optional item to control the presentation and dismissal of the sheet. It provides various customization options including animations, backdrop style, and dismissal behavior.
   - Parameters:
     - item: A `Binding<Item?>` that controls whether the sheet is presented (when the item is non-nil) or dismissed (when the item is nil).
     - backdropStyle: A `BackdropStyle` that defines the appearance of the backdrop. Defaults to `.default`, which is a semi-transparent black backdrop.
     - presentAnimation: An `AnimationConfiguration` that specifies the animation to use when presenting the sheet. Defaults to a `.smooth` animation.
     - dismissAnimation: An `AnimationConfiguration` that specifies the animation to use when dismissing the sheet. Defaults to a `.bouncy` animation.
     - topContentInset: A `CGFloat` value that sets the top content inset for the sheet. Defaults to `40`.
     - dismissThreshold: A `CGFloat` value representing the threshold for dismissing the sheet, relative to the height of the sheet. Defaults to `0.5`.
     - onDismiss: An optional closure `(() -> Void)?` that is called when the sheet is dismissed. Defaults to `nil`.
     - content: A `ViewBuilder` that creates the content of the sheet.
   - Returns: A modified view with the fit height sheet behavior applied.
   */
  public func fitHeightSheet<Body: View, Item>(
    item: Binding<Item?>,
    backdropStyle: BackdropStyle = .default,
    presentAnimation: AnimationConfiguration = .init(animation: .smooth),
    dismissAnimation: AnimationConfiguration = .init(animation: .bouncy),
    topContentInset: CGFloat = 40,
    dismissThreshold: CGFloat = 0.5,
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
        dismissThreshold: dismissThreshold,
        onDismiss: onDismiss,
        content
      )
    )
  }
}
