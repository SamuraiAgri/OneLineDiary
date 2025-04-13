import Foundation

struct AppStrings {
    // アプリ全般
    static let appName = "ひとこと日記"
    static let appNameEn = "OneLineDiary"
    
    // ナビゲーション
    struct Navigation {
        static let home = "ホーム"
        static let newEntry = "新規作成"
        static let settings = "設定"
        static let search = "検索"
    }
    
    // ホーム画面
    struct Home {
        static let title = "ひとこと日記"
        static let emptyState = "日記がまだありません。\n右下の+ボタンから追加しましょう。"
        static let today = "今日"
        static let yesterday = "昨日"
        static let editButton = "編集"
        static let deleteButton = "削除"
    }
    
    // 日記作成/編集画面
    struct Entry {
        static let newTitle = "新しい日記"
        static let editTitle = "日記を編集"
        static let contentPlaceholder = "今日はどんな一日でしたか？"
        static let moodLabel = "今日の気分"
        static let colorLabel = "背景色"
        static let saveButton = "保存"
        static let cancelButton = "キャンセル"
        static let deleteConfirm = "この日記を削除しますか？"
        static let deleteAction = "削除"
        static let cancelAction = "キャンセル"
    }
    
    // 設定画面
    struct Settings {
        static let title = "設定"
        static let reminderSection = "リマインダー"
        static let reminderToggle = "日記リマインダー"
        static let reminderTime = "通知時間"
        static let reminderMessage = "日記の時間です"
    }
    
    // 検索画面
    struct Search {
        static let title = "検索"
        static let placeholder = "日記を検索..."
        static let noResults = "該当する日記が見つかりませんでした"
    }
    
    // 気分/感情
    struct Moods {
        static let happy = "うれしい"
        static let sad = "かなしい"
        static let angry = "いかり"
        static let calm = "おちつき"
        static let excited = "わくわく"
        static let tired = "つかれた"
        static let neutral = "ふつう"
        
        static func localizedName(for mood: String) -> String {
            switch mood {
            case "happy": return happy
            case "sad": return sad
            case "angry": return angry
            case "calm": return calm
            case "excited": return excited
            case "tired": return tired
            case "neutral": return neutral
            default: return neutral
            }
        }
    }
    
    // エラーメッセージ
    struct Errors {
        static let generalError = "エラーが発生しました"
        static let emptyContent = "日記の内容を入力してください"
        static let saveFailed = "保存に失敗しました"
        static let loadFailed = "データの読み込みに失敗しました"
        static let deleteFailed = "削除に失敗しました"
    }
}
