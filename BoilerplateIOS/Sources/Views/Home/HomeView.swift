import SwiftUI
import Core

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.items.isEmpty && !viewModel.isLoading {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No items yet")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Button("Refresh") {
                            viewModel.refresh()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    // Content
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.items, id: \.self) { item in
                                HomeItemCard(title: item)
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.showSettings()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showProfile()
                    } label: {
                        Image(systemName: "person.circle")
                    }
                }
            }

        }
        .loading(viewModel.isLoading)
        .errorAlert(errorMessage: $viewModel.errorMessage)
    }
}

struct HomeItemCard: View {
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundColor(.blue)
                .font(.system(size: 12))
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(AppConstants.UI.defaultCornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
}

