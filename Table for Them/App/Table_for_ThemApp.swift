import SwiftUI
import FirebaseCore

@main
struct Table_for_ThemApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var accountManager: AccountManager
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch accountManager.viewToShow {
                    case .loading:
                        ProgressView()
                    case .signIn:
                        SignInUpHomeView()
                    case .createRestaurant:
                        OnboardingView()
                    case .main:
                        ContentView()
                    case .error:
                        AccountManagementErrorView(accountManager: accountManager)
                }
            }
        }
    }
    
    init() {
        self._accountManager = StateObject(wrappedValue: AccountManager.shared)
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
