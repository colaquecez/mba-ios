//
//  State.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 18/11/21.
//

import Foundation

class States: Identifiable, ObservableObject {
    @Published var name: String
    
    init(name:String) {
        self.name = name
    }
}
