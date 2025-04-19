import SwiftUI

struct NewEntryView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel: EntryViewModel
    @State private var showingAlert = false
    
    var onDismiss: () -> Void
    
    init(initialDate: Date? = nil, onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        self._viewModel = StateObject(wrappedValue: EntryViewModel(date: initialDate))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // コンテンツエリア
                        contentInputView
                        
                        // 気分セレクター
                        moodSelectorView
                        
                        // 色選択
                        colorSelectorView
                    }
                    .padding()
                }
            }
            .navigationTitle(AppStrings.Entry.newTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppStrings.Entry.cancelButton) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppStrings.Entry.saveButton) {
                        saveEntry()
                    }
                    .disabled(viewModel.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(AppStrings.Errors.generalError),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // 日記本文入力エリア
    private var contentInputView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.selectedDate.formattedString())
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textTertiary)
            
            ZStack(alignment: .topLeading) {
                if viewModel.content.isEmpty {
                    Text(AppStrings.Entry.contentPlaceholder)
                        .foregroundColor(AppColors.textTertiary)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                
                TextEditor(text: $viewModel.content)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                    .frame(minHeight: 150)
                    .cornerRadius(8)
                    .padding(0)
                    .background(Color.clear)
            }
        }
        .padding()
        .background(Color(hex: viewModel.selectedColorHex).opacity(0.7))
        .cornerRadius(12)
    }
    
    // 気分セレクター
    private var moodSelectorView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppStrings.Entry.moodLabel)
                .font(AppFonts.bodyBold)
                .foregroundColor(AppColors.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.moodOptions, id: \.id) { mood in
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(AppColors.moodColors[mood.id] ?? Color.gray)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: moodIcon(for: mood.id))
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            }
                            .overlay(
                                Circle()
                                    .stroke(viewModel.selectedMood == mood.id ? AppColors.primary : Color.clear, lineWidth: 2)
                            )
                            
                            Text(mood.name)
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .onTapGesture {
                            viewModel.selectedMood = mood.id
                        }
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
    
    // 色選択
    private var colorSelectorView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppStrings.Entry.colorLabel)
                .font(AppFonts.bodyBold)
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 15) {
                ForEach(AppColors.cardColors, id: \.self) { colorHex in
                    Circle()
                        .fill(Color(hex: colorHex))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(viewModel.selectedColorHex == colorHex ? AppColors.primary : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            viewModel.selectedColorHex = colorHex
                        }
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
    
    // 保存処理
    private func saveEntry() {
        let success = viewModel.save()
        
        if success {
            onDismiss()
            presentationMode.wrappedValue.dismiss()
        } else {
            showingAlert = true
        }
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
