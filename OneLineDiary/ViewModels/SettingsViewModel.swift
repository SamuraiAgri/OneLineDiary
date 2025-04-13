import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var isReminderEnabled: Bool = false
    @Published var reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 21, minute: 0)) ?? Date()
    
    // UserDefaultsからの読み込み
    init() {
        self.isReminderEnabled = UserDefaults.standard.bool(forKey: "isReminderEnabled")
        if let savedTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date {
            self.reminderTime = savedTime
        }
    }
    
    // リマインダー設定の保存
    func saveReminderSettings() {
        UserDefaults.standard.set(isReminderEnabled, forKey: "isReminderEnabled")
        UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
        
        // リマインダーの設定/解除
        if isReminderEnabled {
            scheduleReminder()
        } else {
            cancelReminder()
        }
    }
    
    // リマインダーのスケジュール設定
    private func scheduleReminder() {
        // 通知の許可を要求
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // 既存の通知をキャンセル
                self.cancelReminder()
                
                // 新しい通知をセット
                let content = UNMutableNotificationContent()
                content.title = AppStrings.appName
                content.body = AppStrings.Settings.reminderMessage
                content.sound = .default
                
                // 時間コンポーネントを取得
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: self.reminderTime)
                let minute = calendar.component(.minute, from: self.reminderTime)
                
                // 毎日指定時間にトリガー
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "diaryReminder", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    // リマインダーのキャンセル
    private func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["diaryReminder"])
    }
}
