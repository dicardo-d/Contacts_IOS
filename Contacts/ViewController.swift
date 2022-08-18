//
//  ViewController.swift
//  Contacts
//
//  Created by Divya Khemani on 2022-08-15.
//

import UIKit

protocol AddUpdateProtocol {
    func contactDidSave(contact: ContactModel)
    
    func contactDidDelete(contact: ContactModel)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddUpdateProtocol, UISearchBarDelegate {
    
    var contactsArray: [ContactModel] = []
    var filteredContactsArray: [ContactModel] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        loadDataFromUserDefaults()
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")! as UITableViewCell
        cell.textLabel?.text = filteredContactsArray[indexPath.row].firstName + " " + filteredContactsArray[indexPath.row].lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openAddViewContact(contact: filteredContactsArray[indexPath.row])
    }
    
    @IBAction func addButtonAction(_ sender: UIButton!) {
        openAddViewContact(contact: nil)
    }
    
    func openAddViewContact(contact: ContactModel?) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUpdateViewController") as! AddUpdateViewController
        vc.delegate = self
        vc.contactModel = contact
        present(vc, animated: true)
    }
    
    func contactDidSave(contact: ContactModel) {
        var found = false
        for (i,model) in contactsArray.enumerated() {
            if model.contactID == contact.contactID {
                contactsArray.remove(at: i)
                contactsArray.insert(contact, at: i)
                found = true
                break
            }
        }
        if !found {
            contactsArray.append(contact)
        }
        filteredContactsArray.removeAll()
        filteredContactsArray = contactsArray
        saveToUserDefaults()
        tableView.reloadData()
    }
    
    func contactDidDelete(contact: ContactModel) {
        var found = false
        for (i,model) in contactsArray.enumerated() {
            if model.contactID == contact.contactID {
                contactsArray.remove(at: i)
                found = true
                break
            }
        }
        if found {
            filteredContactsArray.removeAll()
            filteredContactsArray = contactsArray
            saveToUserDefaults()
            tableView.reloadData()
        }
    }

    func saveToUserDefaults() {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(contactsArray)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "contacts")

        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func loadDataFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "contacts") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let contacts = try decoder.decode([ContactModel].self, from: data)
                
                contactsArray = contacts
                filteredContactsArray = contacts
                filteredContactsArray = filteredContactsArray.sorted{ $0.firstName.compare($1.firstName) == .orderedAscending && $0.lastName.compare($1.lastName) == .orderedAscending }
                tableView.reloadData()

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredContactsArray = contactsArray
        } else {
            filteredContactsArray = filteredContactsArray.filter { $0.firstName.lowercased().contains(searchText.lowercased()) || $0.lastName.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
