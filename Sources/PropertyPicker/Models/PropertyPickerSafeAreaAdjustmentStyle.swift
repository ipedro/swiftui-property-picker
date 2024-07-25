/// An enumeration that defines the adjustment styles for safe area insets in property picker contexts.
///
/// It specifies how a property picker should adjust its content to accommodate safe area insets,
/// ensuring that the picker does not obstruct critical parts of the user interface, such as input fields or buttons.
/// This adjustment is particularly useful in scenarios where property pickers alter the layout dynamically,
/// such as appearing as overlays or within modal presentations.
public enum PropertyPickerSafeAreaAdjustmentStyle {
    /// Adjusts the safe area insets automatically based on system guidelines and the presence of elements like keyboards
    /// or bottom bars that may overlap the property picker's content.
    case automatic

    /// Does not make any adjustments to the safe area insets, allowing the content to maintain its layout
    /// irrespective of environmental changes. This setting is suitable when the UI design specifies that elements
    /// should not react to overlaying interfaces.
    case never
}
