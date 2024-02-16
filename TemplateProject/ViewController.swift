//
//  ViewController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 07.02.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldUserSurname: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldUserName.text = UserDefaults.standard.string(forKey: "textFieldUserName")
        textFieldUserSurname.text = UserDefaults.standard.string(forKey: "textFieldUserSurname")
    }

    @IBAction
    func textFieldNameEditingEnd(_ sender: Any) {
        UserDefaults.standard.setValue(textFieldUserName.text, forKey: "textFieldUserName")
    }

    @IBAction
    func textFieldSurnameEditingEnd(_ sender: Any) {
        UserDefaults.standard.setValue(textFieldUserSurname.text, forKey: "textFieldUserSurname")
    }
}
