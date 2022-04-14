//
//  SearchViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 24.08.2021.
//

import SwiftUI
import Firebase

enum SearchViewModelConfiguration {
    case search
    case newMessage
}

class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    private let config: SearchViewModelConfiguration
    
    init(config: SearchViewModelConfiguration) {
        self.config = config
        fetchUsers(forConfig: config)
    }
    
    func fetchUsers(forConfig config: SearchViewModelConfiguration) {
        COLLECTION_USERS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let users = documents.map({ User(dictionary: $0.data()) })
            
            switch config {
            case .newMessage:
                self.users = users.filter({ !$0.isCurrentUser })
                self.users = self.users.sorted { $0.fullname < $1.fullname }
            case .search:
                self.users = users
                self.users = self.users.sorted { $0.fullname < $1.fullname }
            }         
        }
    }
    
    func filteredUsers(_ query: String) -> [User] {
        let lowercasedQuery = query.lowercased()
        let result = users.filter({ $0.fullname.lowercased().contains(lowercasedQuery) || $0.username.lowercased().contains(lowercasedQuery) })
        return result.sorted { $0.fullname < $1.fullname }
    }
}
