//
//  PasswordEntry.swift
//  PasswordManager
//
//  Created by Matthew Alcasabas on 7/27/24.
//

import Foundation

struct PasswordEntry: Identifiable, Codable {
    // Identifiable: requires an "id" field which can help to identify a specific ID for this PasswordEntry
    // Codable: can encode/decode into different formats (e.g. JSON, etc.)
    var id: UUID
    var siteName: String
    var username: String
    var password: String
    
    // constructor: create a new PasswordEntry and generate a UUID
    init(siteName: String, username: String, password: String) {
        self.id = UUID()
        self.siteName = siteName
        self.username = username
        self.password = password
    }
}
