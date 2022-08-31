//
//  LoginViewController.swift
//  TableViewToRxSwift2
//
//  Created by Junyeong Park on 2022/08/31.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setObservers()
    }
    
    private func setObservers() {
        let observer1 = userNameTextField.rx.text.orEmpty
        let observer2 = passwordTextField.rx.text.orEmpty
        let observerCombined = Observable.combineLatest(observer1, observer2)
        loginButton.rx.tap
            .withLatestFrom(observerCombined)
            .subscribe(onNext: { (userName, password) in
                self.login(userName, password)
            })
            .disposed(by: disposeBag)
    }
    
    private func login(_ userName: String, _ password: String) {
        if isLoginPossible(userName, password) {
            guard let foodTableVC = storyboard?.instantiateViewController(withIdentifier: "FoodListViewController") as? ViewController else {
                invalidMessage()
                return
            }
            navigationController?.pushViewController(foodTableVC, animated: true)
        } else {
            invalidMessage()
        }
    }
    
    private func invalidMessage() {
        let alert = UIAlertController(title: "Warning!", message: "Invalid ID or PW!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    private func isLoginPossible(_ userName: String, _ password: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        let emailValid: Bool = emailTest.evaluate(with: userName)
        let passValid: Bool = (password != "" && password.count >= 6)
        return emailValid && passValid
    }
}
