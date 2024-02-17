//
//  ViewController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 07.02.2024.
//

import RealmSwift
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldUserSurname: UITextField!
    @IBOutlet weak var textFieldTaskName: UITextField!
    @IBOutlet weak var tasksTableView: UITableView!
    var tableViewCellSelectedIndex = -1
    var realm = try? Realm()
    var myTasks = List<Tasks>()

    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldUserName.text = UserDefaults.standard.string(forKey: "textFieldUserName")
        textFieldUserSurname.text = UserDefaults.standard.string(forKey: "textFieldUserSurname")

        if let unwrapeRealm = realm {
            for t in unwrapeRealm.objects(Tasks.self) {
                myTasks.append(t)
            }
        }

    }

    @IBAction
    func textFieldNameEditingEnd(_ sender: Any) {
        UserDefaults.standard.setValue(textFieldUserName.text, forKey: "textFieldUserName")
    }

    @IBAction
    func buttonAddTaskTouchUp(_ sender: Any) {
        if textFieldTaskName.text?.isEmpty == true {
            textFieldTaskName.placeholder = "Enter task name before will touch add button"
            return
        }

        let task = Tasks()
        task.name = textFieldTaskName.text ?? ""
        myTasks.append(task)
        do {
            try realm?.write {
                realm?.add(task)
            }
        } catch {
            print(error.localizedDescription)
        }
        textFieldTaskName.text = ""
        tasksTableView.reloadData()
    }

    @IBAction
    func buttonRemoveTaskTouchUp(_ sender: Any) {
        if tableViewCellSelectedIndex != -1 && !myTasks.isEmpty {
            let task = myTasks[tableViewCellSelectedIndex]
            do {
                try realm?.write {
                    realm?.delete(task)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            myTasks.remove(at: tableViewCellSelectedIndex)
            tableViewCellSelectedIndex = -1
            tasksTableView.reloadData()
        }
    }

    @IBAction
    func textFieldSurnameEditingEnd(_ sender: Any) {
        UserDefaults.standard.setValue(textFieldUserSurname.text, forKey: "textFieldUserSurname")
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TasksTableViewCell else { return UITableViewCell.init() }

        cell.labelNumberTask.text = "#\(indexPath.row + 1)"
        cell.labelTaskName.text = myTasks[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewCellSelectedIndex = indexPath.row
    }
}
