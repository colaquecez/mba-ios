//
//  Purchase.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 18/11/21.
//

import Foundation
import UIKit

class Purchase: Identifiable, ObservableObject {
    @Published var name: String
    @Published var state: State
    @Published var value: Float
    @Published var isCard: Bool
    @Published var sku: String
    @Published var image: Data
    
    init(name:String, state: State, value: Float, isCard: Bool, sku: String, image: Data) {
        self.name = name
        self.state = state
        self.value = value
        self.isCard = isCard
        self.sku = sku
        self.image = image
}
}
