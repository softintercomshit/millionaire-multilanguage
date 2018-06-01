import Foundation
import UIKit

/**
 need to set TextField or TextView frame in textFieldShouldBeginEditing delegate
 example:
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         let frame = textField.convert(textField.bounds, to: view)
         textFieldFrame = frame
         return true
     }
 */

public class KeyboardHandler: NSObject {
    private var keyboardFrame = CGRect.zero
    private var view: UIView?
    var textFieldFrame = CGRect.zero
    private let keyboardHandlerClass = KeyboardHandlerClass()
    
    func startObservingKeyboardChangesFor(_ view: UIView) {
        self.view = view
        
        
        
        // NotificationCenter observers
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(sender: notification as NSNotification)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            self.keyboardWillHide(sender: notification as NSNotification)
        }
        
        keyboardHandlerClass.monitorKeyboardHide(view: view)
    }
    
    private func keyboardWillShow(sender: NSNotification) {
        if textFieldFrame == CGRect.zero {return}
        
        let info  = sender.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        
        let rawFrame = value.cgRectValue
        
        if let view = view {
            keyboardFrame = view.convert(rawFrame!, from: nil)
            adjustView()
        }
    }
    
    func forceAdjustView() {
        if textFieldFrame == CGRect.zero {return}
        adjustView()
    }
    
    private func adjustView() {
        if keyboardFrame.intersects(textFieldFrame) {
            let keyboardHeight = keyboardFrame.size.height
            
            if let view = view {
                var newFrame = view.frame
                newFrame.origin.y = UIScreen.main.bounds.height - keyboardHeight - textFieldFrame.origin.y - textFieldFrame.height
                view.frame = newFrame
            }
        } else {
            if let view = view {
                var newFrame = view.frame
                let newOriginY = textFieldFrame.origin.y + newFrame.origin.y
                
                if textFieldFrame.origin.y + newFrame.origin.y < 0 {
                    newFrame.origin.y -= newOriginY
                    view.frame = newFrame
                }
            }
        }
    }
    
    private func keyboardWillHide(sender: NSNotification) {
        if textFieldFrame == CGRect.zero {return}
        
        if let view = view {
            var newFrame = view.frame
            newFrame.origin.y = 0
            view.frame = newFrame
        }
    }
}

private class KeyboardHandlerClass: NSObject, UIGestureRecognizerDelegate {
    private var controllerView: UIView?
    
    func monitorKeyboardHide(view: UIView){
        controllerView = view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        controllerView?.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Don't handle button taps
        return !(touch.view is UIButton)
    }
}
