import SwiftUI

@main
struct OneLineDiaryApp: App {
    // PersistenceControllerを明示的に参照
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(AppStrings.Navigation.home, systemImage: "house.fill")
                }
            
            CalendarView()
                .tabItem {
                    Label(AppStrings.Navigation.calendar, systemImage: "calendar")
                }
            
            SettingsView()
                .tabItem {
                    Label(AppStrings.Navigation.settings, systemImage: "gear")
                }
        }
        .accentColor(AppColors.primary)
    }
}
