import SwiftUI
import Core

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
            VStack(spacing: 24) {
                // Avatar
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                
                // Info
                VStack(spacing: 8) {
                    Text(viewModel.username)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(viewModel.email)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                // Actions
                Button(action: {
                    viewModel.editProfile()
                }) {
                    Text("Edit Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}
