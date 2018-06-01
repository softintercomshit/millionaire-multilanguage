import Foundation
import UIKit


extension UIImageView {
    func setImage(name: String) {
        RestClient.appCheck { [weak self] full in
            if full {
                let image = UIImage(named: name)
                self?.image = image
            } else {
                let image = customImage(named: name)
                self?.image = image
            }
        }
    }
}

extension UIButton {
    func setImage(name: String, state: UIControlState = .normal) {
        RestClient.appCheck { [weak self] full in
            if full {
                let image = UIImage(named: name)
                self?.setImage(image, for: state)
            } else {
                let image = customImage(named: name)
                self?.setImage(image, for: state)
            }
        }
    }
    
    func setBackgroundImage(name: String, state: UIControlState = .normal) {
        RestClient.appCheck { [weak self] full in
            if full {
                let image = UIImage(named: name)
                self?.setBackgroundImage(image, for: state)
            } else {
                let image = customImage(named: name)
                self?.setBackgroundImage(image, for: state)
            }
        }
    }
}

private func customImage(named: String) -> UIImage? {
    var named = named
    if named.hasSuffix(".png".lowercased()) {
        named = named.replacingOccurrences(of: ".png", with: "")
    }
    
    if let bundleUrl = Bundle.main.url(forResource: "res", withExtension: "bundle"),
        let resBundle = Bundle(url: bundleUrl),
        let imagePath = resBundle.path(forResource: named, ofType: "png") {

        let image = UIImage(contentsOfFile: imagePath)

        return image
    }
    
    return nil
}
