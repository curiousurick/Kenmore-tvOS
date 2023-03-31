//  Copyright © 2023 George Urick
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import UICKeyChainStore

class UserStore {
    
    private let logger = Log4S()
    private let UserStoreKey = "UserStoreKey"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let keychain: UICKeyChainStore
    
    static let instance = UserStore()
    
    private init() {
        keychain = KeychainManager.instance.keychain
    }
    
    func getUser() -> User? {
        guard let data = keychain.data(forKey: UserStoreKey) else {
            logger.info("User is not logged in")
            return nil
        }
        do {
            return try decoder.decode(User.self, from: data)
        }
        catch {
            logger.error("Failed to decode creators from keychain")
        }
        return nil
    }
    
    func setUser(user: User) {
        do {
            let data = try encoder.encode(user)
            keychain.setData(data, forKey: UserStoreKey)
        }
        catch {
            logger.error("Failed to save creators to keychain")
        }
    }
    
    func removeUser() {
        keychain.removeItem(forKey: UserStoreKey)
    }

}
