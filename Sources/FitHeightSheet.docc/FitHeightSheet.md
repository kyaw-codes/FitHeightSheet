# ``FitHeightSheet``

The `FitHeightSheet` package is designed to present a sheet with a height that adapts to the content it contains. It offers a tailored solution for scenarios where you need a sheet that fits precisely around its content, providing a seamless and efficient user experience.

## Overview

The fitHeightSheet function allows you to present a sheet that dynamically adjusts its height based on the content it contains. This is particularly useful when the content does not need to scroll and you want a more compact and visually appealing presentation. While the FitHeightSheet package is not intended to replace the native SwiftUI sheet, it complements it by addressing specific use cases where a content-fitted sheet is more appropriate.

## Key Features:

- Adaptive Height: The sheet adjusts its height to fit the content, ensuring a seamless user experience.
- Customization: Options for backdrop style, animations, content inset, and dismissal behavior.
- State-Based Control: Use a boolean binding to control the presentation and dismissal of the sheet.
- Item-Based Control: Use an optional item binding to control the presentation and dismissal of the sheet, passing the item to the content builder.
- Dismissal Callback: An optional closure to execute custom logic when the sheet is dismissed.


### Intended Use:
The FitHeightSheet package is ideal for situations where:

- You need a sheet that adapts to the height of its content.
- The content within the sheet does not need to scroll.
- You want a more compact and custom-fitted sheet presentation.


### Example Use Cases:
- Displaying a form that fits within the available space.
- Presenting a temporary overlay with non-scrolling content.
- Showing additional options or details that fit within a specific area.

### Important Note:
While FitHeightSheet is a powerful tool for presenting content-fitted sheets, there are scenarios where the native SwiftUI sheet might be more suitable, especially when dealing with scrolling content or more complex sheet presentations.

## Topics

### Group

- ``Symbol``
