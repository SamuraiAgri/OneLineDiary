import SwiftUI

struct DiaryEntryRow: View {
    let entry: DiaryEntryEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(entry.date?.relativeTimeString ?? "")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textTertiary)
                
                Spacer()
                
                moodView
            }
            
            Text(entry.content ?? "")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(3)
                .padding(.bottom, 5)
        }
        .padding()
        .background(Color(hex: entry.colorHex ?? "#FFFFFF").opacity(0.7))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var moodView: some View {
        HStack {
            Text(AppStrings.Moods.localizedName(for: entry.mood ?? "neutral"))
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary)
            
            Image(systemName: moodIcon)
                .foregroundColor(moodColor)
        }
    }
    
    private var moodIcon: String {
        switch entry.mood {
        case "happy": return "face.smiling"
        case "sad": return "face.sad"
        case "angry": return "face.angry"
        case "calm": return "face.relaxed"
        case "excited": return "star.fill"
        case "tired": return "zzz"
        case "neutral", _: return "face.neutral"
        }
    }
    
    private var moodColor: Color {
        AppColors.moodColors[entry.mood ?? "neutral"] ?? Color.gray
    }
}
