//
//  CustomTextField.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 23/08/2022.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextInput(placeholderText: "Search City")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextInput(placeholderText: String){
        placeholder = placeholderText
        borderStyle = .none
        backgroundColor = .systemGray2
        textColor = .black.withAlphaComponent(0.8)
        font = UIFont(name: "Avenir-Medium", size: 16)
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
        layer.borderWidth = 0.0
        layer.cornerRadius = 52/2
        layer.borderColor = UIColor.systemGray4.cgColor
        autocorrectionType = .no
        autocapitalizationType = .none
        clearButtonMode = .whileEditing
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
}

