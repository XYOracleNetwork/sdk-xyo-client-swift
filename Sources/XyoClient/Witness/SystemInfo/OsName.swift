import Foundation

func osName() -> String {
    #if os(iOS)
        return "iOS"
    #elseif os(macOS)
        return "macOS"
    #elseif os(watchOS)
        return "watchOS"
    #elseif os(tvOS)
        return "tvOS"
    #else
        return "unknown"
    #endif
}
