import SwiftUI
import Combine

extension View {
  public func fitHeightSheet<Body: View>(
    isPresented: Binding<Bool>,
    backdropColor: Color = .black,
    backdropOpacity: CGFloat = 0.5,
    topContentInset: CGFloat = 40,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder _ body: @escaping () -> Body
  ) -> some View {
    modifier(
      FitHeightSheetModifire(
        isPresented: isPresented,
        backdropColor: backdropColor,
        backdropOpacity: backdropOpacity,
        topContentInset: topContentInset,
        onDismiss: onDismiss,
        body
      )
    )
  }
}

// MARK: - Dismiss
extension EnvironmentValues {
  public var fitHeightSheetDismiss: () -> () {
    get { self[FitHeightSheetDismissKey.self] }
    set { self[FitHeightSheetDismissKey.self] = newValue }
  }
}

extension Notification.Name {
  static let fitHeightSheetDismiss = NSNotification.Name("fit_height_sheet_dismiss")
}

struct FitHeightSheetDismissKey: EnvironmentKey {
  static let defaultValue: () -> () = { NotificationCenter.default.post(.init(name: .fitHeightSheetDismiss)) }
}

// MARK: - Modifire
struct FitHeightSheetModifire<Body: View>: ViewModifier {
  @Binding var isPresented: Bool
  @State private var internalPresented: Bool = false
  @State private var dragOffsetY = CGFloat.zero
  @State private var dragVelocity = CGFloat.zero
  @State private var offsetY = CGFloat.zero
  @State private var contentHeight = CGFloat.zero
  
  private let backdropColor: Color
  private let backdropOpacity: CGFloat
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
  
  init(
    isPresented: Binding<Bool>,
    backdropColor: Color,
    backdropOpacity: CGFloat,
    topContentInset: CGFloat,
    onDismiss: (() -> Void)?,
    @ViewBuilder _ body: @escaping () -> Body
  ) {
    self._isPresented = isPresented
    self.backdropColor = backdropColor
    self.backdropOpacity = backdropOpacity
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
            withAnimation(isPresented ? .smooth : .bouncy) {
              isPresented.toggle()
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
          .gesture(
            DragGesture(minimumDistance: 5)
              .onChanged { value in
                dragOffsetY = value.translation.height
                dragVelocity = value.velocity.height
              }
              .onEnded { value in
                guard dragVelocity < 3000 else { return }
                if offsetY > (contentHeight * 0.5) {
                  withAnimation(isPresented ? .smooth : .bouncy) {
                    isPresented.toggle()
                  }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dragOffsetY = 0
                  }
                } else {
                  withAnimation(isPresented ? .smooth : .bouncy) {
                    dragOffsetY = 0
                    offsetY = 0
                  }
                }
              }
          )
          .zIndex(3)
          .transition(.move(edge: .bottom).combined(with: .opacity))
      }
    }
    .onChange(of: isPresented) { _ in
      if !isPresented {
        onDismiss?()
      }
      withAnimation(isPresented ? .smooth : .bouncy) {
        internalPresented = isPresented
      }
    }
    .onChange(of: dragVelocity) { _ in
      guard isPresented else { return }
      if dragVelocity > 3000 {

        isPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          dragOffsetY = 0
        }
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: .fitHeightSheetDismiss)) { _ in
      withAnimation(isPresented ? .smooth : .bouncy) {
        isPresented = false
      }
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
