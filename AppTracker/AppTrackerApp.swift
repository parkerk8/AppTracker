import SwiftUI

@main
struct AppTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        print("AppTrackerApp initializing")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Application did finish launching")
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("AppDelegate - Received URL: \(url.absoluteString)")
        print("URL components: \(URLComponents(url: url, resolvingAgainstBaseURL: true)?.debugDescription ?? "nil")")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let action = components.host,
              let queryItems = components.queryItems else {
            print("Failed to parse URL components")
            return false
        }
        
        let params = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") })
        print("Parsed params: \(params)")
        
        switch action {
        case "open":
            print("Handling app opened")
            handleAppOpened(params: params)
        case "close":
            print("Handling app closed")
            handleAppClosed(params: params)
        default:
            print("Unknown action: \(action)")
            return false
        }
        
        return true
    }
    
    private func handleAppOpened(params: [String: String]) {
        print("handleAppOpened called with params: \(params)")
        guard let appName = params["app"],
              let timeString = params["time"],
              let time = Double(timeString) else {
            print("Failed to parse app opened params")
            return
        }
        
        print("Logging app opened: \(appName) at time \(time)")
        AppUsageStore.shared.logAppOpened(appName: appName, time: time)
    }
    
    private func handleAppClosed(params: [String: String]) {
        print("handleAppClosed called with params: \(params)")
        guard let appName = params["app"],
              let timeString = params["time"],
              let time = Double(timeString) else {
            print("Failed to parse app closed params")
            return
        }
        
        print("Logging app closed: \(appName) at time \(time)")
        AppUsageStore.shared.logAppClosed(appName: appName, time: time)
    }
}
