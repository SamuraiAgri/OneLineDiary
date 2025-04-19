import SwiftUI

struct CalendarGridView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Binding var currentMonth: Date
    @State private var showingEntrySheet = false
    @State private var showingDetailSheet = false
    @State private var selectedEntry: DiaryEntryEntity?
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["日", "月", "火", "水", "木", "金", "土"]
    
    var body: some View {
        VStack(spacing: 20) {
            // 曜日ヘッダー
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(AppFonts.caption)
                        .fontWeight(.bold)
                        .foregroundColor(day == "日" ? AppColors.accent : AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 日付グリッド
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    if date.monthInt == currentMonth.monthInt {
                        DayCell(date: date,
                                isSelected: isSameDay(date, viewModel.selectedDate),
                                hasEntry: viewModel.hasEntry(for: date))
                            .onTapGesture {
                                viewModel.selectDate(date)
                                
                                if viewModel.hasEntry(for: date) {
                                    if let entry = viewModel.getEntry(for: date) {
                                        selectedEntry = entry
                                        showingDetailSheet = true
                                    }
                                } else {
                                    showingEntrySheet = true
                                }
                            }
                    } else {
                        Text("")
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                    }
                }
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .sheet(isPresented: $showingEntrySheet) {
            NewEntryView(initialDate: viewModel.selectedDate, onDismiss: {
                viewModel.fetchEntries()
            })
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(entry: entry, onDismiss: {
                viewModel.fetchEntries()
                selectedEntry = nil
            })
        }
    }
    
    private func getDaysInMonth() -> [Date] {
        let calendar = Calendar.current
        
        let currentMonth = calendar.component(.month, from: self.currentMonth)
        let currentYear = calendar.component(.year, from: self.currentMonth)
        
        guard let startDate = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)) else {
            return []
        }
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        let firstWeekday = calendar.component(.weekday, from: startDate)
        let leadingSpaces = (firstWeekday + 6) % 7 // 日本のカレンダーは日曜始まり (1) なので調整
        
        var days: [Date] = []
        
        // 前月の日を追加
        if leadingSpaces > 0 {
            for _ in 0..<leadingSpaces {
                days.append(Date.distantPast) // プレースホルダー
            }
        }
        
        // 当月の日を追加
        for day in 1...range.count {
            if let date = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: day)) {
                days.append(date)
            }
        }
        
        // 7の倍数になるよう調整（週の最後まで表示）
        let trailingSpaces = 42 - days.count // 最大6週間分の表示
        
        if trailingSpaces > 0 && trailingSpaces < 7 {
            for _ in 0..<trailingSpaces {
                days.append(Date.distantFuture) // プレースホルダー
            }
        }
        
        return days
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

// 日付セル
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasEntry: Bool
    
    private var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 45, height: 45)
            
            VStack(spacing: 4) {
                Text(day)
                    .font(AppFonts.bodyBold)
                    .foregroundColor(textColor)
                
                if hasEntry {
                    Circle()
                        .fill(AppColors.secondary)
                        .frame(width: 5, height: 5)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 5, height: 5)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 45)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppColors.primary
        } else if isToday {
            return AppColors.secondary.opacity(0.3)
        } else {
            return Color.clear
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if Calendar.current.component(.weekday, from: date) == 1 { // 日曜日
            return AppColors.accent
        } else {
            return AppColors.textPrimary
        }
    }
}

// 月の取得用拡張
extension Date {
    var monthInt: Int {
        return Calendar.current.component(.month, from: self)
    }
}
