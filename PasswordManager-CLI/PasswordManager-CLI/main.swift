import Foundation

//converts character to a string
extension Character {
    func charToString() -> String {
        return String(self)
    }
}

// this current PasswordLibrary instance
var currentLibrary: PasswordLibrary?

func getLibrary() -> PasswordLibrary? {
        //library options
    
        print("1. Create new password library")
        print("2. Open existing password library")
        print("3. Exit")
    
        //collect user choice
        let choiceNum = Int(readLine() ?? "-1") ?? -1
    
        switch choiceNum {
        case 1:
            //creates new library location
            return createLibrary()
        case 2:
            //opens existing library
            return openPasswordLibrary()!
        case 3:
            //sends quit signal to main loop
            return nil
        default:
            print("Invalid entry, try again")
            return nil
        }
}

func openPasswordLibrary() -> PasswordLibrary? {
    print("Enter file path for the password library:")
    let directory = readLine() ?? ""
    let fileManager = FileManager.default
    
    do {
        // does passwords.json exist in the library?
        let files = try fileManager.contentsOfDirectory(atPath: directory)
        if files.contains("passwords.json") {
            let url = URL(fileURLWithPath: directory).appendingPathComponent("passwords.json")
            // open new PasswordLibrary instance with the url received here
            return PasswordLibrary(storageURL: url)
        }
        else {
            print("openPasswordLibrary(): couldn't find passwords.json. Will initialize new library.")
            // create a new passwords.json file at current directory
            fileManager.createFile(atPath: (directory + "/passwords.json"), contents: nil)
            let url = URL(fileURLWithPath: directory).appendingPathComponent("passwords.json")
            return PasswordLibrary(storageURL: url)
        }
    } catch {
        print("openPasswordLibrary(): error opening library: \(error)")
        return nil
    }
}

func createLibrary() -> PasswordLibrary? {
    let fileManager = FileManager.default
    print("Enter file path for the new password library:")
    //Gets directory location from user
    let directory = readLine() ?? ""
    
    do {
        //if valid location found, create new directory
        try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: false)
        print("Created library at \(directory)")
        let url = URL(fileURLWithPath: directory).appendingPathComponent("passwords.json")
        return PasswordLibrary(storageURL: url)
    } catch {
        //Warn user if location was not valid
        print("createLibrary(): could not create the library. Location may be invalid or already exists.")
        return nil
    }
}

func generatePassword(passLength: Int) -> String {
    //Allowed characters in password
    let allowedCharactersInPass = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*")
    var password = ""
    
    //Randomly selects character from array from user given password length
    for _ in 1...passLength {
        password += allowedCharactersInPass.randomElement()!.charToString()
    }
    
    return password
}

func passwordInteract(library: PasswordLibrary) {
    var stayInProgram = true
    
    repeat {
        print("What would you like to do?")
        print(" 1. Read password entry")
        print(" 2. Create password entry")
        print(" 3. Update an existing entry")
        print(" 4. Delete an existing entry")
        print(" 5. Go back")
        
        let passwordChoice = Int(readLine() ?? "-1") ?? -1
        
        switch passwordChoice {
        case 1:
            // read password entry
             // readEntries(passwords: passwords)
            library.listEntries()
            print("Select an account to view: ")
            if let index = Int(readLine() ?? "-1"), let entry = library.printEntry(at: index - 1) {
                print("Website: \(entry.siteName)")
                print("Username: \(entry.username)")
                print("Password: \(entry.maskPassword())")
                print("Copy password? 1: yes, 2: no")
                let copyPass = Int(readLine() ?? "2")
                if copyPass == 1 {
                    entry.copyPassword()
                    print("Password copied.")
                }
                
            }
        case 2:
            // create password entry
            // createEntry(passwords: &passwords, directory: (directory + "/passwords.json"))
            print("Enter website: ")
            let newSiteName = readLine() ?? ""
            print("Enter username: ")
            let newUsername = readLine() ?? ""
            print("Generate a random password?")
            print(" 1. Yes, create a random password")
            print(" 2. No, let me enter my own")
            var newPassword = ""
            let genPassChoice = Int(readLine() ?? "2")
            switch genPassChoice {
            case 1:
                print("How many characters required for this password? (default: 10)")
                let passLength = Int(readLine() ?? "-1")
                newPassword = generatePassword(passLength: passLength ?? 10)
                print("Generated password: \(newPassword)")
            case 2:
                print("Enter password: ")
                newPassword = readLine() ?? ""
            default:
                break
            }
            library.addEntry(siteName: newSiteName, username: newUsername, password: newPassword)
        case 3:
            // update existing password entry
            // updateEntry(passwords: &passwords, directory: (directory + "/passwords.json"))
            library.listEntries()
            print("Select an account to update: ")
            let index = Int(readLine() ?? "-1")
            if index == index {
                print("Enter new site name (Leave blank to skip): ")
                let newSiteName = readLine() ?? ""
                print("Enter new username (Leave blank to skip): ")
                let newUsername = readLine() ?? ""
                print("Enter new password (Leave blank to skip): ")
                let newPassword = readLine() ?? ""
                library.updateEntry(at: index! - 1, siteName: newSiteName, username: newUsername, password: newPassword)
            }
        case 4:
            // delete existing password entry
            // deleteEntry(passwords: &passwords, directory: (directory + "/passwords.json"))
            library.listEntries()
            print("Select an account to delete: ")
            if let index = Int(readLine() ?? "-1") {
                let entry = library.printEntry(at: index - 1)
                if let entry = entry {
                    library.removeEntry(by: entry.id)
                    print("Entry deleted.")
                }
            }
        case 5:
            return
        default:
            break
        }
        
    } while stayInProgram
}

func passwordMain() throws {
    var stayInProgram = true
    //var curDirectory: String
    print("Welcome to the password manager!")

    repeat {
        if let library = getLibrary() {
            currentLibrary = library
            passwordInteract(library: currentLibrary!)
        }
        else {
            stayInProgram = false
        }
    } while stayInProgram
}

try passwordMain()
