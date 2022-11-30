//
//  Study.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/21.
//

import Foundation

class Study: Hashable {
    var id = UUID()
    var title: String
    var recommend = false
    
    init(title: String) {
        self.title = title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Study, rhs: Study) -> Bool {
        lhs.id == rhs.id
    }
}
