import Foundation
import FirebaseStorage
import FirebaseCore
import Core

/// Firebase Storage Service
public final class FirebaseStorageService {
    
    // MARK: - Singleton
    
    public static let shared = FirebaseStorageService()
    
    // MARK: - Properties
    
    private lazy var storage: Storage = {
        // Ensure FirebaseApp is configured
        guard FirebaseApp.app() != nil else {
            fatalError("FirebaseApp must be configured before using FirebaseStorageService. Call FirebaseApp.configure() first.")
        }
        return Storage.storage()
    }()
    
    private lazy var storageRef: StorageReference = {
        return storage.reference()
    }()
    
    // MARK: - Initialization
    
    private init() {
        // Don't initialize Storage here - wait until first access
        Logger.info("Firebase Storage Service initialized (lazy)")
    }
    
    // MARK: - Public Methods
    
    /// Upload data to storage
    public func uploadData(
        _ data: Data,
        to path: String,
        metadata: StorageMetadata? = nil,
        completion: @escaping (Result<StorageMetadata, Error>) -> Void
    ) {
        let fileRef = storageRef.child(path)
        
        var uploadMetadata = metadata ?? StorageMetadata()
        if uploadMetadata.contentType == nil {
            uploadMetadata.contentType = "application/octet-stream"
        }
        
        fileRef.putData(data, metadata: uploadMetadata) { metadata, error in
            if let error = error {
                Logger.error("Storage upload error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let metadata = metadata else {
                let error = NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No metadata returned"])
                completion(.failure(error))
                return
            }
            
            Logger.info("File uploaded successfully: \(path)")
            completion(.success(metadata))
        }
    }
    
    /// Upload file from URL
    public func uploadFile(
        from url: URL,
        to path: String,
        metadata: StorageMetadata? = nil,
        completion: @escaping (Result<StorageMetadata, Error>) -> Void
    ) {
        let fileRef = storageRef.child(path)
        
        var uploadMetadata = metadata ?? StorageMetadata()
        if uploadMetadata.contentType == nil {
            uploadMetadata.contentType = "application/octet-stream"
        }
        
        fileRef.putFile(from: url, metadata: uploadMetadata) { metadata, error in
            if let error = error {
                Logger.error("Storage upload error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let metadata = metadata else {
                let error = NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No metadata returned"])
                completion(.failure(error))
                return
            }
            
            Logger.info("File uploaded successfully: \(path)")
            completion(.success(metadata))
        }
    }
    
    /// Download data from storage
    public func downloadData(
        from path: String,
        maxSize: Int64 = 10 * 1024 * 1024, // 10MB default
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let fileRef = storageRef.child(path)
        
        fileRef.getData(maxSize: maxSize) { data, error in
            if let error = error {
                Logger.error("Storage download error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(error))
                return
            }
            
            Logger.info("File downloaded successfully: \(path)")
            completion(.success(data))
        }
    }
    
    /// Download file to URL
    public func downloadFile(
        from path: String,
        to url: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let fileRef = storageRef.child(path)
        
        fileRef.write(toFile: url) { url, error in
            if let error = error {
                Logger.error("Storage download error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let url = url else {
                let error = NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No URL returned"])
                completion(.failure(error))
                return
            }
            
            Logger.info("File downloaded successfully: \(path)")
            completion(.success(url))
        }
    }
    
    /// Get download URL
    public func getDownloadURL(
        for path: String,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let fileRef = storageRef.child(path)
        
        fileRef.downloadURL { url, error in
            if let error = error {
                Logger.error("Get download URL error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let url = url else {
                let error = NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No URL returned"])
                completion(.failure(error))
                return
            }
            
            completion(.success(url))
        }
    }
    
    /// Delete file
    public func deleteFile(
        at path: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let fileRef = storageRef.child(path)
        
        fileRef.delete { error in
            if let error = error {
                Logger.error("Storage delete error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            Logger.info("File deleted successfully: \(path)")
            completion(.success(()))
        }
    }
    
    /// Get reference to a path
    public func reference(for path: String) -> StorageReference {
        return storageRef.child(path)
    }
}

