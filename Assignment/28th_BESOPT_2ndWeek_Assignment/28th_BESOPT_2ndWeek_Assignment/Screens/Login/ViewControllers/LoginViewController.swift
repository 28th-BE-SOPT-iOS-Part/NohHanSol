//
//  LoginViewController.swift
//  28th_BESOPT_2ndWeek_Assignment
//
//  Created by 노한솔 on 2021/04/13.
//

import SnapKit
import TextFieldEffects
import Then
import UIKit

class LoginViewController: UIViewController {
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    self.navigationController?.navigationBar.isHidden = true
  }
  
  // MARK: - Properties
  let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.text = "카카오톡을 시작합니다"
    $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    $0.textAlignment = .center
  }
  let subtitleLabel = UILabel().then {
    $0.textColor = .gray
    $0.text = "사용하던 카카오계정이 있다면\n이메일 또는 전화번호로 로그인해 주세요."
    $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  let emailTextField = HoshiTextField().then {
    // textField placeholder 텍스트 크기 조정을 위해 NSAttributedString 사용
    $0.attributedPlaceholder = NSAttributedString(string: "이메일 또는 전화번호",
                                                  attributes: [NSAttributedString.Key.font :
                                                                UIFont.systemFont(ofSize: 15)])
    $0.placeholderColor = .placeholderText
    $0.borderStyle = .line
    $0.borderInactiveColor = .placeholderText
    $0.clearButtonMode = .whileEditing
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
  }
  let passwordTextField = HoshiTextField().then {
    $0.attributedPlaceholder = NSAttributedString(string: "비밀번호",
                                                  attributes: [NSAttributedString.Key.font :
                                                                UIFont.systemFont(ofSize: 15)])
    $0.placeholderColor = .placeholderText
    $0.borderStyle = .line
    $0.borderInactiveColor = .placeholderText
    $0.clearButtonMode = .whileEditing
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.isSecureTextEntry = true
  }
  let loginButton = UIButton().then {
    $0.setTitle("카카오계정 로그인", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    $0.backgroundColor = .systemGray6
    $0.addTarget(self, action: #selector(touchUpLogin), for: .touchUpInside)
  }
  let signUpButton = UIButton().then {
    $0.setTitle("새로운 카카오계정 만들기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    $0.backgroundColor = .systemGray6
    $0.addTarget(self, action: #selector(touchUpSignUp), for: .touchUpInside)
  }
  
  
  // MARK: - Helpers
  func layout() {
    self.view.add(self.titleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.view.snp.top).offset(100)
        $0.centerX.equalTo(self.view.snp.centerX)
      }
    }
    self.view.add(self.subtitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(25)
        $0.centerX.equalTo(self.view.snp.centerX)
      }
    }
    self.view.add(self.emailTextField) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(65)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.leading.equalTo(self.view.snp.leading).offset(20)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-20)
        $0.height.equalTo(55)
      }
    }
    self.view.add(self.passwordTextField) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.emailTextField.snp.bottom).offset(10)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.leading.equalTo(self.view.snp.leading).offset(20)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-20)
        $0.height.equalTo(55)
      }
    }
    self.view.add(self.loginButton) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.passwordTextField.snp.bottom).offset(30)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.leading.equalTo(self.view.snp.leading).offset(20)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-20)
        $0.height.equalTo(40)
      }
    }
    self.view.add(self.signUpButton) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.loginButton.snp.bottom).offset(10)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.leading.equalTo(self.view.snp.leading).offset(20)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-20)
        $0.height.equalTo(40)
      }
    }
  }
  func loginAction() {
    LoginService.shared.login(email: self.emailTextField.text!,
                              password: self.passwordTextField.text!) {
      result in
      switch result {
      case .success(let message, let token):
        if let message = message as? String {
          if let userToken = token as? String {
            UserDefaults.standard.setValue(userToken, forKey: "userToken")
            let checkToken = UserDefaults.standard.string(forKey: "userToken")
            print("token: \(UserDefaults.standard.string(forKey: "userToken"))")
            print("여기야여기")
            self.makeAlert(title: "알림", message: message, okAction: { _ in
              guard let tabBarVC = self.storyboard?.instantiateViewController(
                      identifier: "TabBarViewController") as? TabBarViewController else { return }
              tabBarVC.modalPresentationStyle = .fullScreen
              self.navigationController?.pushViewController(tabBarVC, animated: true)
            })
          }
        }
      case .requestErr(let message):
        if let message = message as? String {
          self.makeAlert(title: "알림", message: message)
        }
      default:
        print(result)
        self.makeAlert(title: "알림", message: "Error")
      }
    }
  }
  
  @objc func touchUpSignUp() {
    guard let signUpVC = self.storyboard?.instantiateViewController(
            identifier: "SignUpViewController") as? SignUpViewController else { return }
    self.navigationController?.pushViewController(signUpVC, animated: true)
  }
  
  @objc func touchUpLogin() {
    // 1. 모든 텍스트필드에 텍스트가 있을 때
    if self.emailTextField.hasText && self.passwordTextField.hasText {
      self.loginAction()
    }
    // 2. 텍스트필드 중 텍스트가 없는 텍스트필드가 존재할 때
    else {
      let alert = UIAlertController(title: "로그인 실패",
                                    message: "이메일, 비밀번호를 입력해주세요😭",
                                    preferredStyle: UIAlertController.Style.alert)
      let closeAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alert.addAction(closeAction)
      present(alert, animated: true, completion: nil)
    }
  }
}


