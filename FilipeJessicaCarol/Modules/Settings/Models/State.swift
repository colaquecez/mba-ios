//
//  State.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 18/11/21.
//

import Foundation

class States: Identifiable, ObservableObject {
    @Published var name: String
    @Published var taxes: Float
    @Published var id: String
    
    init(name:String, taxes: Float, id: String ) {
        self.name = name
        self.taxes = taxes
        self.id = id
    }
}
