# FitHeightSheet
<!-- <p align="center">
    <img src="images/logo.png" alt="Ignite logo" width="256" height="234" />
</p> -->

<p align="left">
    <img src="https://img.shields.io/badge/iOS-14.0+-2980b9.svg" />
    <a href="https://twitter.com/KyawTheMonkey">
        <img src="https://img.shields.io/badge/Contact-@KyawTheMonkey-95a5a6.svg?style=flat" alt="Twitter: @KyawTheMonkey" />
    </a>
</p>

The `fitHeightSheet` view modifier allows you to present a sheet that dynamically adjusts its height based on the content it contains. This is particularly useful when the content does not need to scroll and you want a more compact and visually appealing presentation. While the `FitHeightSheet` package is not intended to replace the native SwiftUI sheet, it complements it by addressing specific use cases where a content-fitted sheet is more appropriate.

---

## Installation

Requires iOS 14+. FitHeightSheet can be installed through the [Swift Package Manager](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).
Add the package URL:
```
https://github.com/kyaw-codes/FitHeightSheet
```

---


## Tutorial

The FitHeightSheet package is as easy as pie and just as versatile! It works similarly to the native SwiftUI sheet but with some naming tweaks.

### 1. State-based control

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

### 2. Item-Based Control 
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

### 3. Customisation options
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

### 4. Dismissing a FitHeightSheet
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

---

## Key Features
The FitHeightSheet package enhances SwiftUI applications by providing a sheet that fits precisely around its content.

#### 1. Adaptive Height 
The sheet adjusts its height to fit the content, ensuring a seamless user experience.

#### 2. State-Based Control 
Use a boolean binding to control the presentation and dismissal of the sheet.

#### 3. Item-Based Control 
Use an optional item binding to control the presentation and dismissal of the sheet, passing the item to the content builder.

#### 4. Customization 
Options for backdrop style, animations, content inset, and dismissal behavior.

#### 5. Dismissal Callback 
An optional closure to execute custom logic when the sheet is dismissed.

---

## Usecases
The FitHeightSheet package is ideal for specific scenarios where a sheet that adapts to its content's height is needed. 

The FitHeightSheet package is ideal for situations where:
- You need a sheet that adapts to the height of its content.
- The content within the sheet does not need to scroll.
- Showing additional options or details that fit within a specific area.

> For more information, please check out the Example directory to discover more additional usecases.

---

## Limitations

While FitHeightSheet is a powerful tool for presenting content-fitted sheets, there are scenarios where the native SwiftUI sheet might be more suitable.

#### 1. Non-Scrolling Content 
If the sheet's content exceeds the available height, the sheet will not scroll. In such cases, it's recommended to use the native SwiftUI sheet.
   
#### 2. Dynamic Height Updates
When dynamically updating the sheet's content height (e.g., expanding/collapsing text), the backdrop opacity will remain fixed instead of adjusting based on the drag offset.

#### 3. Keyboard Support 
The package does not currently support sheets with keyboard interactions. If you have an input text field inside your sheet, the backdrop opacity will become fully opaque when the keyboard is displayed.

> In above cases, please use the native SwiftUI sheet.

---

## License

MIT License

Copyright (c) 2024 Kyaw Zay Ya Lin Tun

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.