import Foundation

extension Character {
    func charToString() -> String {
        return String(self)
    }
}

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
    let x = createPasswordFile(directory: directory)
    return x
}

func loadJson(fileName: String, flag: Int) -> [PasswordEntry]? {
    let decoder = JSONDecoder()

    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: fileName))
        let passwords = try decoder.decode([PasswordEntry].self, from: data)
        return passwords
    } catch {
        print("No passwords found, try creating one.")
        if flag == 1 {return []}
    }
    return nil
}

func printEntries(passwords: [PasswordEntry]) { //convert to extension?
    print("Account entries:")
    for (i, entry) in passwords.enumerated() {
        print("\(i+1): \(entry.siteName), \(entry.username)")
    }
}

func readEntries(passwords: [PasswordEntry]) {
    printEntries(passwords: passwords)
    
    var viewAccounts = true
    repeat {
        print("Select an account to view:")
        var userSelect = Int(readLine() ?? "-1") ?? -1
        if (userSelect != -1) && (userSelect <= passwords.count) {
            var curPass = passwords[userSelect - 1]
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

func generatePassword(passLength: Int) -> String {
    let allowedCharactersInPass = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*")
    var password = ""
    
    for _ in 1...passLength {
        password += allowedCharactersInPass.randomElement()!.charToString()
    }
    
    return password
}

func writeToFile(directory: String, passwords: [PasswordEntry]) {
    let jsonEncoder = JSONEncoder()
    let fileManager = FileManager.default
    do {
        let data = try jsonEncoder.encode(passwords)
        let encodedData = String(data: data, encoding: .utf8)!
        do {
            try encodedData.write(toFile: directory, atomically: false, encoding: .utf8)
        } catch {
            print("Could not write to file")
        }
    } catch {
        print("Could not encode password data to JSON")
    }
}

func createEntry(passwords: inout [PasswordEntry], directory: String) {
    var createEntries = true, websiteInput = true, usernameInput = true
    var website: String, username: String, passLength: Int
    repeat {
        print()
        print("Password entry creation, enter the following")
        
        repeat {
            print("Website:")
            website = readLine() ?? ""
            print("Website: \(website), correct? 1. Yes, 2. No")
            if (Int(readLine() ?? "2") ?? 2) == 1 {websiteInput = false}
        } while websiteInput
        
        repeat {
            print("Username:")
            username = readLine() ?? ""
            print("Username: \(username), correct? 1. Yes, 2. No")
            if (Int(readLine() ?? "2") ?? 2) == 1 {usernameInput = false}
        } while usernameInput
        
        repeat {
            print("How many characters in password?")
            passLength = (Int(readLine() ?? "-1") ?? -1)
            print("Password length: \(passLength), correct? 1. Yes, 2. No")
            if (Int(readLine() ?? "2") ?? 2) == 2 {passLength = 0}
        } while passLength <= 0
        let password = generatePassword(passLength: passLength)
        let newPass = PasswordEntry(siteName: website, username: username, password: password)
        passwords.append(newPass)
        writeToFile(directory: directory, passwords: passwords)
        print("New password added to library")
        return
    } while createEntries
}

func updateEntry(passwords: inout [PasswordEntry], directory: String) {
    var selectEntry = true, selectField = true
    var curPass: PasswordEntry?
    print("Choose an entry to update.")
    repeat {
        // print out all entries in the library file
        printEntries(passwords: passwords)
        print("-1: Exit and save changes")
        // user chooses which entry to update
        var entrySelect = Int(readLine() ?? "-1") ?? -1
        // if -1, save and exit
        if (entrySelect == -1) {
            selectField = false
            print("Saving changes...")
            // save changes to entry
            writeToFile(directory: directory, passwords: passwords)
            print("All changes saved.")
            selectEntry = false
            return
        }
        // print out all fields of the current entry
        repeat {
            if (entrySelect != -1) && (entrySelect <= passwords.count) {
                curPass = passwords[entrySelect - 1]
                print("Choose an entry to update:")
                print("1. Website: \(curPass?.siteName ?? "N/A")")
                print("2. Username: \(curPass?.username ?? "N/A")")
                print("3. Password: \(curPass?.password ?? "N/A")")
                print("-1. Exit and save changes")
            }
            // choose the field to update
            var fieldSelect = Int(readLine() ?? "-1") ?? -1
            // update the field
            switch fieldSelect {
            case 1:
                // edit website name
                print("Enter new website:")
                let newSiteName = readLine() ?? ""
                curPass?.siteName = newSiteName
                break
            case 2:
                // edit username
                print("Enter new username:")
                let newUsername = readLine() ?? ""
                curPass?.username = newUsername
                break
            case 3:
                // edit password
                print("Enter new password:")
                let newPassword = readLine() ?? ""
                curPass?.password = newPassword
                break
            default:
                break
            }
            // save changes to field
            if let curPass = curPass, let index = passwords.firstIndex(where: { $0.id == curPass.id }) {
                passwords[index] = curPass
            }
            selectField = false
        }   while selectField
    }   while selectEntry
}

func deleteEntry(passwords: [PasswordEntry], directory: String) {
    
}

func passwordInteract(directory: String) {
    stayInProgram = true
    var passwordChoice: Int
    guard var passwords = loadJson(fileName: (directory + "/passwords.json"), flag: 0) else {
        print("Create a Password? 1: yes, 2: no")
        if (Int(readLine() ?? "2" ) ?? 2) == 1 {
            var passwords = loadJson(fileName: (directory + "/passwords.json"), flag: 1)
            createEntry(passwords: &passwords!, directory: (directory + "/passwords.json"))
            print("Open libarary again to access options.")
        }
        return //no passwords found
    }
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
            readEntries(passwords: passwords)
            break
        case 2:
            createEntry(passwords: &passwords, directory: (directory + "/passwords.json"))
            break
        case 3:
            updateEntry(passwords: &passwords, directory: (directory + "/passwords.json"))
            break
        case 4:
            deleteEntry(passwords: passwords, directory: (directory + "/passwords.json"))
            break
        case 5:
            return
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
