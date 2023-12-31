//
//  LoginViewController.swift
//  RGRG
//
//  Created by kiakim iMac on 2023/10/11.

import FirebaseAuth
import FirebaseCore
import SnapKit
import UIKit

enum MemberInfoBox: String {
    case loginEmail
    case loginPW
    case email
    case pw
    case pwCheck
    case userName
    case resetPW
}

class LoginViewController: UIViewController {
    var loginIdPass: Bool = false
    var loginPwPass: Bool = false
    
    let bodyContainer = {
        let stactview = UIView()
        return stactview
    }()
    
    let imageArea = {
        let view = UIView()
        return view
    }()
    
    let mainImage = {
        let title = UIImageView()
        return title
    }()
    
    let methodArea = {
        let view = UIView()
        return view
    }()
    
    let emailLine = {
        let line = CustomMemberInfoBox(id: .loginEmail, placeHolder: "Email", condition: "^[A-Za-z0-9+_.-]+@(.+)$", cellHeight: 60, style: "Login")
        return line
    }()
    
    let passwordLine = {
        let line = CustomMemberInfoBox(id: .loginPW, placeHolder: "Password", condition: "^[a-zA-Z0-9]{7,}$", cellHeight: 60, style: "Login")
        line.inputBox.isSecureTextEntry = true
        return line
    }()
    
    let loginButton = {
        let button = CtaLargeButton(titleText: "로그인")
        return button
    }()
    
    let underLineArea = {
        let view = UIStackView()
        view.axis = .vertical
        return view
        
    }()
    
    let signupButton = {
        let button = UIButton()
        return button
    }()
    
    let resetPW = {
        let button = UIButton()
        return button
    }()
    
    // 오버라이딩 : 재정의
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgrgColor4
        setupUI()
        passValueCheck()
        makeBackButton()
        setupKeyboardEvent()
        hideKeyboardEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        emailLine.becomeFirstResponder()
        emailLine.inputBox.text = ""
        passwordLine.inputBox.text = ""
    }
}

extension LoginViewController {
    @objc func gotoSignupPage() {
        let signupVC = SignUpViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc func gotoResetPassword() {
        let resetPasswordVC = resetPassword()
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    
    @objc func tapLogin() {
        loginButton.isEnabled = false
        signInUser()
        
    }
    
    func signInUser() {
        let email = emailLine.inputBox.text ?? ""
        let password = passwordLine.inputBox.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
            if authResult == nil {
                if self.loginIdPass, self.loginPwPass {
                    showAlert(title: "로그인 실패", message: "일치하는 회원정보가 없습니다.")
                    loginButton.isEnabled = true
                } else {
                    showAlert(title: "", message: "작성 형식을 확인해주세요")
                    loginButton.isEnabled = true
                }
                if let errorCode = error {
                    print(errorCode)
                }
            } else if authResult != nil {
                moveToMain()
            }
        }
    }
    
    func moveToMain() {
        let movePage = TabBarController()
        navigationController?.pushViewController(movePage, animated: true)
    }
    
    func passValueCheck() {
        emailLine.passHandler = { pass in
            self.loginIdPass = pass
        }
        passwordLine.passHandler = { pass in
            self.loginPwPass = pass
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController {
    func makeBackButton() {
        let backButton = CustomBackButton(title: "Back", style: .plain, target: self, action: #selector(tappedBackButton))
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func tappedBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension LoginViewController {
    func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func hideKeyboardEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController {
    func setupUI() {
        view.addSubview(bodyContainer)
        bodyContainer.addSubview(imageArea)
        imageArea.addSubview(mainImage)
        bodyContainer.addSubview(methodArea)
        methodArea.addSubview(emailLine)
        methodArea.addSubview(passwordLine)
        methodArea.addSubview(loginButton)
        methodArea.addSubview(underLineArea)
        underLineArea.addArrangedSubview(signupButton)
        underLineArea.addArrangedSubview(resetPW)
        
        loginButton.addTarget(self, action: #selector(tapLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(gotoSignupPage), for: .touchUpInside)
        
        let attributedTitleSignup = NSAttributedString(string: "회원가입", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        let attributedTitleResetPW = NSAttributedString(string: "비밀번호 찾기", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        
        bodyContainer.layer.borderColor = UIColor.systemGray5.cgColor
        bodyContainer.layer.cornerRadius = 10
        bodyContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(47)
            make.right.equalToSuperview().inset(46)
        }
        imageArea.layer.borderColor = UIColor.systemGray5.cgColor
        imageArea.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        mainImage.layer.borderColor = UIColor.systemGray5.cgColor
        mainImage.image = UIImage(named: "LoginMain")
        mainImage.contentMode = .scaleAspectFit
        mainImage.snp.makeConstraints { make in
            make.height.equalTo(310)
            make.width.equalTo(326)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        methodArea.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        emailLine.snp.makeConstraints { make in
            make.bottom.equalTo(passwordLine.snp.top).offset(-20)
            make.left.right.equalToSuperview()
        }
        passwordLine.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.top).offset(-20)
            make.left.right.equalToSuperview()
        }
        loginButton.backgroundColor = UIColor.rgrgColor3
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(underLineArea.snp.top).offset(-15)
            make.left.right.equalToSuperview()
        }
        underLineArea.distribution = .fillEqually
        underLineArea.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(180)
            make.bottom.equalTo(bodyContainer.snp.bottom).offset(-60)
            make.centerX.equalToSuperview()
        }
        signupButton.setAttributedTitle(attributedTitleSignup, for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        signupButton.snp.makeConstraints { make in
        }
        resetPW.setAttributedTitle(attributedTitleResetPW, for: .normal)
        resetPW.setTitleColor(UIColor.white, for: .normal)
        resetPW.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        resetPW.addTarget(self, action: #selector(gotoResetPassword), for: .touchUpInside)
    }
}
