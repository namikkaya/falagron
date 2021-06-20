//
//  KayaPicker.swift
//  falagron
//
//  Created by namik kaya on 18.04.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

protocol KayaPickerDataProtocol {
    associatedtype PickerDataType
    var items: [PickerDataType] { set get }
    mutating func add(item: PickerDataType)
    mutating func remove(index: Int) -> PickerDataType
    func getAllData() -> [PickerDataType]
    func getCount() -> Int
}

struct KayaPickerStringData: KayaPickerDataProtocol {
    func getCount() -> Int {
        return items.count
    }
    
    var items: [String]
    
    mutating func add(item: String) {
        items.append(item)
    }
    
    mutating func remove(index: Int) -> String {
        items.remove(at: index)
    }
    
    func getAllData() -> [String] {
        return items
    }
    
    typealias PickerDataType = String
}

class KayaPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var pickerStringData: KayaPickerStringData?
    var pickerType:PickerType = .string
    
    var textField: UITextField?
    var selectedIndex: Int?
    
    var callBackEvent: ((_ selectedIndex: Int?) -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(toolBarWidth frame: CGRect,
                     field textField: UITextField,
                     data:KayaPickerStringData,
                     defaultSelectedIndex:Int = 0,
                     callBack: @escaping ((_ selectedIndex: Int?) -> ()) ) {
        let height = frame.height < 240 ? 240 : frame.height
        let _frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        self.init(frame: _frame)
        self.pickerStringData = data
        self.pickerType = .string
        self.selectedIndex = defaultSelectedIndex
        self.callBackEvent = callBack
        self.textField = textField
        setup(textField: textField)
    }
    
    deinit {
        callBackEvent = nil
        selectedIndex = nil
        textField = nil
        pickerStringData = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(textField: UITextField) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 44.0))
        toolBar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(sexAction))
        toolBar.setItems([flexible, barButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        self.dataSource = self
        self.delegate = self
        textField.inputView = self
        self.selectRow(self.selectedIndex ?? 0, inComponent: 0, animated: true)
    }
}

extension KayaPicker {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.pickerType {
        case .string: return pickerStringData?.getCount() ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.pickerType {
        case .string: return pickerStringData?.items[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    @objc func sexAction() {
        self.endEditing(true)
        callBackEvent?(selectedIndex)
        textField?.resignFirstResponder()
    }
    
    @objc func dismissPicker() {
        //view.endEditing(true)
        print("Test dismiss")
    }
}

extension KayaPicker {
    enum PickerType {
        case string
    }
}
