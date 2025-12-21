import Foundation

public extension String {
    /// Check if string is a valid email
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Check if string is empty or contains only whitespace
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Localized string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Localized string with arguments
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    /// Trim whitespace and newlines
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

