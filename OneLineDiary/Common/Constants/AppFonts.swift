import SwiftUI

struct AppFonts {
    // タイトルフォント
    static let largeTitle = Font.largeTitle.bold()
    static let title = Font.title.bold()
    static let title2 = Font.title2.bold()
    static let title3 = Font.title3.bold()
    
    // 本文フォント
    static let body = Font.body
    static let bodyBold = Font.body.bold()
    static let bodyItalic = Font.body.italic()
    
    // 注釈フォント
    static let footnote = Font.footnote
    static let caption = Font.caption
    static let caption2 = Font.caption2
    
    // カスタムサイズフォント
    static func custom(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight)
    }
}
