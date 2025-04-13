import SwiftUI

struct AppColors {
    // メインカラー
    static let primary = Color(hex: "#4A6572")
    static let secondary = Color(hex: "#F9AA33")
    
    // 背景カラー
    static let background = Color(hex: "#F5F5F5")
    static let cardBackground = Color.white
    
    // テキストカラー
    static let textPrimary = Color(hex: "#333333")
    static let textSecondary = Color(hex: "#666666")
    static let textTertiary = Color(hex: "#999999")
    
    // アクセントカラー
    static let accent = Color(hex: "#FF6B6B")
    
    // エラーカラー
    static let error = Color(hex: "#E53935")
    
    // 感情/ムードカラー
    static let moodColors: [String: Color] = [
        "happy": Color(hex: "#FFD580"),  // 明るい黄色
        "sad": Color(hex: "#AFDFE4"),    // 薄い青
        "angry": Color(hex: "#FF6B6B"),  // 赤
        "calm": Color(hex: "#A5D6A7"),   // 薄い緑
        "excited": Color(hex: "#FFC0CB"), // ピンク
        "tired": Color(hex: "#D8BFD8"),  // 薄い紫
        "neutral": Color(hex: "#E0E0E0") // グレー
    ]
    
    // 日記カードのバックグラウンドカラーオプション
    static let cardColors: [String] = [
        "#FFD580", "#AFDFE4", "#FF6B6B", "#A5D6A7",
        "#FFC0CB", "#D8BFD8", "#E0E0E0", "#F5F5DC",
        "#B0E0E6", "#FFE4E1", "#E6E6FA", "#F0FFF0"
    ]
}
