//
//  PasswordManager.swift
//  PasswordManager-CLI
//
//  Created by Matthew Alcasabas on 7/27/24.
//

import Foundation

class PasswordLibrary {
    // initialize an empty array to hold PasswordEntry objects
    private var entries: [PasswordEntry] = []
    // URL for the file path of the current password library file (optional)
    private var storageURL: URL?
    
    // save the entries to a JSON file, after updating the array
    private func saveEntries() {
        // TODO: encode the entries as a JSON, then save it to the URL
    }
    
    func addEntry(siteName: String, username: String, password: String) {
        // create a new PasswordEntry with the given site name, username, password
        let newEntry = PasswordEntry(siteName: siteName, username: username, password: password)
        // add this entry to the entries array
        entries.append(newEntry)
    }
    
    // delete an entry from the array using the given UUID
    func removeEntry(by id: UUID) {
        // remove the entry that matches the given UUID
        entries.removeAll {
            $0.id == id
        }
    }
    
    func listEntries() {
        // TODO: print out all password entries to the console
    }
    
    func loadLibrary() {
        // TODO: load a password library file from disk
    }
    
    func saveLibrary() {
        // TODO: save a password library file to disk
    }
}
