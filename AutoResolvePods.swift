//
//  AutoResolvePods.swift
//  AutoResolve
//
//  Created by Novianto Hermawan on 02/07/24.
//

import Foundation

struct Colors {
    static let reset = "\u{001B}[0;0m"
    static let black = "\u{001B}[0;30m"
    static let red = "\u{001B}[0;31m"
    static let green = "\u{001B}[0;32m"
    static let yellow = "\u{001B}[0;33m"
    static let blue = "\u{001B}[0;34m"
    static let magenta = "\u{001B}[0;35m"
    static let cyan = "\u{001B}[0;36m"
    static let white = "\u{001B}[0;37m"
}

func runCommand(_ command: String, arguments: [String] = [], in directory: String? = nil) -> Bool {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = [command] + arguments
    
    if let directory = directory {
        process.currentDirectoryURL = URL(filePath: directory)
    }
    
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    
    do {
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            print(output)
        }
        return process.terminationStatus == 0
    } catch {
        print("Error running command: \(error)")
        return false
    }
}

func integratePods(in projectDirectory: String) {
    // Step 1: bundle exec pod deintegrate
    let deintegrate = """
    ==================================================
    ====== Running Bundle exec pod deintegrate =======
    ==================================================
    """
    
    let podInstall = """
    ==================================================
    ====== Running Bundle exec pod install ===========
    ==================================================
    """
    
    let resolvingPackage = """
    ==================================================
    ====== Resolving package versions in Xcode =======
    ==================================================
    """
    
    
    print(Colors.cyan + deintegrate + Colors.reset)
  if runCommand("bundle", arguments: ["exec", "pod", "deintegrate"], in: projectDirectory) {
    sleep(2)

    // Step 2: bundle exec pod install
      print( Colors.cyan + podInstall + Colors.reset)
    if runCommand("bundle", arguments: ["exec", "pod", "install"], in: projectDirectory) {
        sleep(2)

        // Step 3: Resolve package versions in Xcode
        print(Colors.blue + resolvingPackage + Colors.reset)
        if runCommand("xcodebuild", arguments: ["-resolvePackageDependencies"], in: projectDirectory) {
            print(Colors.white + "🗿 All steps completed successfully!" + Colors.reset)
        } else {
            print(Colors.red + "🚨 Failed to resolve package versions."+ Colors.reset)
        }
    } else {
        print(Colors.red + "🚨 Failed to install pods." + Colors.reset)
    }
  } else {
      print(Colors.red + "🚨 Failed to deintegrate pods." + Colors.reset)
  }
}

let projectDirectory = "your/PATH/"
integratePods(in: projectDirectory)
