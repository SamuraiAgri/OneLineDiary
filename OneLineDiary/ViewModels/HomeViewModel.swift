import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var entries: [DiaryEntryEntity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchEntries()
    }
    
    func fetchEntries() {
        isLoading = true
        DispatchQueue.main.async {
            self.entries = self.coreDataManager.fetchAllEntries()
            self.isLoading = false
        }
    }
    
    func deleteEntry(at indexSet: IndexSet) {
        for index in indexSet {
            let entry = entries[index]
            let success = coreDataManager.deleteEntry(entry: entry)
            
            if !success {
                self.errorMessage = AppStrings.Errors.deleteFailed
            }
        }
        
        // 削除後にリストを更新
        fetchEntries()
    }
    
    func groupedEntries() -> [String: [DiaryEntryEntity]] {
        let calendar = Calendar.current
        
        return Dictionary(grouping: entries) { entry in
            if calendar.isDateInToday(entry.date ?? Date()) {
                return AppStrings.Home.today
            } else if calendar.isDateInYesterday(entry.date ?? Date()) {
                return AppStrings.Home.yesterday
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                formatter.locale = Locale(identifier: "ja_JP")
                return formatter.string(from: entry.date ?? Date())
            }
        }
    }
    
    // 検索機能
    func searchEntries(with text: String) {
        if text.isEmpty {
            fetchEntries()
        } else {
            DispatchQueue.main.async {
                self.entries = self.coreDataManager.searchEntries(with: text)
            }
        }
    }
}
