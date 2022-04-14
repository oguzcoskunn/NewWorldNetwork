//
//  QuestionAnswerViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI

class QuestionAnswerViewModel: ObservableObject {
    @Published var questions = [Question]()
    @Published var users = [User]()
    
    init() {
        fetchQuestions()
        fetchUsers()
    }
    
    func fetchQuestions() {
        COLLECTION_QUESTIONS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.questions = documents.map({ Question(dictionary: $0.data()) })
            self.questions.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        }
    }
    
    func fetchUsers() {
        COLLECTION_USERS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let users = documents.map({ User(dictionary: $0.data()) })
            self.users = users
        }
    }
    
    func filterQuestions(_ title: String, _ game: String) -> [Question] {
        if !title.isEmpty && !game.isEmpty {
            let lowerTitle = title.lowercased()
            let result = questions.filter({ $0.title.lowercased().contains(lowerTitle) })
            
            let lowerGame = game.lowercased()
            let finalResult = result.filter({ $0.gameName.lowercased().contains(lowerGame) })
            return finalResult.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
        } else if !title.isEmpty {
            let lowerTitle = title.lowercased()
            let result = questions.filter({ $0.title.lowercased().contains(lowerTitle) })
            return result.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
        } else if !game.isEmpty {
            let lowerGame = game.lowercased()
            let result = questions.filter({ $0.gameName.lowercased().contains(lowerGame) })
            return result.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
        } else {
            return questions
        }
        
    }
}
