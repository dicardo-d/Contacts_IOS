//
//  Contact.swift
//  Contacts
//
//  Created by Divya Khemani on 2022-08-15.
//

import Foundation

class ContactModel: Decodable, Encodable {
    var firstName = ""
    var lastName = ""
    var phone = ""
    var email = ""
    var contactID = ""
    
    init(contactID: String, firstName: String, lastName: String, phone: String, email: String) {
        self.contactID = contactID
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
    }
}
