//
//  main.swift
//  PasswordManager-CLI
//
//  Created by Matthew Alcasabas on 7/27/24.
//
import Foundation

func getLibrary() -> String {
    print("1. Create new password libary")
    print("2. Open existing password libary")
    print("3. Exit")
    let choiceNum = Int(readLine() ?? "-1") ?? -1
    
    switch choiceNum {
    case 1:
        return createLibrary()
    case 2:
        return openPasswordLibrary()
    case 3:
        return "q"
    default:
        print("Invalid entry, try again")
        return "e"
    }
}


func createLibrary() -> String {
    let fileManager = FileManager.default
    print("Enter file path for the new password library:")
    let directory = readLine()!
    
    do {
        try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: false)
        print("Created library at \(directory)")
        return directory
    } catch {
        print("Error, cannot create library")
        return "e"
    }
}

func openPasswordLibrary() -> String {
    let fileManager = FileManager.default
    print("Enter file path for the password library:")
    let directory = readLine()!
    
    do {
        var files = try fileManager.contentsOfDirectory(atPath: directory)
        for file in files {
            if file == "passwords.json" {
                return directory
            }
        }
    } catch {
        return "e"
    }
    return "e2"
}

func loadJson(fileName: String) -> [PasswordEntry]? {
    let decoder = JSONDecoder()

    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: fileName))
        let passwords = try decoder.decode([PasswordEntry].self, from: data)
        return passwords
    } catch {
        print("e")
    }
        
    return []
}

func readEntry(directory: String) {
    let x = loadJson(fileName: (directory + "/passwords.json"))
    
    for entry in x! {
        print("\(entry.id), \(entry.siteName), \(entry.username), \(entry.password)")
    }
}

func createEntry(directory: String) {
    
}

func updateEntry(directory: String) {
    
}

func deleteEntry(directory: String) {
    
}

func passwordInteract(directory: String) {
    stayInProgram = true
    repeat {
        print("What would you like to do?")
        print(" 1. Read password entry")
        print(" 2. Create password entry")
        print(" 3. Update an existing entry")
        print(" 4. Delete an existing entry")
        print(" 5. Go back")
        
        var passwordChoice = Int(readLine() ?? "-1") ?? -1
        
        switch passwordChoice {
        case 1:
            readEntry(directory: directory)
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        case 5:
            stayInProgram = false
            continue
        default:
            break
        }
        
    } while stayInProgram
}


var stayInProgram = true
var curDirectory: String
print("Welcome to the password manager!")

repeat {
    var curDirectory = getLibrary()
    
    if (curDirectory.first == "e") {
        print("error")
        continue
    } else if curDirectory == "q" {
        stayInProgram = false
        continue
    } else {
        passwordInteract(directory: curDirectory)
    }
    
} while stayInProgram

var curPass = PasswordEntry(siteName: "google.com", username: "person1231", password: "GIBERUSG")
