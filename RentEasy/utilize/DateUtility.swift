import Foundation

class DateUtility {

    // Function to get a human-readable date string
    static func timeAgoSinceDate(_ date: Date, currentDate: Date = Date()) -> String {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: date, to: currentDate)

        if let day = dateComponents.day, day > 0 {
            return "\(day) day\(day > 1 ? "s" : "") ago"
        }
        if let hour = dateComponents.hour, hour > 0 {
            return "\(hour) hour\(hour > 1 ? "s" : "") ago"
        }
        if let minute = dateComponents.minute, minute > 0 {
            return "\(minute) minute\(minute > 1 ? "s" : "") ago"
        }
        if let second = dateComponents.second, second > 0 {
            return "\(second) second\(second > 1 ? "s" : "") ago"
        }
        return "Just now"
    }

    // Function to convert ISO8601 date string to Date
    static func dateFromISO8601String(_ isoString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: isoString)
    }

    // Function to get a formatted date string
    static func formattedDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        return formatter.string(from: date)
    }
}
