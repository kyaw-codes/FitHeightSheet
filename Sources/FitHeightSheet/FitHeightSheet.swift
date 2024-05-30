import SwiftUI
import Combine

extension View {
  public func fitHeightSheet<Body: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder _ body: @escaping () -> Body
  ) -> some View {
    modifier(FitHeightSheetModifire(isPresented: isPresented, body))
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
  @State private var offsetY = CGFloat.zero
  @State private var contentHeight = CGFloat.zero
  @State private var keyboardHeight: CGFloat = 0
  
  var body: Body
  
  var safeAreaTop: CGFloat {
    UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.first(where: { $0 is UIWindowScene }).flatMap({ $0 as? UIWindowScene })?.windows.first(where: \.isKeyWindow)?.safeAreaInsets.top ?? 0
  }
  
  init(
    isPresented: Binding<Bool>,
    @ViewBuilder _ body: @escaping () -> Body
  ) {
    self._isPresented = isPresented
    self.body = body()
  }
  
  func body(content: Content) -> some View {
    ZStack {
      content
        .zIndex(0)
      
      ZStack {
        // Backdrop view
        Color.black.opacity(isPresented ? 0.5 : 0)
          .ignoresSafeArea()
          .onTapGesture {
            withAnimation {
              isPresented.toggle()
            }
          }
        
        if isPresented {
          VStack(spacing: 0) {
            Spacer(minLength: safeAreaTop + 40)
            
            body
              .frame(maxWidth: .infinity)
              .background(
                GeometryReader {
                  Color.white.preference(key: ContentHeightKey.self, value: $0.size.height)
                }
              )
              .onPreferenceChange(ContentHeightKey.self) {
                contentHeight = $0
              }
              .offset(y: max(0, offsetY))
              .padding(.bottom, keyboardHeight > 0 ? keyboardHeight : 0)
              .onReceive(Publishers.keyboardHeight) { height in
                withAnimation(height > 0 ? .easeIn(duration: 0.2) : .easeOut(duration: 0.2)) {
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
                      withAnimation {
                        isPresented.toggle()
                      }
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        offsetY = 0
                      }
                    } else {
                      withAnimation(.easeOut) {
                        offsetY = 0
                      }
                    }
                  }
              )
          }
          .frame(maxWidth: .infinity)
          .transition(.move(edge: .bottom))
        }
      }
      .zIndex(1)
      .ignoresSafeArea()
    }
    .onReceive(NotificationCenter.default.publisher(for: .fitHeightSheetDismiss)) { _ in
      withAnimation {
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
