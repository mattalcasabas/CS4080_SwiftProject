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
//    print("No password file found in this directory, Create?")
//    print("1. Yes")
//    print("2. No")
//    let createFile = Int(readLine() ?? "2") ?? 2
//    if (createFile == 1) {

//        //create passwords.json file at current directory
//        fileManager.createFile(atPath: (directory + "/passwords.json"), contents: nil)
//        return directory
//    }
//    return "e"
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

//func openPasswordLibrary() -> String {
//    let fileManager = FileManager.default
//    print("Enter file path for the password library:")
//    //Gets directory from user
//    let directory = readLine() ?? ""
//    
//    do {
//        //Try to locate passwords.json file in given directory
//        let files = try fileManager.contentsOfDirectory(atPath: directory)
//        for file in files {
//            if file == "passwords.json" {
//                return directory
//            }
//        }
//    } catch {
//        return "e"
//    }
//    //If passwords.json cannot be found, offer to create one
//    let x = createPasswordFile(directory: directory)
//    return x
//}

/*
func loadJson(fileName: String, flag: Int) -> [PasswordEntry]? {
    let decoder = JSONDecoder()

    do {
        //Gather data from passwords.json and decode it into a struct
        let data = try Data(contentsOf: URL(fileURLWithPath: fileName))
        let passwords = try decoder.decode([PasswordEntry].self, from: data)
        return passwords
    } catch {
        //Empty passwords.json file
        print("No passwords found, try creating one.")
        if flag == 1 {return []}
    }
    return nil
}

func printEntries(passwords: [PasswordEntry]) { //convert to extension?
    print("Account entries:")
    //Prints site name and username from each password entry, along with an index
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
        //If user selects valid entry from given range print out the elements from the entry
        if (userSelect != -1) && (userSelect <= passwords.count) {
            var curPass = passwords[userSelect - 1]
            print(" Website: \(curPass.siteName)")
            print(" Username: \(curPass.username)")
            print(" Password: \(curPass.maskPassword())")
            print("Copy password? 1. Yes, 2. No")
            //Offer option to copy password to clipboard
            if (Int(readLine() ?? "2") ?? 2) == 1 {curPass.copyPassword(); print("Password copied")}
        }
        
        print("View another account?")
        print("1: yes")
        print("2: no")
                
        var moreAcc = Int(readLine() ?? "2") ?? 2
        if moreAcc == 2 {viewAccounts = false}
        
    } while viewAccounts
}
*/
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
/*
func writeToFile(directory: String, passwords: [PasswordEntry]) {
    let jsonEncoder = JSONEncoder()
    do {
        //Encode passwords into data
        let data = try jsonEncoder.encode(passwords)
        //Format data
        let encodedData = String(data: data, encoding: .utf8)!
        do {
            //Writes data into file
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
        
        //User input for website
        repeat {
            print("Website:")
            website = readLine() ?? ""
            print("Website: \(website), correct? 1. Yes, 2. No")
            if (Int(readLine() ?? "2") ?? 2) == 1 {websiteInput = false}
        } while websiteInput
        
        //User input for username
        repeat {
            print("Username:")
            username = readLine() ?? ""
            print("Username: \(username), correct? 1. Yes, 2. No")
            if (Int(readLine() ?? "2") ?? 2) == 1 {usernameInput = false}
        } while usernameInput
        
        //Generate password for user with user specified length
        repeat {
            print("How many characters in password?")
            passLength = (Int(readLine() ?? "-1") ?? -1)
            print("Password length: \(passLength), correct? 1. Yes, 2. No")
            if (Int(readLine() ?? "2") ?? 2) == 2 {passLength = 0}
        } while passLength <= 0
        
        let password = generatePassword(passLength: passLength)
        //Create new password struct
        let newPass = PasswordEntry(siteName: website, username: username, password: password)
        //Add password to passwords array
        passwords.append(newPass)
        //Write passwords to file
        writeToFile(directory: directory, passwords: passwords)
        print("New password added to library")
        return
    } while createEntries
}

func updateEntry(passwords: inout [PasswordEntry], directory: String) {
    var selectEntry = true, selectField = true
    var curPass: PasswordEntry?
    var passLength: Int
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
                print(" 1. Website: \(curPass?.siteName ?? "N/A")")
                print(" 2. Username: \(curPass?.username ?? "N/A")")
                print(" 3. Password: \(curPass?.maskPassword() ?? "N/A")")
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
            case 2:
                // edit username
                print("Enter new username:")
                let newUsername = readLine() ?? ""
                curPass?.username = newUsername
            case 3:
                // edit password
                repeat {
                    print("How many characters in password?")
                    passLength = (Int(readLine() ?? "-1") ?? -1)
                    print("Password length: \(passLength), correct? 1. Yes, 2. No")
                    if (Int(readLine() ?? "2") ?? 2) == 2 {passLength = 0}
                } while passLength <= 0
                let newPassword =  generatePassword(passLength: passLength)
                curPass?.password = newPassword
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

func deleteEntry(passwords: inout [PasswordEntry], directory: String) {
    var selectEntry = true
    var curPass: PasswordEntry?
    print("Choose an entry to delete.")
    repeat {
        // print out all entries in the library file
        printEntries(passwords: passwords)
        print("-1: Exit and save changes")
        // user chooses which entry to update
        var entrySelect = Int(readLine() ?? "-1") ?? -1
        // if -1, save and exit
        if (entrySelect == -1) {
            print("Saving changes...")
            // save changes to entry
            writeToFile(directory: directory, passwords: passwords)
            print("All changes saved.")
            selectEntry = false
            return
        }
        else if (entrySelect != -1) && (entrySelect <= passwords.count) {
            curPass = passwords[entrySelect - 1]
            print("Delete this entry?")
            print(" Website: \(curPass?.siteName ?? "N/A")")
            print(" Username: \(curPass?.username ?? "N/A")")
            print(" Password: \(curPass?.maskPassword() ?? "N/A")")
            print("1. Yes, delete this entry")
            print("2. No, don't delete this entry")
            var deleteEntry = Int(readLine() ?? "2") ?? 2
            if (deleteEntry == 1) {
                // save changes to field
                if let curPass = curPass, let index = passwords.firstIndex(where: { $0.id == curPass.id }) {
                    passwords.remove(at: index)
                }
            }
        }
    }   while selectEntry
}
*/

func passwordInteract(library: PasswordLibrary) {
    var stayInProgram = true
    
//    //Load file, if no passwords found then offer to create one
//    guard var passwords = loadJson(fileName: (directory + "/passwords.json"), flag: 0) else {
//        print("Create a Password? 1: yes, 2: no")
//        if (Int(readLine() ?? "2" ) ?? 2) == 1 {
//            var passwords = loadJson(fileName: (directory + "/passwords.json"), flag: 1)
//            createEntry(passwords: &passwords!, directory: (directory + "/passwords.json"))
//            print("Open libarary again to access options.")
//        }
//        return
//    }
    
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
                print("Enter new site name (leave blank to skip): ")
                let newSiteName = readLine() ?? ""
                print("Enter new username (leave blank to skip): ")
                let newUsername = readLine() ?? ""
                print("Enter new password (leave blank to skip): ")
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
//        curDirectory = getLibrary()
//        
//        if (curDirectory.first == "e") {
//            throw passError.invalidLocation
//        } else if curDirectory == "q" {
//            stayInProgram = false
//            continue
//        }  else {
//            passwordInteract(directory: curDirectory)
//        }
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
