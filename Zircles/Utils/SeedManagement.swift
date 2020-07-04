//
//  SeedManagement.swift
//  wallet
//
//  Created by Francisco Gindre on 1/23/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import Foundation
import KeychainSwift
import ZcashLightClientKit
final class SeedManager {
    
    enum SeedManagerError: Error {
        case alreadyImported
        case uninitializedWallet
    }
    
    static var `default`: SeedManager = SeedManager()
    private static let zECCWalletKeys = "zECCWalletKeys"
    private static let zECCWalletSeedKey = "zEECWalletSeedKey"
    private static let zECCWalletBirthday = "zECCWalletBirthday"
    private static let zECCWalletPhrase = "zECCWalletPhrase"
    
    private let keychain = KeychainSwift()
    
    func importBirthday(_ height: BlockHeight) throws {
        guard keychain.get(Self.zECCWalletBirthday) == nil else {
            throw SeedManagerError.alreadyImported
        }
        keychain.set(String(height), forKey: Self.zECCWalletBirthday)
    }
    
    func exportBirthday() throws -> BlockHeight {
        guard let birthday = keychain.get(Self.zECCWalletBirthday),
            let value = BlockHeight(birthday) else {
                throw SeedManagerError.uninitializedWallet
        }
        return value
    }
    
    func importSeed(_ seed: [UInt8]) throws {
        guard keychain.get(Self.zECCWalletSeedKey) == nil else { throw SeedManagerError.alreadyImported }
        keychain.set(Data(seed), forKey: Self.zECCWalletSeedKey)
        
    }
    
    func exportSeed() throws -> [UInt8] {
        guard let seedData = keychain.getData(Self.zECCWalletSeedKey) else { throw SeedManagerError.uninitializedWallet }
        return [UInt8](seedData)
    }
    
    func importPhrase(bip39 phrase: String) throws {
        guard keychain.get(Self.zECCWalletPhrase) == nil else { throw SeedManagerError.alreadyImported }
        keychain.set(phrase, forKey: Self.zECCWalletPhrase)
    }
    
    func exportPhrase() throws -> String {
        guard let seed = keychain.get(Self.zECCWalletPhrase) else { throw SeedManagerError.uninitializedWallet }
        return seed
    }
    
    func saveKeys(_ keys: [String]) {
        keychain.set(keys.joined(separator: ";"), forKey: Self.zECCWalletKeys)
    }
    
    func getKeys() -> [String]? {
        keychain.get(Self.zECCWalletKeys)?.split(separator: ";").map{String($0)}
    }
    
    /**
     
     */
    func nukePhrase() {
        keychain.delete(Self.zECCWalletPhrase)
    }
    /**
        Use carefully: Deletes the keys from the keychain
     */
    func nukeKeys() {
        keychain.delete(Self.zECCWalletKeys)
    }

    /**
       Use carefully: Deletes the seed from the keychain.
     */
    func nukeSeed() {
        keychain.delete(Self.zECCWalletSeedKey)
    }
    
    /**
     Use carefully: deletes the wallet birthday from the keychain
     */
    
    func nukeBirthday() {
        keychain.delete(Self.zECCWalletBirthday)
    }
    
    
    /**
    There's no fate but what we make for ourselves - Sarah Connor
    */
    func nukeWallet() {
        for key in keychain.allKeys {
            keychain.delete(key)
        }
    }
}

extension SeedManager: SeedProvider {
    func seed() -> [UInt8] {
        (try? exportSeed()) ?? []
    }
}

extension SeedManager {
    func saveKeys(_ key: String, phrase: String,height: BlockHeight, spendingKey: String) throws {
        guard keychain.get(heightKey(key)) == nil else {
            throw SeedManagerError.alreadyImported
        }
        keychain.set(String(height), forKey: heightKey(key))
        
        guard keychain.get(phraseKey(key)) == nil else {
            throw SeedManagerError.alreadyImported
        }
        keychain.set(String(phrase), forKey: phraseKey(key))
        
        guard keychain.get(spendingKeyKey(key)) == nil else {
            throw SeedManagerError.alreadyImported
        }
        keychain.set(String(spendingKey), forKey: spendingKeyKey(key))
    }
    
    func getZircleKeys(_ key: String) throws -> (height: BlockHeight, phrase: String, spendingKey: String)? {
        guard   let heightString = keychain.get(heightKey(key)),
                let height = BlockHeight(heightString),
                let phrase = keychain.get(phraseKey(key)),
                let spendingKey = keychain.get(spendingKeyKey(key)) else {
            return nil
        }
        
        return (height: height, phrase: phrase, spendingKey: spendingKey)
    }
    
    func heightKey(_ key: String) -> String {
        key+"+height"
    }
    
    func phraseKey(_ key: String) -> String {
        key+"+phrase"
    }
    
    func spendingKeyKey(_ key: String) -> String {
        key+"+spending"
    }
}
