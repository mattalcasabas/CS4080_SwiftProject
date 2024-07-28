//
//  main.swift
//  PasswordManager-CLI
//
//  Created by Matthew Alcasabas on 7/27/24.
//
import Foundation

func getLibrary() -> Int {
    print("1. Create new password libary")
    print("2. Open existing password libary")
    let choiceNum = Int(readLine() ?? "-1") ?? -1
    return choiceNum
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

func openPasswordLibrary() {
    
}


var stayInProgram = true
var curDirectory: String
print("Welcome to the password manager!")

repeat {
    var libraryChoice = getLibrary()
    switch libraryChoice {
    case 1:
        curDirectory = createLibrary()
    case 2:
        print(2)
    default:
        print("Invalid entry, try again")
        continue
    }
    stayInProgram = false
} while stayInProgram
