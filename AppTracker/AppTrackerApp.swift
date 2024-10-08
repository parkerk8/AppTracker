import SwiftUI

@main
struct AppTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Received URL: \(url.absoluteString)")
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let action = components.host,
              let queryItems = components.queryItems else {
            return false
        }
        
        let params = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") }) 
        
        switch action {
        case "open":
            handleAppOpened(params: params)
        case "close":
            handleAppClosed(params: params)
        default:
            return false
        }
        
        return true
    }
    
    private func handleAppOpened(params: [String: String]) {
        guard let appName = params["app"],
              let timeString = params["time"],
              let time = Double(timeString) else {
            return
        }
        
        AppUsageStore.shared.logAppOpened(appName: appName, time: time)
    }
    
    private func handleAppClosed(params: [String: String]) {
        guard let appName = params["app"],
              let timeString = params["time"],
              let time = Double(timeString) else {
            return
        }
        
        AppUsageStore.shared.logAppClosed(appName: appName, time: time)
    }
}


