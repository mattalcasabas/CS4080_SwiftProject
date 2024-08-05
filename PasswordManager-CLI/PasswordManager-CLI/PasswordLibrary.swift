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
    
    // initialize PasswordLibrary, or load a library from a given URL
    init(storageURL: URL? = nil) {
        self.storageURL = storageURL
        if let url = storageURL {
            loadLibrary(from: url)
        }
    }
    
    // save the entries to a JSON file, after updating the array
    private func saveEntries() {
        guard let url = storageURL else {
            print("No storage URL set.")
            return
        }
        do {
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(entries)
            try data.write(to: url)
            print("All changes saved.")
        } catch {
            // print the error if we couldn't save to library
            print("Error saving to library: \(error)")
        }
    }
    
    // load entries from a JSON file
    private func loadEntries() {
        guard let url = storageURL else {
            print("No storage URL set.")
            return
        }
        do {
            // load data from file
            let data = try Data(contentsOf: url)
            // create new JSON decoder
            let jsonDecoder = JSONDecoder()
            // decode JSON entries
            entries = try jsonDecoder.decode([PasswordEntry].self, from: data)
            print("Successfully loaded \(url).")
        } catch {
            // print the error if we couldn't save to library
            print("Error reading from library: \(error)")
        }
    }
    
    func addEntry(siteName: String, username: String, password: String) {
        // create a new PasswordEntry with the given site name, username, password
        let newEntry = PasswordEntry(siteName: siteName, username: username, password: password)
        // add this entry to the entries array
        entries.append(newEntry)
        // save new entry to disk
        saveEntries()
    }
    
    // delete an entry from the array using the given UUID
    func removeEntry(by id: UUID) {
        // remove the entry that matches the given UUID
        entries.removeAll {
            $0.id == id
        }
        // save changes to disk
        saveEntries()
    }
    
    // list all password entries
    func listEntries() {
        // TODO: print out all password entries to the console
        print("Entries:")
        // iterate thru each entry and print site name and username
        for (i, entry) in entries.enumerated() {
            print("\(i+1): \(entry.siteName), \(entry.username)")
        }
    }
    
    // print out a specific entry for the given index
    func printEntry(at index: Int) -> PasswordEntry? {
        // check if index number is valid
        guard index >= 0 && index < entries.count else {
            print("printEntry(): Index \(index) is invalid.")
            return nil
        }
        
        // if valid index, return the given entry
        return entries[index]
    }
    
    // update a specific entry given an index
        func updateEntry(at index: Int, siteName: String?, username: String?, password: String?) {
            guard index >= 0 && index < entries.count else {
                print("updateEntry(): Index \(index) is invalid.")
                return
            }
            
            // if given site name, update site name
            if let siteName = siteName, !siteName.isEmpty {
                entries[index].siteName = siteName
            }
            // if given username, update username
            if let username = username, !username.isEmpty {
                entries[index].username = username
            }
            // if given password, update password
            if let password = password, !password.isEmpty {
                entries[index].password = password
            }
            
            // save changes to disk
            saveEntries()
        }
    
    // load the password file from a specific URL
    func loadLibrary(from url: URL) {
        self.storageURL = url
        loadEntries()
    }
    
    // save the password file to a specific URL
    func saveLibrary(to url: URL) {
        self.storageURL = url
        saveEntries()
    }
}

