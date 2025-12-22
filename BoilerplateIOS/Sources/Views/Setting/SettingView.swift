import SwiftUI
import Core

struct SettingView: View {
    @ObservedObject var viewModel: SettingViewModel
    
    // Initializer to allow dependency injection
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section(header: Text("General")) {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.gray)
                    Text("Terms of Service")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Preferences")) {
                HStack {
                    Image(systemName: "bell")
                        .foregroundColor(.red)
                    Toggle("Notifications", isOn: .constant(true))
                }
                
                HStack {
                    Image(systemName: "moon")
                        .foregroundColor(.purple)
                    Toggle("Dark Mode", isOn: .constant(false))
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.dismissSettings()
                }
            }
        }
    }
}

#Preview {
    SettingView(viewModel: SettingViewModel())
}
