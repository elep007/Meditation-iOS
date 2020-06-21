import Foundation

struct Defaults {
    static let SELINDEX_KEY = "SELINDEX_ARRAY"
    static let SELSTATUS_KEY = "SELSTATUS_ARRAY"
    static let USERID_KEY = "USERID_ARRAY"
    
    static func save(_ value: String, with key: String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getNameAndValue(_ key: String)-> String {
        return (UserDefaults.standard.value(forKey: key) as? String) ?? ""
    }
    static func clearUserData(_ key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
}
