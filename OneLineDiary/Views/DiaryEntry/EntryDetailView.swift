import SwiftUI

struct EntryDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel: EntryViewModel
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    @State private var showingErrorAlert = false
    
    let entry: DiaryEntryEntity
    var onDismiss: () -> Void
    
    init(entry: DiaryEntryEntity, onDismiss: @escaping () -> Void) {
        self.entry = entry
        self.onDismiss = onDismiss
        self._viewModel = StateObject(wrappedValue: EntryViewModel(entry: entry))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 日付表示
                        HStack {
                            Text(entry.date?.formattedString() ?? "")
                                .font(AppFonts.title3)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Spacer()
                            
                            HStack {
                                Text(AppStrings.Moods.localizedName(for: isEditing ? viewModel.selectedMood : (entry.mood ?? "neutral")))
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Image(systemName: moodIcon(for: isEditing ? viewModel.selectedMood : (entry.mood ?? "neutral")))
                                    .foregroundColor(AppColors.moodColors[isEditing ? viewModel.selectedMood : (entry.mood ?? "neutral")] ?? Color.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        // コンテンツエリア
                        if isEditing {
                            editContentView
                        } else {
                            displayContentView
                        }
                        
                        if isEditing {
                            VStack(spacing: 20) {
                                // 気分セレクター
                                moodSelectorView
                                
                                // 色選択
                                colorSelectorView
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(isEditing ? AppStrings.Entry.editTitle : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(isEditing ? AppStrings.Entry.cancelButton : "") {
                        if isEditing {
                            // 編集キャンセル
                            isEditing = false
                            viewModel.content = entry.content ?? ""
                            viewModel.selectedMood = entry.mood ?? "neutral"
                            viewModel.selectedColorHex = entry.colorHex ?? AppColors.cardColors[0]
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if isEditing {
                        Button(AppStrings.Entry.saveButton) {
                            saveEntry()
                        }
                        .disabled(viewModel.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    } else {
                        Menu {
                            Button {
                                isEditing = true
                            } label: {
                                Label(AppStrings.Home.editButton, systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                showingDeleteAlert = true
                            } label: {
                                Label(AppStrings.Home.deleteButton, systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .alert(AppStrings.Entry.deleteConfirm, isPresented: $showingDeleteAlert) {
                Button(AppStrings.Entry.deleteAction, role: .destructive) {
                    deleteEntry()
                }
                Button(AppStrings.Entry.cancelAction, role: .cancel) { }
            }
            .alert(isPresented: $showingErrorAlert) {
                Alert(
                    title: Text(AppStrings.Errors.generalError),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // 表示モードのコンテンツビュー
    private var displayContentView: some View {
        Text(entry.content ?? "")
            .font(AppFonts.body)
            .foregroundColor(AppColors.textPrimary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: entry.colorHex ?? "#FFFFFF").opacity(0.7))
            .cornerRadius(12)
    }
    
    // 編集モードのコンテンツビュー
    private var editContentView: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.content)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
                .frame(minHeight: 150)
                .cornerRadius(8)
                .padding(10)
        }
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
            isEditing = false
            onDismiss()
        } else {
            showingErrorAlert = true
        }
    }
    
    // 削除処理
    private func deleteEntry() {
        let success = viewModel.delete()
        
        if success {
            onDismiss()
            presentationMode.wrappedValue.dismiss()
        } else {
            showingErrorAlert = true
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
