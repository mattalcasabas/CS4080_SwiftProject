//
//  PasswordEntry.swift
//  PasswordManager-CLI
//
//  Created by Matthew Alcasabas on 7/27/24.
//

/*
 PasswordEntry.swift:
 This struct constructs a new PasswordEntry for use by PasswordLibrary.swift.
 The constructor is used to create a new entry in the manager, assigning it a new UUID using the UUID() function.
 */

import Foundation
import AppKit

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

//Copies password to clipboard
extension PasswordEntry {
    func copyPassword() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self.password, forType: .string)
    }
}

//Masks password by converting each char to a *
extension PasswordEntry {
    func maskPassword() -> String {
        var maskedPassword = ""
        for _ in self.password {
            maskedPassword += "*"
        }
        return maskedPassword
    }
}

enum passError: Error {
    case invalidLocation
}
