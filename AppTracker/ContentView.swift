import SwiftUI

struct ContentView: View {
    @ObservedObject var store = AppUsageStore.shared
    @State private var lastReceivedURL: String = "None"
    
    var body: some View {
        NavigationView {
            VStack {
                List(store.usageData.values.sorted(by: { $0.totalUsageTime > $1.totalUsageTime }), id: \.name) { usage in
                    VStack(alignment: .leading) {
                        Text(usage.name)
                            .font(.headline)
                        Text("Total usage: \(formatTime(usage.totalUsageTime))")
                        Text("Sessions: \(usage.sessionCount)")
                        Text("Avg session: \(formatTime(usage.averageSessionDuration))")
                    }
                }
                
                Text("Last Received URL: \(lastReceivedURL)")
                    .padding()
                
                Button("Print Current Data") {
                    printCurrentData()
                }
                .padding()
            }
            .navigationTitle("App Usage")
        }
        .onOpenURL { url in
            print("ContentView - Received URL: \(url.absoluteString)")
            lastReceivedURL = url.absoluteString
            
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
