//
//  EntryViewController.swift
//  TodoList
//
//  Created by 정나래 on 2021/05/22.
//
import RealmSwift
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField:UITextField!
    @IBOutlet var datePicker:UIDatePicker!

    private let realm = try! Realm()
    public var completioneHandler:(()-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.becomeFirstResponder()
        textField.delegate = self

        datePicker.setDate(Date(), animated: true )

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self , action: #selector(didTapSaveButton))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func didTapSaveButton() {
        if let text=textField.text, !text.isEmpty {
            let data = datePicker.date

            realm.beginWrite()

            let newItem = TodoListItem()
            newItem.date = data
            newItem.item = text

            realm.add(newItem)

            try! realm.commitWrite()

            completioneHandler?()

            navigationController?.popToRootViewController(animated: true )

        } else {
            print("저장하였습니다.")
        }
    }

}
