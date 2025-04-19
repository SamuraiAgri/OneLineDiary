import SwiftUI
import Combine

class CalendarViewModel: ObservableObject {
    @Published var entries: [Date: DiaryEntryEntity] = [:]
    @Published var selectedDate: Date = Date()
    @Published var isLoading: Bool = false
    
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchEntries()
    }
    
    func fetchEntries() {
        isLoading = true
        DispatchQueue.main.async {
            let allEntries = self.coreDataManager.fetchAllEntries()
            
            // 日付ごとにエントリーを整理
            self.entries = Dictionary(uniqueKeysWithValues: allEntries.compactMap { entry in
                guard let date = entry.date, let id = entry.id else { return nil }
                
                // 同じ日に複数のエントリーがある場合は、最新のものを優先
                let calendar = Calendar.current
                let dateOnly = calendar.startOfDay(for: date)
                
                if let existingEntry = self.entries[dateOnly],
                   let existingDate = existingEntry.updatedAt,
                   let newDate = entry.updatedAt,
                   existingDate > newDate {
                    return nil
                }
                
                return (dateOnly, entry)
            })
            
            self.isLoading = false
        }
    }
    
    func getEntry(for date: Date) -> DiaryEntryEntity? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return entries[startOfDay]
    }
    
    func hasEntry(for date: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return entries[startOfDay] != nil
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
    }
}
