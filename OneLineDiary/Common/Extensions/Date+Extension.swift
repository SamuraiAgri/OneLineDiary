import Foundation

extension Date {
    func formattedString(format: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    var isThisWeek: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: today)!
        return self >= weekAgo && self <= today
    }
    
    var isThisMonth: Bool {
        let calendar = Calendar.current
        return calendar.component(.month, from: self) == calendar.component(.month, from: Date()) &&
               calendar.component(.year, from: self) == calendar.component(.year, from: Date())
    }
    
    var relativeTimeString: String {
        if isToday {
            return AppStrings.Home.today
        } else if isYesterday {
            return AppStrings.Home.yesterday
        } else if isThisWeek {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            formatter.locale = Locale(identifier: "ja_JP")
            return formatter.string(from: self)
        } else if isThisMonth {
            let formatter = DateFormatter()
            formatter.dateFormat = "d日"
            formatter.locale = Locale(identifier: "ja_JP")
            return formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "M月d日"
            formatter.locale = Locale(identifier: "ja_JP")
            return formatter.string(from: self)
        }
    }
}
