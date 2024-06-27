# Tutorial

The FitHeightSheet package is as easy as pie and just as versatile! It works similarly to the native SwiftUI sheet but with some naming tweaks.

## Presenting a FitHeightSheet

### State-based control

Just like native SwiftUI sheet, you can show/hide fit height sheet via `fitHeightSheet(isPresented:content:)` modifire.

```swift
struct HomeView {
  @State private var showSheet = false
  
  var body: some View {
    Button("Show sheet") {
      showSheet.toggle()
    }
    // Just like sheet(isPresented:content:)
    .fitHeightSheet(isPresented: $showSheet) {
      // Your sheet here...
      Sheet()
    }
  }
}
```

### Item-Based Control 
Just like native SwiftUI sheet, you can show/hide fit height sheet via `fitHeightSheet(item:content:)` modifire.

```swift
struct HomeView {
  @State private var greetingText: String? = nil
  
  var body: some View {
    Button("Show sheet") {
      greetingText = "Hello 👋"
    }
    // Just like sheet(item:content:)
    .fitHeightSheet(item: $greetingText) {
      // Your sheet here...
      Sheet(greeting: greetingText)
    }
  }
}
```

## Customisation options
You can customize backdrop style, presentation and dismissal timing curve, top content inset, and dismiss threshold. If you want to do something once the sheet is dismissed, you can write your logic inside `onDismiss` clsoure.

> Please be advised that `onAppear` modifire on your custom sheet might give you unexpected results. I would recomend you to use `onChange` modifire instead.

```swift
struct HomeView {
  @State private var showSheet = false
  
  var body: some View {
    Button("Show sheet") {
      showSheet.toggle()
    }
    .fitHeightSheet(isPresented: $showSheet) {
      Sheet()
    }
    .onChange(of: showSheet) { isPresented in
      guard isPresented else { return }
      // Do your sheet's onAppear logic here
    }
  }
}
```

## Dismissing a FitHeightSheet
Dismissing a FitHeightSheet is as easy as dismissing a SwiftUI sheet. All you need is `fitHeightSheetDismiss` environment value and you can call it just like SwiftUI sheet.

```swift
struct Sheet {
  @Environment(\.fitHeightSheetDismiss) private var dismiss
  
  var body: some View {
    VStack {
      // Your sheet content here
      Button("Close") {
        dismiss()
      }
    }
  }
}
```
