//
//  UIViewControllerExtensions.swift
//  IosNativeApp
//
//  Created by 신동규 on 2020/12/09.
//

import UIKit

extension UIViewController {
    
    func renderAlertTypeOne(title:String?, message:String, action:((UIAlertAction) -> Void)?, completion:(() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: action))
        self.present(alert, animated: true, completion: completion)
    }
    
    
    func clearNavigationBackground() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func dismissKeyboardByTouchingAnywhere() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardSelector))
        view.addGestureRecognizer(tap)
    }
    
    func moveViewWhenKeyboardAppeared() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func dismissKeyboardSelector() {
        view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
      
      self.view.frame.origin.y = 0 - keyboardSize.height / 2
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
    }
}


