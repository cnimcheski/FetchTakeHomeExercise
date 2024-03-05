//
//  Item.swift
//  FetchTakeHomeExercise
//
//  Created by Steve Nimcheski on 3/4/24.
//

import SwiftUI

struct Item: Identifiable, Codable {
    let id: Int
    let listId: Int
    let name: String?
    
    var unwrappedName: String {
        name ?? ""
    }
}
