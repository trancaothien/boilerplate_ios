import SwiftUI
import Core

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
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
                        // ModalConfiguration Demo Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ModalConfiguration Demo")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            VStack(spacing: 8) {
                                ModalDemoButton(
                                    title: "Page Sheet Modal",
                                    icon: "rectangle.bottomthird.inset",
                                    color: .blue
                                ) {
                                    viewModel.showPageSheetModal()
                                }
                                
                                ModalDemoButton(
                                    title: "Full Screen Modal",
                                    icon: "rectangle.fill",
                                    color: .green
                                ) {
                                    viewModel.showFullScreenModal()
                                }
                                
                                ModalDemoButton(
                                    title: "Form Sheet Modal",
                                    icon: "rectangle.portrait",
                                    color: .orange
                                ) {
                                    viewModel.showFormSheetModal()
                                }
                                
                                ModalDemoButton(
                                    title: "Custom Modal",
                                    icon: "slider.horizontal.3",
                                    color: .purple
                                ) {
                                    viewModel.showCustomModal()
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)
                        
                        // Params Passing Demo Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Truyền Params Demo")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Các loại params có thể truyền:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    ParamTypeRow(type: "String", example: "itemName")
                                    ParamTypeRow(type: "Int", example: "itemId")
                                    ParamTypeRow(type: "Bool", example: "isFavorite")
                                    ParamTypeRow(type: "Date", example: "createdDate")
                                    ParamTypeRow(type: "Custom Object", example: "ItemMetadata")
                                }
                                .padding(.leading)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(AppConstants.UI.defaultCornerRadius)
                            .padding(.horizontal)
                        }
                        
                        // Items Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Items (Click để xem cách truyền params)")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.items) { item in
                                Button {
                                    // Truyền params từ Home sang Detail
                                    viewModel.showDetail(for: item)
                                } label: {
                                    HomeItemCard(
                                        title: item.name,
                                        isFavorite: item.isFavorite
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
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
        .loading(viewModel.isLoading)
        .errorAlert(errorMessage: $viewModel.errorMessage)
    }
}

struct HomeItemCard: View {
    let title: String
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isFavorite ? "star.fill" : "circle.fill")
                .foregroundColor(isFavorite ? .yellow : .blue)
                .font(.system(size: 12))
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
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

struct ModalDemoButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
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
}

struct ModalDemoView: View {
    let title: String
    let description: String
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Cách sử dụng ModalConfiguration:")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            CodeBlock(code: """
// Trong Coordinator:
func showModal() {
    let view = MyView()
    present(view, configuration: .pageSheet)
}

// Các style có sẵn:
- .default
- .pageSheet (bottom sheet)
- .fullScreen
- .formSheet

// Custom configuration:
let config = ModalConfiguration(
    presentationStyle: .pageSheet,
    transitionStyle: .flipHorizontal,
    isModalInPresentation: true
)
present(view, configuration: config)
""")
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        onDismiss()
                    }
                }
            }
        }
    }
}

struct CodeBlock: View {
    let code: String
    
    var body: some View {
        Text(code)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

struct ParamTypeRow: View {
    let type: String
    let example: String
    
    var body: some View {
        HStack {
            Text("•")
                .foregroundColor(.blue)
            Text(type)
                .font(.caption)
                .fontWeight(.medium)
            Text("(\(example))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    HomeView()
}

