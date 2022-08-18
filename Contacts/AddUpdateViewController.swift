//
//  AddUpdateViewController.swift
//  Contacts
//
//  Created by Divya Khemani on 2022-08-15.
//

import UIKit

class AddUpdateViewController: UIViewController, UITextFieldDelegate {
    
    var contactModel: ContactModel?
    var delegate: AddUpdateProtocol?
    
    @IBOutlet weak var firstNameTf: UITextField!
    @IBOutlet weak var lastNameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contactModel = contactModel {
            firstNameTf.text = contactModel.firstName
            lastNameTf.text = contactModel.lastName
            phoneTf.text = contactModel.phone
            emailTf.text = contactModel.email
        }
        
        deleteButton.isHidden = contactModel == nil ? true : false
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            firstNameTf.text = textField.text
            break;
        case 1:
            lastNameTf.text = textField.text
            break;
        case 2:
            phoneTf.text = textField.text
            break;
        case 3:
            emailTf.text = textField.text
            break;
        default:
            firstNameTf.text = ""
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton!) {
        view.endEditing(true)
        contactModel = ContactModel(contactID: contactModel == nil ? UUID().uuidString : contactModel!.contactID, firstName: firstNameTf.text!, lastName: lastNameTf.text!, phone: phoneTf.text!, email: emailTf.text!)
        guard let contactModel = contactModel else {
            return
        }
        
        delegate?.contactDidSave(contact: contactModel)
        dismiss(animated: true)
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton!) {
        if let contactModel = contactModel {
            delegate?.contactDidDelete(contact: contactModel)
            dismiss(animated: true)
        }
    }

}
