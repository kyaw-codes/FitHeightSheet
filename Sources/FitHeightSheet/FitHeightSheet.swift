import SwiftUI
import Combine

extension View {
  public func fitHeightSheet<Body: View>(
    isPresented: Binding<Bool>,
    backdropColor: Color = .black,
    backdropOpacity: CGFloat = 0.5,
    topContentOffset: CGFloat = 40,
    @ViewBuilder _ body: @escaping () -> Body
  ) -> some View {
    modifier(
      FitHeightSheetModifire(
        isPresented: isPresented,
        backdropColor: backdropColor,
        backdropOpacity: backdropOpacity,
        topContentOffset: topContentOffset,
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
  @State private var offsetY = CGFloat.zero
  @State private var contentHeight = CGFloat.zero
  @State private var keyboardHeight: CGFloat = 0
  
  private let backdropColor: Color
  private let backdropOpacity: CGFloat
  private let topContentOffset: CGFloat
  
  var body: () -> Body
  
  var safeAreaTop: CGFloat {
    UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.first(where: { $0 is UIWindowScene }).flatMap({ $0 as? UIWindowScene })?.windows.first(where: \.isKeyWindow)?.safeAreaInsets.top ?? 0
  }
  
  init(
    isPresented: Binding<Bool>,
    backdropColor: Color,
    backdropOpacity: CGFloat,
    topContentOffset: CGFloat,
    @ViewBuilder _ body: @escaping () -> Body
  ) {
    self._isPresented = isPresented
    self.backdropColor = backdropColor
    self.backdropOpacity = backdropOpacity
    self.topContentOffset = topContentOffset
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
          .padding(.top, topContentOffset)
          .background(
            GeometryReader {
              Color.clear.preference(key: ContentHeightKey.self, value: $0.size.height)
            }
          )
          .onPreferenceChange(ContentHeightKey.self) {
            contentHeight = $0
          }
          .offset(y: max(0, offsetY))
          .padding(.bottom, keyboardHeight > 0 ? keyboardHeight : 0)
          .onReceive(Publishers.keyboardHeight) { height in
            withAnimation(isPresented ? .smooth : .bouncy) {
              self.keyboardHeight = height
            }
          }
          .gesture(
            DragGesture(minimumDistance: 5)
              .onChanged { value in
                offsetY = value.translation.height
              }
              .onEnded { value in
                if value.location.y > (contentHeight * 0.5) {
                  withAnimation(isPresented ? .smooth : .bouncy) {
                    isPresented.toggle()
                  }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    offsetY = 0
                  }
                } else {
                  withAnimation(isPresented ? .smooth : .bouncy) {
                    offsetY = 0
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
