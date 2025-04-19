import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistenceController = PersistenceController.shared
    
    private init() {}
    
    // 全てのエントリーを日付順(降順)で取得
    func fetchAllEntries() -> [DiaryEntryEntity] {
        let request: NSFetchRequest<DiaryEntryEntity> = DiaryEntryEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \DiaryEntryEntity.date, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try persistenceController.container.viewContext.fetch(request)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
    
    // 特定の日付範囲のエントリーを取得
    func fetchEntries(from startDate: Date, to endDate: Date) -> [DiaryEntryEntity] {
        let request: NSFetchRequest<DiaryEntryEntity> = DiaryEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        let sortDescriptor = NSSortDescriptor(keyPath: \DiaryEntryEntity.date, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try persistenceController.container.viewContext.fetch(request)
        } catch {
            print("Error fetching entries by date range: \(error)")
            return []
        }
    }
    
    // テキスト検索
    func searchEntries(with text: String) -> [DiaryEntryEntity] {
        let request: NSFetchRequest<DiaryEntryEntity> = DiaryEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "content CONTAINS[cd] %@", text)
        let sortDescriptor = NSSortDescriptor(keyPath: \DiaryEntryEntity.date, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try persistenceController.container.viewContext.fetch(request)
        } catch {
            print("Error searching entries: \(error)")
            return []
        }
    }
    
    // 新規エントリー追加（日付指定可能）
    func addEntry(content: String, mood: String, colorHex: String, date: Date = Date()) -> DiaryEntryEntity? {
        let context = persistenceController.container.viewContext
        let newEntry = DiaryEntryEntity(context: context)
        
        newEntry.id = UUID()
        newEntry.content = content
        newEntry.date = date
        newEntry.mood = mood
        newEntry.colorHex = colorHex
        newEntry.createdAt = Date()
        newEntry.updatedAt = Date()
        
        do {
            try context.save()
            return newEntry
        } catch {
            print("Error adding entry: \(error)")
            return nil
        }
    }
    
    // エントリー更新
    func updateEntry(entry: DiaryEntryEntity, content: String, mood: String, colorHex: String) -> Bool {
        let context = persistenceController.container.viewContext
        
        entry.content = content
        entry.mood = mood
        entry.colorHex = colorHex
        entry.updatedAt = Date()
        
        do {
            try context.save()
            return true
        } catch {
            print("Error updating entry: \(error)")
            return false
        }
    }
    
    // エントリー削除
    func deleteEntry(entry: DiaryEntryEntity) -> Bool {
        let context = persistenceController.container.viewContext
        
        context.delete(entry)
        
        do {
            try context.save()
            return true
        } catch {
            print("Error deleting entry: \(error)")
            return false
        }
    }
}
