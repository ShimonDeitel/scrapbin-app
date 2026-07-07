import SwiftUI

/// Unique visual identity for Scrapbin - Material Waste Log.
enum Theme {
    static let accent = Color(red: 0.7098, green: 0.3961, blue: 0.1137)
    static let background = Color(red: 0.0941, green: 0.0745, blue: 0.0627)
    static let textPrimary = Color(red: 0.9608, green: 0.9294, blue: 0.9020)
    static let card = background.opacity(0.6)

    static let titleFont = Font.system(.title2, design: .serif).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static func statusColor(_ status: String) -> Color {
        switch status {
        case "Minor": return accent
        case "Significant": return .gray
        default: return accent.opacity(0.7)
        }
    }
}
