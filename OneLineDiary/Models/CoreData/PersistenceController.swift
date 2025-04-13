import CoreData

struct PersistenceController {
    // シングルトンインスタンスの定義
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // inMemoryパラメータの型を明示的に指定
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "OneLineDiary")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // プレビュー用のインスタンス
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // CoreDataモデルを作成した後にこのサンプルデータを有効にしてください
        // サンプルデータの作成
        /*
        for i in 0..<10 {
            let newEntry = DiaryEntryEntity(context: viewContext)
            newEntry.id = UUID()
            newEntry.content = "サンプル日記エントリー \(i+1)"
            newEntry.date = Date().addingTimeInterval(-Double(i * 86400))
            newEntry.mood = ["happy", "sad", "neutral"].randomElement()!
            newEntry.colorHex = ["#FFD580", "#AFDFE4", "#FFC0CB", "#D8BFD8"].randomElement()!
            newEntry.createdAt = Date()
            newEntry.updatedAt = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        */
        
        return controller
    }()
}
