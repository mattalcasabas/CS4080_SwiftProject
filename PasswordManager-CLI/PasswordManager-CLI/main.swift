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

func createPasswordFile(directory: String) -> String {
    print("No password file found in this directory, Create?")
    print("1. Yes")
    print("2. No")
    let createFile = Int(readLine() ?? "2") ?? 2
    if (createFile == 1) {
        let fileManager = FileManager.default
        fileManager.createFile(atPath: (directory + "/passwords.json"), contents: nil)
        return directory
    }
    return "e"
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
        let files = try fileManager.contentsOfDirectory(atPath: directory)
        for file in files {
            if file == "passwords.json" {
                return directory
            }
        }
    } catch {
        return "e"
    }
    var x = createPasswordFile(directory: directory)
    return x
}

func loadJson(fileName: String) -> [PasswordEntry]? {
    let decoder = JSONDecoder()

    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: fileName))
        let passwords = try decoder.decode([PasswordEntry].self, from: data)
        return passwords
    } catch {
        print("No passwords found, try creating one.")
    }
        
    return []
}

func readEntry(directory: String) {
    let x = loadJson(fileName: (directory + "/passwords.json"))
    print("Account entries:")
    for (i, entry) in x!.enumerated() {
        print("\(i+1): \(entry.siteName), \(entry.username)")
    }
    var viewAccounts = true
    repeat {
        print("Select an account to view:")
        var userSelect = Int(readLine() ?? "-1") ?? -1
        if (userSelect != -1) && (userSelect <= x!.count) {
            var curPass = x![userSelect - 1]
            print("Website: \(curPass.siteName)")
            print("Username: \(curPass.username)")
            print("Password: \(curPass.password)")
        }
        
        print("View another account?")
        print("1: yes")
        print("2: no")
        
        var moreAcc = Int(readLine() ?? "2") ?? 2
        if moreAcc == 2 {viewAccounts = false}
        
    } while viewAccounts
}

func createEntry(directory: String) {
    
}

func updateEntry(directory: String) {
    
}

func deleteEntry(directory: String) {
    
}

func passwordInteract(directory: String) {
    stayInProgram = true
    var passwordChoice: Int
    repeat {
        print("What would you like to do?")
        print(" 1. Read password entry")
        print(" 2. Create password entry")
        print(" 3. Update an existing entry")
        print(" 4. Delete an existing entry")
        print(" 5. Go back")
        
        passwordChoice = Int(readLine() ?? "-1") ?? -1
        
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
    curDirectory = getLibrary()
    
    if (curDirectory.first == "e") {
        print("error")
        continue
    } else if curDirectory == "q" {
        stayInProgram = false
        continue
    } else if curDirectory == "." {
        continue
    } else {
        passwordInteract(directory: curDirectory)
    }
    
} while stayInProgram
