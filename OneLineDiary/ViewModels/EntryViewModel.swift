import SwiftUI
import Combine

class EntryViewModel: ObservableObject {
    @Published var content: String = ""
    @Published var selectedMood: String = "neutral"
    @Published var selectedColorHex: String = AppColors.cardColors[0]
    @Published var selectedDate: Date = Date()
    @Published var errorMessage: String? = nil
    @Published var isSaving: Bool = false
    
    private let coreDataManager = CoreDataManager.shared
    private var editingEntry: DiaryEntryEntity?
    
    var isEditing: Bool {
        return editingEntry != nil
    }
    
    var moodOptions: [(id: String, name: String)] {
        return [
            ("happy", AppStrings.Moods.happy),
            ("sad", AppStrings.Moods.sad),
            ("angry", AppStrings.Moods.angry),
            ("calm", AppStrings.Moods.calm),
            ("excited", AppStrings.Moods.excited),
            ("tired", AppStrings.Moods.tired),
            ("neutral", AppStrings.Moods.neutral)
        ]
    }
    
    init(entry: DiaryEntryEntity? = nil, date: Date? = nil) {
        if let entry = entry {
            self.editingEntry = entry
            self.content = entry.content ?? ""
            self.selectedMood = entry.mood ?? "neutral"
            self.selectedColorHex = entry.colorHex ?? AppColors.cardColors[0]
            if let entryDate = entry.date {
                self.selectedDate = entryDate
            }
        } else if let date = date {
            self.selectedDate = date
        }
    }
    
    func save() -> Bool {
        if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = AppStrings.Errors.emptyContent
            return false
        }
        
        isSaving = true
        defer { isSaving = false }
        
        if let editingEntry = editingEntry {
            // 既存エントリの更新
            let success = coreDataManager.updateEntry(
                entry: editingEntry,
                content: content,
                mood: selectedMood,
                colorHex: selectedColorHex
            )
            
            if !success {
                errorMessage = AppStrings.Errors.saveFailed
                return false
            }
        } else {
            // 新規エントリの作成（指定日付で）
            let newEntry = coreDataManager.addEntry(
                content: content,
                mood: selectedMood,
                colorHex: selectedColorHex,
                date: selectedDate
            )
            
            if newEntry == nil {
                errorMessage = AppStrings.Errors.saveFailed
                return false
            }
        }
        
        return true
    }
    
    func delete() -> Bool {
        guard let entry = editingEntry else { return false }
        
        let success = coreDataManager.deleteEntry(entry: entry)
        if !success {
            errorMessage = AppStrings.Errors.deleteFailed
        }
        
        return success
    }
    
    func reset() {
        content = ""
        selectedMood = "neutral"
        selectedColorHex = AppColors.cardColors[0]
        errorMessage = nil
    }
}
