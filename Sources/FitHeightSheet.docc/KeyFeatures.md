# KeyFeatures

The fitHeightSheet function allows you to present a sheet that dynamically adjusts its height based on the content it contains. This is particularly useful when the content does not need to scroll and you want a more compact and visually appealing presentation. While the FitHeightSheet package is not intended to replace the native SwiftUI sheet, it complements it by addressing specific use cases where a content-fitted sheet is more appropriate.

## Key Features:

- Adaptive Height: The sheet adjusts its height to fit the content, ensuring a seamless user experience.
- Customization: Options for backdrop style, animations, content inset, and dismissal behavior.
- State-Based Control: Use a boolean binding to control the presentation and dismissal of the sheet.
- Item-Based Control: Use an optional item binding to control the presentation and dismissal of the sheet, passing the item to the content builder.
- Dismissal Callback: An optional closure to execute custom logic when the sheet is dismissed.
