import FirebaseFirestore

extension Firestore {
    /// The current loading status of a repo.
    enum LoadingStatus: Equatable {
        case ready, loading, error(String)
    }
}
