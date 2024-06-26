# Limitations

While FitHeightSheet is a powerful tool for presenting content-fitted sheets, there are scenarios where the native SwiftUI sheet might be more suitable.

@Metadata {
    @PageImage(purpose: card, source: "limitation", alt: "Orange traffic cone, as a warning.")
}


### 1. Non-Scrolling Content 
If the sheet's content exceeds the available height, the sheet will not scroll. In such cases, it's recommended to use the native SwiftUI sheet.
   
### 2. Dynamic Height Updates
When dynamically updating the sheet's content height (e.g., expanding/collapsing text), the backdrop opacity will remain fixed instead of adjusting based on the drag offset.

### 3. Keyboard Support 
The package does not currently support sheets with keyboard interactions. If you have an input text field inside your sheet, the backdrop opacity will become fully opaque when the keyboard is displayed.

**In above cases, please use the native SwiftUI sheet.**
