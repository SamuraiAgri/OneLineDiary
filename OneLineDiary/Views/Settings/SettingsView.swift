import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                Form {
                    // リマインダーセクション
                    Section(header: Text(AppStrings.Settings.reminderSection)) {
                        Toggle(AppStrings.Settings.reminderToggle, isOn: $viewModel.isReminderEnabled)
                            // iOS 17未満向けの形式に戻す
                            .onChange(of: viewModel.isReminderEnabled) { newValue in
                                viewModel.saveReminderSettings()
                            }
                        
                        if viewModel.isReminderEnabled {
                            DatePicker(
                                AppStrings.Settings.reminderTime,
                                selection: $viewModel.reminderTime,
                                displayedComponents: .hourAndMinute
                            )
                            // iOS 17未満向けの形式に戻す
                            .onChange(of: viewModel.reminderTime) { newValue in
                                viewModel.saveReminderSettings()
                            }
                        }
                    }
                }
            }
            .navigationTitle(AppStrings.Settings.title)
        }
    }
}
