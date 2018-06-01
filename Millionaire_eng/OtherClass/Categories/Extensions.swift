import Foundation

private func localizedString(key: String) -> String {
    if let language = UserDefaults.standard.string(forKey: "localization"),
        let bundlePath = Bundle.main.url(forResource: language, withExtension: "lproj"),
        let bundle = Bundle(url: bundlePath),
        let dictPath = bundle.url(forResource: "Localizable", withExtension: "strings"),
        let dict = NSDictionary(contentsOf: dictPath) as? [String: String],
        let localizedString = dict[key] {
        
        return localizedString
    }
    
    return key
}

extension String{
    var localized: String {
        return localizedString(key: self)
    }
}

extension NSString {
    var localized: String {
        return localizedString(key: self as String)
    }
}
