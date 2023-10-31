//
//  EditProfileViewController.swift
//  RGRG
//
//  Created by (^ㅗ^)7 iMac on 2023/10/11.
//

import FirebaseAuth
import SnapKit
import UIKit

class EditProfileViewController: UIViewController {
    var user: User?
    let wholeView = UIView()

    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 132, height: 132)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.rgrgColor3.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    let outerImageView: UIView = {
        let newView = UIView()
        newView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        newView.layer.cornerRadius = newView.frame.height / 2
        newView.backgroundColor = .rgrgColor3
        return newView
    }()

    let editImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.image = UIImage(named: "Edit")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let userNameTitle = CustomLabel()
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요"
        return textField
    }()

    let noticeLabel = CustomLabel()

    let tierTitle = CustomLabel()
    let tierButton = CustomButton()

    let positionTitle = CustomLabel()
    let positionButton = CustomButton()

    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()

    let mostChampButton = CustomButton()

    let firstImage = CustomImageView(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
    let secondImage = CustomImageView(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
    let thirdImage = CustomImageView(frame: CGRect(x: 0, y: 0, width: 68, height: 68))

    let mostChampImgStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16.3
        stackView.distribution = .fillEqually
        return stackView

    }()

    let doneEditButton = CustomButton()

    deinit {
        print("### NotificationViewController deinitialized")
    }
}

extension EditProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        FirebaseUserManager.shared.getUserInfo { user in
            self.user = user
            DispatchQueue.main.async {
                self.setBeforeInfo()
                self.setupButtonsActions()
                
            }
        }
    }
}

extension EditProfileViewController {
    func configureUI() {
        view.backgroundColor = .white

        wholeView.backgroundColor = .rgrgColor5
        setupLabels()
        setupTextFields()
        setupButtons()
        setupImageView()
        setShadow()
        setImageTapGesture()
        setupTextField()

        view.addSubview(wholeView)

        wholeView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        outerImageView.addSubview(editImage)
        editImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(1)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }

        [profileImage, outerImageView, userNameTitle, userNameTextField, buttonStackView, tierTitle, positionTitle, mostChampButton, mostChampImgStackView, doneEditButton].forEach { wholeView.addSubview($0) }
        [firstImage, secondImage, thirdImage].forEach { mostChampImgStackView.addArrangedSubview($0) }
        [tierButton, positionButton].forEach { buttonStackView.addArrangedSubview($0) }

        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(132)
        }

        outerImageView.snp.makeConstraints { make in
            make.bottom.equalTo(profileImage.snp.bottom)
            make.right.equalTo(profileImage.snp.right).offset(-2)
            make.height.width.equalTo(30)
        }
        userNameTitle.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(51)
            make.height.equalTo(22)
        }

        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameTitle.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(46)
            make.height.equalTo(52)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(70)
            make.left.right.equalToSuperview().inset(46)
            make.height.equalTo(52)
        }

        tierTitle.snp.makeConstraints { make in
            make.bottom.equalTo(tierButton.snp.top).offset(-8)
            make.left.equalTo(userNameTitle)
            make.height.equalTo(22)
        }

        positionTitle.snp.makeConstraints { make in
            make.bottom.equalTo(tierButton.snp.top).offset(-8)
            make.left.equalTo(positionButton).offset(4)
        }

        mostChampButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(40)
            make.left.equalTo(tierTitle)
            make.height.equalTo(22)
        }

        mostChampImgStackView.snp.makeConstraints { make in
            make.top.equalTo(mostChampButton.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(46)
            make.height.equalTo(68)
            make.width.equalTo(237)
        }

        doneEditButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().offset(-26)
            make.height.equalTo(60)
        }
    }

    func setupLabels() {
        userNameTitle.text = "유저 이름"
        tierTitle.text = "티어"
        positionTitle.text = "포지션"

        [userNameTitle, tierTitle, positionTitle].forEach {
            $0.textColor = UIColor(hex: "#505050")
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        }

        noticeLabel.text = "닉네임을 입력해주세요!"
        noticeLabel.textColor = UIColor.red
        noticeLabel.font = UIFont(name: "NotoSansKR-Bold", size: 12)
    }

    func setupTextFields() {
        userNameTextField.layer.cornerRadius = 10
        userNameTextField.layer.backgroundColor = UIColor.white.cgColor
    }

    func setupButtons() {
        positionButton.setTitleColor(UIColor(hex: "505050"), for: .normal)
        
        [tierButton, positionButton].forEach {
            $0.layer.borderColor = UIColor.rgrgColor6.cgColor
            $0.layer.borderWidth = 2
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.titleLabel?.font = .myMediumSystemFont(ofSize: 16)
            $0.titleLabel?.textAlignment = .left
        }
        

        doneEditButton.backgroundColor = .rgrgColor4
        doneEditButton.layer.cornerRadius = 10
        doneEditButton.setTitle("수정 완료", for: .normal)

        var plainConfigure = UIButton.Configuration.plain()
        plainConfigure.imagePadding = 4
        mostChampButton.configuration = plainConfigure
        mostChampButton.backgroundColor = .clear
        mostChampButton.setTitle("선호 챔피언", for: .normal)
        mostChampButton.titleLabel?.font = .myBoldSystemFont(ofSize: 16)
        mostChampButton.setImage(UIImage(named: "polygon"), for: .normal)
        mostChampButton.setTitleColor(UIColor(hex: "#505050"), for: .normal)
        mostChampButton.semanticContentAttribute = .forceRightToLeft
        

        doneEditButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
    }

    func setShadow() {
        [userNameTextField, tierButton, positionButton].forEach {
            $0.setupShadow(alpha: 0.05, offset: CGSize(width: 2, height: 3), radius: 12, opacity: 1)
        }

        doneEditButton.setupShadow(alpha: 0.25, offset: CGSize(width: 0, height: 4), radius: 4, opacity: 1)
    }

    func setImageTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toChooseIconsVC))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }

    func setNavigationController() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "프로필 수정"
    }

    func setupTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: userNameTextField.frame.height))
        userNameTextField.leftView = paddingView
        userNameTextField.rightView = paddingView
        userNameTextField.leftViewMode = .always
        userNameTextField.rightViewMode = .always
    }

    func setupImageView() {
        [firstImage, secondImage, thirdImage].forEach {
            $0.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.rgrgColor7.cgColor
            $0.clipsToBounds = true
        }
    }

    func setupButtonsActions() {
        let tiers = ["Iron", "Bronze", "Silver", "Gold", "Emerald", "Diamond", "Master", "GrandMaster", "Challenger"]
        var tierOptionArray = [UIAction]()
        let optionClosure = { (_: UIAction) in
            self.tierButton.setTitleColor(UIColor(named: self.tierButton.currentTitle ??  "Bronze"), for: .normal)
        }
        tierButton.setTitleColor(UIColor(named: tierButton.currentTitle ??  "Bronze"), for: .normal)

        for tier in tiers {
            let action = UIAction(title: tier, state: .off, handler: optionClosure)
            tierOptionArray.append(action)
        }
        tierOptionArray[tiers.firstIndex(of: user?.tier ?? "Iron") ?? 0].state = .on
        let tierOptionMenu = UIMenu(options: .displayInline, children: tierOptionArray)

        tierButton.menu = tierOptionMenu
        tierButton.changesSelectionAsPrimaryAction = true
        tierButton.showsMenuAsPrimaryAction = true

        let positions = ["support", "bottom", "mid", "jungle", "top"]
        var positionOptions = [UIAction]()

        for position in positions {
            let action = UIAction(title: position, state: .off, handler: optionClosure)
            positionOptions.append(action)
        }
        positionOptions[positions.firstIndex(of: user?.position ?? "support") ?? 0].state = .on
        let positionOptionMenu = UIMenu(options: .displayInline, children: positionOptions)

        positionButton.menu = positionOptionMenu
        positionButton.changesSelectionAsPrimaryAction = true
        positionButton.showsMenuAsPrimaryAction = true
    }
}

extension EditProfileViewController {
    func setBeforeInfo() {
        StorageManager.shared.getImage("icons", user?.profilePhoto ?? "Default") { [weak self] image in
            self?.profileImage.image = image
        }

        userNameTextField.text = user?.userName
        tierButton.setTitle(user?.tier, for: .normal)
        positionButton.setTitle(user?.position, for: .normal)
    }
}

extension EditProfileViewController {
    @objc func confirmButtonPressed(_ sender: UIButton) {
        let updatedUser = User(email: user?.email ?? "", userName: (userNameTextField.text ?? user?.userName) ?? "", tier: tierButton.titleLabel?.text ?? "", position: positionButton.titleLabel?.text ?? "", profilePhoto: "Default", mostChampion: [])
        if updatedUser.userName == user?.userName, updatedUser.position == user?.position, updatedUser.profilePhoto == user?.profilePhoto, updatedUser.tier == user?.tier, updatedUser.mostChampion == user?.mostChampion {
            let alert = UIAlertController(title: "수정 내역이 없습니다!", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        } else {
            FirebaseUserManager.shared.updateUserInfo(userInfo: updatedUser)
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func toChooseIconsVC() {
        let chooseIconVC = ChooseIconViewController()
        navigationController?.pushViewController(chooseIconVC, animated: true)
    }
}
