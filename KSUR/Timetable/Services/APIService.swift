//
//  APIService.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 07.08.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import Foundation
import SwiftProtobuf

protocol APIServiceProtocol: class {
    
    var deserializer: DeserializerServiceProtocol { get }
    
    var host: String { get }
    var port: Int { get }
    var version: Int { get }
    
    func getGroup(atIndex: Int) -> LessonsGroupProtocol?
    func getWeek(group: Int, even: Bool) -> LessonsWeekProtocol?
    
}

class APIService: APIServiceProtocol {
    
    let deserializer: DeserializerServiceProtocol
    
    let host: String
    let port: Int
    let version: Int
    
    init(host: String, port: Int, version: Int, deserializer: DeserializerServiceProtocol) {
        
        self.host = host
        self.port = port
        self.version = version
        
        self.deserializer = deserializer
        
    }
    
    func getGroup(atIndex: Int) -> LessonsGroupProtocol? {
        
        let urlString = "http://\(host):\(port)/v\(version)/groups/\(atIndex)"
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            
            let data = try Data(contentsOf: url)
            let group = try! ProtoGroup(serializedData: data)
            
            return deserializer.deserializeGroup(group)
            
        } catch {
            
            print("\(error)")
            return nil
            
        }
        
    }
    
    func getWeek(group: Int, even: Bool) -> LessonsWeekProtocol? {
        
        let urlString = "http://\(host):\(port)/v\(version)/groups/\(group)/weeks/\(even)"
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            
            let data = try Data(contentsOf: url)
            let week = try! ProtoWeek(serializedData: data)
            
            return deserializer.deserializeWeek(week)
            
        } catch {
            
            print("\(error)")
            return nil
            
        }
        
    }
    
}
