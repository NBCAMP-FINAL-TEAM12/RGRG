//
//  LoginViewController.swift
//  RGRG
//
//  Created by (^ㅗ^)7 iMac on 2023/10/11.
//

import FirebaseAuth
import FirebaseCore
import SnapKit
import UIKit

class SettingViewController: UIViewController {
    let developInfoVC = DeveloperInfoViewController()
    let reportVC = ReportViewController()

    let settingList = [
        "로그아웃", "회원탈퇴", "신고하기", "개발자 정보"
    ]

    let settingTable: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    let loginVC = LoginViewController()

    deinit {
        print("### NotificationViewController deinitialized")
    }
}

extension SettingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        configureUI()
        setupSettingTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        configureUI()
        setupSettingTable()
    }
}

extension SettingViewController {
    func configureUI() {
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        view.addSubview(settingTable)

        settingTable.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setupNavigationBar() {
        navigationItem.title = "환경 설정"
    }
}

extension SettingViewController {
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func deleteUser() {
        if let user = Auth.auth().currentUser {
            user.delete { [self] error in
                if let error = error {
                    print("Firebase Error : ", error)
                } else {
                    print("회원탈퇴 성공!")
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다")
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func setupSettingTable() {
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.textLabel?.text = settingList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settingList[indexPath.row]
        if indexPath.row == 0 {
            signOut()
            navigationController?.pushViewController(loginVC, animated: true)
            removeAllNavigationStack()
        }
        if indexPath.row == 1 {
            deleteUser()
            navigationController?.popToRootViewController(animated: true)
        }

        if indexPath.row == 2 {
            reportVC.title = item

            navigationController?.pushViewController(reportVC, animated: true)
        }

        if indexPath.row == 3 {
            developInfoVC.title = item
            developInfoVC.viewWillAppear(true)
            navigationController?.pushViewController(developInfoVC, animated: true)
        }
    }
}

extension SettingViewController {
    func removeAllNavigationStack() {
        guard let navigationController = navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!) // To remove all previous UIViewController except the last one
        self.navigationController?.viewControllers = navigationArray
    }
}
