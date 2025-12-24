import SwiftUI
import Core

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Chi tiết Item")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Đây là màn hình nhận params từ màn hình Home")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                Divider()
                
                // Params Display Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Params đã nhận:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // String param
                    ParamCard(
                        title: "Item Name (String)",
                        value: viewModel.itemName,
                        icon: "textformat",
                        color: .blue
                    )
                    
                    // Int param
                    ParamCard(
                        title: "Item ID (Int)",
                        value: "\(viewModel.itemId)",
                        icon: "number",
                        color: .green
                    )
                    
                    // Bool param
                    ParamCard(
                        title: "Is Favorite (Bool)",
                        value: viewModel.isFavorite ? "true" : "false",
                        icon: "star.fill",
                        color: .orange
                    )
                    
                    // Date param
                    ParamCard(
                        title: "Created Date (Date)",
                        value: viewModel.createdDate.formatted(date: .abbreviated, time: .shortened),
                        icon: "calendar",
                        color: .purple
                    )
                    
                    // Custom Object param
                    if let metadata = viewModel.metadata {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.red)
                                Text("Metadata (Custom Object)")
                                    .font(.headline)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Category: \(metadata.category)")
                                Text("Tags: \(metadata.tags.joined(separator: ", "))")
                                Text("Priority: \(metadata.priority)")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .cornerRadius(AppConstants.UI.defaultCornerRadius)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                
                Divider()
                
                // Code Example Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Cách truyền params:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    DetailCodeBlock(code: """
// 1. Trong ViewModel (HomeViewModel):
func showDetail(for item: Item) {
    coordinator?.showDetail(
        itemName: item.name,
        itemId: item.id,
        isFavorite: item.isFavorite,
        createdDate: item.createdDate,
        metadata: item.metadata
    )
}

// 2. Trong Coordinator (HomeCoordinator):
func showDetail(
    itemName: String,
    itemId: Int,
    isFavorite: Bool,
    createdDate: Date,
    metadata: ItemMetadata?
) {
    let detailCoordinator = DetailCoordinator(
        navigationController: navigationController,
        parentCoordinator: self,
        itemName: itemName,
        itemId: itemId,
        isFavorite: isFavorite,
        createdDate: createdDate,
        metadata: metadata
    )
    addChildCoordinator(detailCoordinator)
    detailCoordinator.start()
}

// 3. Trong Coordinator nhận params (DetailCoordinator):
override func start() {
    let viewModel = DetailViewModel(
        itemName: itemName,
        itemId: itemId,
        isFavorite: isFavorite,
        createdDate: createdDate,
        metadata: metadata
    )
    viewModel.coordinator = self
    let detailView = DetailView(viewModel: viewModel)
    push(detailView)
}

// 4. Trong ViewModel nhận params (DetailViewModel):
init(
    itemName: String,
    itemId: Int,
    isFavorite: Bool,
    createdDate: Date,
    metadata: ItemMetadata?
) {
    self.itemName = itemName
    self.itemId = itemId
    // ...
}
""")
                }
                .padding()
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ParamCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 18))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(AppConstants.UI.defaultCornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct DetailCodeBlock: View {
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

#Preview {
    NavigationView {
        DetailView(viewModel: DetailViewModel(
            itemName: "Sample Item",
            itemId: 123,
            isFavorite: true,
            createdDate: Date(),
            metadata: ItemMetadata(
                category: "Demo",
                tags: ["tag1", "tag2"],
                priority: "High"
            )
        ))
    }
}

