//
//  ViewController.swift
//  TodoList
//
//  Created by 정나래 on 2021/05/19.
//

import UIKit
import RealmSwift

class TodoListItem: Object {
    @objc dynamic var item:String = ""
    @objc dynamic var date:Date = Date()

}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    private let realm = try! Realm()
    private var data = [TodoListItem]()


    override func viewDidLoad() {
        super.viewDidLoad()
        data=realm.objects(TodoListItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }

    // MARK: table관련
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].item
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = data[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {
            return
        }

        vc.item = item
        vc.deletionHandler = {[weak self] in
            self?.refresh()
        }
        vc.title = item.item
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }
        vc.completioneHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "새로운 아이템"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    func refresh(){
        data=realm.objects(TodoListItem.self).map({ $0 })
        table.reloadData() 
    }
    
}

