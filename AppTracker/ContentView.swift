import SwiftUI

struct ContentView: View {
    @ObservedObject var store = AppUsageStore.shared
    @State private var lastReceivedURL: String = "None"
    
    var body: some View {
        NavigationView {
            VStack {
                if store.usageData.isEmpty {
                    Text("No usage data available")
                        .padding()
                } else {
                    List(store.usageData.values.sorted(by: { $0.totalUsageTime > $1.totalUsageTime }), id: \.name) { usage in
                        VStack(alignment: .leading) {
                            Text(usage.name)
                                .font(.headline)
                            Text("Total usage: \(formatTime(usage.totalUsageTime))")
                            Text("Sessions: \(usage.sessionCount)")
                            Text("Avg session: \(formatTime(usage.averageSessionDuration))")
                        }
                    }
                }
                
                Text("Last Received URL: \(lastReceivedURL)")
                    .padding()
                
                Button("Print Current Data") {
                    printCurrentData()
                }
                .padding()
            }
            .navigationTitle("App Tracker")
        }
        .onOpenURL { url in
            print("ContentView - Received URL: \(url.absoluteString)")
            lastReceivedURL = url.absoluteString
            // Manually trigger URL processing
            processURL(url)
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
    
    private func printCurrentData() {
        print("Current App Usage Data:")
        for (appName, usage) in store.usageData {
            print("\(appName): Total time: \(formatTime(usage.totalUsageTime)), Sessions: \(usage.sessionCount)")
        }
    }
    
    private func processURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let action = components.host,
              let queryItems = components.queryItems else {
            print("Failed to parse URL components")
            return
        }
        
        let params = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") })
        print("Parsed params: \(params)")
        
        guard let appName = params["app"],
              let timeString = params["time"],
              let time = Double(timeString) else {
            print("Failed to parse params")
            return
        }
        
        if action == "open" {
            store.logAppOpened(appName: appName, time: time)
        } else if action == "close" {
            store.logAppClosed(appName: appName, time: time)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
