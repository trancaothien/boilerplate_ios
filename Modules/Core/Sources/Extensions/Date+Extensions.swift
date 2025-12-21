import Foundation

public extension Date {
    /// Format date to string with default format
    func formatted(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
    /// Format date to string with style
    func formatted(style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    /// Format date to string with date and time style
    func formatted(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    /// Check if date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is yesterday
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Check if date is tomorrow
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
}

