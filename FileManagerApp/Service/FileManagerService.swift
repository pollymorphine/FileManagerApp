//
//  FileManagerService.swift
//  FileManagerApp
//
//  Created by Polina on 28.07.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation

class  FileManagerService {
    
    static let shared = FileManagerService()
    
    init() {}
    
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func listFiles(at currentPath: String) -> [String] {
        guard let url = documents?.appendingPathComponent(currentPath),
            let list = try? FileManager.default.contentsOfDirectory(atPath: url.path) else { return [] }
        
        let newList = list
        var file = [String]()
        var directory = [String]()
        
        for item in newList {
            if item.hasPrefix(".") {
                continue
            }
            if item.contains(".") {
                file.append( item)
                file.sort(by: <)
            } else {
                directory.append( item)
                directory.sort(by: <)
            }
        }
        return directory + file
    }
    
    func addDirectory(withName name: String, at currentPath: String) {
        guard let path = documents?.path else { return }
        let filePath = path + currentPath + "/" + name
        if FileManager.default.fileExists(atPath: filePath) {
            print("папка существует")
        } else {
            
            try? FileManager.default.createDirectory(atPath: filePath,
                                                     withIntermediateDirectories: false,
                                                     attributes: nil)
        }
    }
    
    func addFile(containing: String, withName name: String, at currentPath: String) {
        guard let path = documents?.path else { return}
        let filePath = path + currentPath + "/" + name
        let rawData: Data? = containing.data(using: .utf8)
        if FileManager.default.fileExists(atPath: filePath) {
            print("файл существует")
        } else {
            FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
        }
    }
    
    func deleteItem(withName name: String, at currentPath: String) {
        guard let path = documents?.path else { return }
        let filePath = path + currentPath + "/" + name
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
    func readItem(withName name: String, at currentPath: String) -> String {
        guard let path = documents?.path else { return "" }
        let filePath = path + currentPath + "/" + name
        guard let fileContent = FileManager.default.contents(atPath: filePath),
            let fileContentEncoded = String(bytes: fileContent, encoding: .utf8) else { return ""}
        return fileContentEncoded
    }
    
    func checkItem(withName name: String, at currentPath: String) -> Bool{
        guard let path = documents?.path else { return  true}
        let filePath = path + currentPath + "/" + name
        FileManager.default.fileExists(atPath: filePath)
        return true
    }
}
