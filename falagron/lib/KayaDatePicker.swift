//
//  KayaDatePicker.swift
//  falagron
//
//  Created by namik kaya on 12.05.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class KayaDatePicker: UIDatePicker {
    
    // Age of 18.
    let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!;
    
    // Age of 100.
    let MAXIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -100, to: Date())!;
    
    var callBackEvent: ((_ selectedDate: Date?) -> ())?
    
    var textField: UITextField?
    var pickerSelectedDate: Date?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(toolBarWidth frame: CGRect,
                     field textField: UITextField,
                     selectedDate:Date = Date(),
                     callBack: @escaping ((_ selectedDate: Date?) -> ()) ) {
        let height = frame.height < 240 ? 240 : frame.height
        let _frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        self.init(frame: _frame)
        self.callBackEvent = callBack
        self.textField = textField
        /*self.maximumDate = MINIMUM_AGE
        self.minimumDate = MAXIMUM_AGE*/
        self.set18YearValidation()
        self.date = selectedDate
        self.datePickerMode = .date //2
        if #available(iOS 13.4, *) {
            self.preferredDatePickerStyle = .wheels
        }
        self.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        setup(textField: textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(textField: UITextField) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 44.0))
        toolBar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(selectedAction))
        toolBar.setItems([flexible, barButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        textField.inputView = self
    }
    
    @objc private func handleDatePicker(sender:UIDatePicker) {
        /*let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
        }*/
        pickerSelectedDate = sender.date
        //callBackEvent?(sender.date)
    }
    
    @objc func selectedAction() {
        self.endEditing(true)
        callBackEvent?(pickerSelectedDate)
        textField?.resignFirstResponder()
    }
    
    @objc func dismissPicker() {
        //view.endEditing(true)
        print("Test dismiss")
    }
    
}
