import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var currentMonth = Date()
    @State private var showingNewEntrySheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // 月選択ヘッダー
                    HStack {
                        Button {
                            changeMonth(by: -1)
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(AppColors.primary)
                        }
                        
                        Spacer()
                        
                        Text(getFormattedDate())
                            .font(AppFonts.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                        
                        Button {
                            changeMonth(by: 1)
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // カレンダーグリッド
                    CalendarGridView(viewModel: viewModel, currentMonth: $currentMonth)
                    
                    // 選択した日付の詳細表示
                    selectedDateView
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle(AppStrings.Calendar.title)
            .overlay(
                addButton
                    .padding(),
                alignment: .bottomTrailing
            )
            .sheet(isPresented: $showingNewEntrySheet) {
                NewEntryView(initialDate: viewModel.selectedDate, onDismiss: {
                    viewModel.fetchEntries()
                })
            }
            .onAppear {
                viewModel.fetchEntries()
            }
        }
    }
    
    // 選択した日付の詳細表示
    private var selectedDateView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.selectedDate.formattedString())
                .font(AppFonts.title3)
                .foregroundColor(AppColors.textPrimary)
            
            if let entry = viewModel.getEntry(for: viewModel.selectedDate) {
                HStack(alignment: .top) {
                    Text(entry.content ?? "")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(3)
                    
                    Spacer()
                    
                    VStack {
                        Text(AppStrings.Moods.localizedName(for: entry.mood ?? "neutral"))
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Image(systemName: moodIcon(for: entry.mood ?? "neutral"))
                            .foregroundColor(AppColors.moodColors[entry.mood ?? "neutral"] ?? Color.gray)
                    }
                }
                .padding()
                .background(Color(hex: entry.colorHex ?? "#FFFFFF").opacity(0.7))
                .cornerRadius(12)
            } else {
                Text(AppStrings.Calendar.noEntry)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
    
    // 新規エントリー追加ボタン
    private var addButton: some View {
        Button {
            showingNewEntrySheet = true
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(AppColors.secondary)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
    
    // 月を変更する
    private func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    // 月の表示形式
    private func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: currentMonth)
    }
    
    // 気分アイコン取得
    private func moodIcon(for mood: String) -> String {
        switch mood {
        case "happy": return "face.smiling"
        case "sad": return "face.sad"
        case "angry": return "face.angry"
        case "calm": return "face.relaxed"
        case "excited": return "star.fill"
        case "tired": return "zzz"
        case "neutral", _: return "face.neutral"
        }
    }
}
