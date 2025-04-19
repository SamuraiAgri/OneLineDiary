import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingNewEntrySheet = false
    @State private var searchText = ""
    @State private var selectedEntry: DiaryEntryEntity?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack {
                    // 検索バー
                    searchBar
                    
                    if viewModel.entries.isEmpty {
                        emptyStateView
                    } else {
                        entriesList
                    }
                }
                .navigationTitle(AppStrings.Home.title)
                // toolbarの曖昧さを解消するために具体的な実装に変更
                .navigationBarItems(trailing:
                    Button {
                        viewModel.fetchEntries()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                )
            }
            .overlay(
                newEntryButton
                    .padding(),
                alignment: .bottomTrailing
            )
            .sheet(isPresented: $showingNewEntrySheet) {
                NewEntryView(onDismiss: {
                    viewModel.fetchEntries()
                })
            }
            .sheet(item: $selectedEntry) { entry in
                EntryDetailView(entry: entry, onDismiss: {
                    viewModel.fetchEntries()
                    selectedEntry = nil
                })
            }
            // iOS 17に依存しない形式に変更
            .onChange(of: searchText) { newValue in
                viewModel.searchEntries(with: newValue)
            }
        }
    }
    
    // 以下のコードは同じまま
    // 検索バー
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textTertiary)
            
            TextField(AppStrings.Search.placeholder, text: $searchText)
                .font(AppFonts.body)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textTertiary)
                }
            }
        }
        .padding(8)
        .background(AppColors.cardBackground)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    // エントリーリスト
    private var entriesList: some View {
        List {
            ForEach(Array(viewModel.groupedEntries().keys.sorted().reversed()), id: \.self) { dateKey in
                Section(header: Text(dateKey).font(AppFonts.footnote)) {
                    ForEach(viewModel.groupedEntries()[dateKey] ?? [], id: \.id) { entry in
                        DiaryEntryRow(entry: entry)
                            .onTapGesture {
                                selectedEntry = entry
                            }
                            .listRowBackground(Color.clear)
                    }
                    .onDelete { indexSet in
                        let entriesToDelete = indexSet.map { viewModel.groupedEntries()[dateKey]![$0] }
                        for entry in entriesToDelete {
                            _ = CoreDataManager.shared.deleteEntry(entry: entry)
                        }
                        viewModel.fetchEntries()
                    }
                }
                .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    // 空の状態ビュー
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textTertiary)
            
            Text(AppStrings.Home.emptyState)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
    
    // 新規エントリー追加ボタン
    private var newEntryButton: some View {
        Button {
            showingNewEntrySheet = true
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(AppColors.secondary)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}
