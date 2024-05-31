import SwiftUI
import Combine

extension View {
  public func fitHeightSheet<Body: View>(
    isPresented: Binding<Bool>,
    backdropColor: Color = .black,
    backdropOpacity: CGFloat = 0.5,
    topContentInset: CGFloat = 40,
    @ViewBuilder _ body: @escaping () -> Body
  ) -> some View {
    modifier(
      FitHeightSheetModifire(
        isPresented: isPresented,
        backdropColor: backdropColor,
        backdropOpacity: backdropOpacity,
        topContentInset: topContentInset,
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
  @State private var offsetY = CGFloat.zero
  @State private var contentHeight = CGFloat.zero
  @State private var keyboardHeight: CGFloat = 0
  
  private let backdropColor: Color
  private let backdropOpacity: CGFloat
  private let topContentInset: CGFloat
  
  private var body: () -> Body
  
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
    @ViewBuilder _ body: @escaping () -> Body
  ) {
    self._isPresented = isPresented
    self.backdropColor = backdropColor
    self.backdropOpacity = backdropOpacity
    self.topContentInset = topContentInset
    self.body = body
  }
  
  func body(content: Content) -> some View {
    ZStack {
      content
        .zIndex(1)
      
      // Backdrop view
      Rectangle()
        .fill(backdropColor)
        .opacity(internalPresented ? 0.5 : 0)
        .ignoresSafeArea()
        .allowsHitTesting(internalPresented)
        .onTapGesture {
          withAnimation(isPresented ? .smooth : .bouncy) {
            isPresented.toggle()
          }
        }
        .zIndex(3)
      
      if internalPresented {
        body()
          .opacity(isPresented ? 1 : 0)
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
          .padding(.bottom, keyboardHeight > 0 ? keyboardHeight : 0)
          .onReceive(Publishers.keyboardHeight) { height in
            withAnimation(isPresented ? .smooth : .bouncy) {
              self.keyboardHeight = height
            }
          }
          .gesture(
            DragGesture(minimumDistance: 5)
              .onChanged { value in
                dragOffsetY = value.translation.height
              }
              .onEnded { value in
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
                  }
                }
              }
          )
          .zIndex(3)
          .transition(.move(edge: .bottom))
      }
    }
    .onChange(of: isPresented) { _ in
      withAnimation(isPresented ? .smooth : .bouncy) {
        internalPresented = isPresented
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: .fitHeightSheetDismiss)) { _ in
      withAnimation(isPresented ? .smooth : .bouncy) {
        isPresented = false
      }
    }
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

extension Publishers {
  
  static var keyboardHeight: AnyPublisher<CGFloat, Never> {
    let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
      .map { $0.keyboardHeight }
    
    let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
      .map { _ in CGFloat(0) }
    
    return MergeMany(willShow, willHide)
      .eraseToAnyPublisher()
  }
}

extension Notification {
  var keyboardHeight: CGFloat {
    return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
  }
}
