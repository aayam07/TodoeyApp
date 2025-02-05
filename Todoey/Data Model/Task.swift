//
//  Task.swift
//  Todoey
//
//  Created by Aayam Adhikari on 03/02/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation


// for a class to conform to Encodable protocol, all of its properties must have standard data types. Custom data types like class and struct doesn't work
class Task: Codable {
    var title: String = ""
    var done: Bool = false
}
