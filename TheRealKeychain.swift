//
//  TheRealKeychain.swift
//  Accessi Genio
//
//  Created by Fabio Cirruto on 27/02/2019.
//  Copyright © 2019 Fabio Cirruto. All rights reserved.
//
import UIKit
import Foundation
import Security

class TheRealKeychain {
    class func login(_ username: String, _  password: String){
        let usernameData = prepareForSave(username)
        let usernamePassword = prepareForSave(password)
        save("username", usernameData)
        save("password", usernamePassword)
    }
    
    class func isUserLogged()->Bool{
        guard let _ = load("username") else {
            return false
        }
        
        guard let _ = load("password") else {
            return false
        }
        
        return true
    }
    
    class func logout(){
        delete("username")
        delete("password")
    }
    
    class func saveCustomKey(_ keyName: String, _ keyValue: String){
        let keyValueData = prepareForSave(keyValue)
        save(keyName, keyValueData)
    }
    
    class func load(_ key: String) -> String? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return prepareForRead(dataTypeRef as! Data)
        } else {
            return nil
        }
    }
    
    class func delete(_ key: String){
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
    }
    
    class func prepareForSave(_ stringValue: String)-> Data {
        return stringValue.data(using: .utf8)!
    }
    
    class func prepareForRead(_ dataValue: Data)-> String {
        return String(data: dataValue, encoding: .utf8)!
    }
    
    class func save(_ key: String, _ data: Data) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }
}
