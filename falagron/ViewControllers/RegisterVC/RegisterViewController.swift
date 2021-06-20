//
//  RegisterViewController.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

extension RegisterViewController {
    enum RowType {
        case textCell(type:InputType, placeHolder:String)
    }
    
    enum SectionType {
        case userBase(title:String, rows:[RowType]) // Email, password
        case userInfo(title:String, rows:[RowType]) // Diğerleri
    }
    
    enum InputType {
        case name
        case lastName
        case email
        case password
        case birthDay
        case loveStatus
        case sex
        case work
        
        var getTagIndex:Int {
            switch self {
            case .name:
                return 2
            case .lastName:
                return 3
            case .email:
                return 0
            case .password:
                return 1
            case .birthDay:
                return 4
            case .loveStatus:
                return 5
            case .sex:
                return 6
            case .work:
                return 7
            }
        }
        var getTagSection:Int {
            switch self {
            case .name,.lastName:
                return 0
            default: return 1
            }
        }
    }
}

extension RegisterViewController {
    func updateUI() {
        rows.removeAll()
        rows.append(.userBase(title: "Gerekli Bilgiler", rows: [.textCell(type: .email, placeHolder: "E-posta"),
                                                                .textCell(type: .password, placeHolder: "Şifre(6 Karakter 1 Büyük Harf ve Sayı)")]))
        
        rows.append(.userInfo(title: "Kişisel Bilgiler", rows: [.textCell(type: .name, placeHolder: "İsim"),
                                                                 .textCell(type: .lastName, placeHolder: "Soyisim"),
                                                                 .textCell(type: .birthDay, placeHolder: "Doğum Tarihi"),
                                                                 .textCell(type: .loveStatus, placeHolder: "İlişki Durumu"),
                                                                 .textCell(type: .sex, placeHolder: "Cinsiyet"),
                                                                 .textCell(type: .work, placeHolder: "İş Durumu")]))
        self.tableView.reloadData()
    }
}

class RegisterViewController: AuthenticationBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var rows:[SectionType] = []
    var activeField: UITextField?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    
    var birthDayTextField:UITextField?
    var loveTextField:UITextField?
    var sexTextField:UITextField?
    var workTextField:UITextField?
    
    var sexData:UserInformationDataModel!
    var loveData:UserInformationDataModel!
    var workData:UserInformationDataModel!
    
    // sending Data
    var nameHolder:String?
    var lastNameHolder:String?
    var emailHolder:String?
    var passwordHolder:String?
    var loveHolder:StatusItem?
    var birthDayHolder:Date?
    var sexHolder:StatusItem?
    var workHolder:StatusItem?
    
    @IBOutlet weak var registerButton: KYSpinnerButton! {
        didSet {
            registerButton.addDropShadow(cornerRadius: 8,
                                         shadowRadius: 0,
                                         shadowOpacity: 0,
                                         shadowColor: .clear,
                                         shadowOffset: .zero)
        }
    }
    @IBOutlet weak var buttonStage: UIView! {
        didSet{
            buttonStage.addDropShadow(cornerRadius: 0,
                                      shadowRadius: 3,
                                      shadowOpacity: 0.5,
                                      shadowColor: .black,
                                      shadowOffset: CGSize(width: 0, height: -2))
        }
    }
    
    deinit {
        deStroy()
    }
    
    private func deStroy(){
        print("XYZ: \(self.className) destroy")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.setNavigationBarTitle(titleText: "Profil Bilgileri")
        createFormData()
        updateUI()
        tableView.layoutIfNeeded()
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? RegisterTextFieldCell {
            cell.textField.becomeFirstResponder()
        }
        loveCreatePickerView()
        sexCreatePickerView()
        workCreatePickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let closeButton = closeButtonSetup()
        closeButton.addTarget(self, action: #selector(closeButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        addKeyboardListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardListener()
    }
    
    @objc private func closeButtonEvent(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonEvent(_ sender: Any) {
        sendData()
    }
    
    private func sendData() {
        let tupple = checkStringData()
        if tupple.status {
            registerButton.setStatus = .processing
            var sendingUserData = registerDataParse(name: nameHolder ?? "", email: emailHolder ?? "", lastName: lastNameHolder ?? "", password: passwordHolder ?? "", birthDay: birthDayHolder ?? Date(), loveAllData: loveData, sexAllData: sexData, workAllData: workData)
            if let email = sendingUserData[emailKey] as? String, let password = sendingUserData[passwordKey] as? String {
                sendingUserData[passwordKey] = ""
                self.tableView.isUserInteractionEnabled = false
                FirebaseManager.shared.newUser(email: email, password: password, data: sendingUserData) { [weak self] (status:Bool, message:String?) in
                    guard let self = self else { return }
                    self.registerButton.setStatus = .normal
                    if status {
                        self.infoMessage(message: "Tebrikler üyeliğiniz başladı.", buttonTitle: "Tamam") {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else {
                        self.infoMessage(message: message ?? "Bir hata oluştu.", buttonTitle: "Tamam")
                    }
                }
            }else {
                registerButton.setStatus = .normal
            }
        }else {
            infoMessage(message: tupple.message, buttonTitle: "Anladım")
        }
    }
    
    private func createFormData() {
        sexData = UserInformationDataModel(id: "sex", type: UserInfoDataType.sex)
        loveData = UserInformationDataModel(id: "love", type: UserInfoDataType.love)
        workData = UserInformationDataModel(id: "work", type: UserInfoDataType.work)
    }
}
extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        let cells = [RegisterTextFieldCell.self, UITableViewCell.self]
        self.tableView.register(cellTypes: cells)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = 60
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = rows[safe: section] else { return 1 }
        
        switch type {
        case .userBase(_ , let rows): return rows.count
        case .userInfo(_, let rows): return rows.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return rows.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = rows[safe: indexPath.section] else { return UITableViewCell() }
        switch type {
        case .userBase(_, let rows):
            let cellType = rows[safe: indexPath.row]
            switch cellType {
            case .textCell(let type, let placeHolder):
                let cell = tableView.dequeueReusableCell(with: RegisterTextFieldCell.self, for: indexPath)
                cell.setup(type: type, placeHolder: placeHolder)
                cell.textField.delegate = self
                switch type {
                case .email:
                    cell.textField.keyboardType = .emailAddress
                    cell.textField.returnKeyType = .next
                    if #available(iOS 12.0, *) {
                        cell.textField.textContentType = UITextContentType.oneTimeCode
                    }
                    break
                case .name:
                    cell.textField.keyboardType = .namePhonePad
                    cell.textField.returnKeyType = .next
                    break
                case .lastName:
                    cell.textField.keyboardType = .namePhonePad
                    cell.textField.returnKeyType = .next
                    break
                case .password:
                    cell.textField.keyboardType = .asciiCapable
                    cell.textField.isSecureTextEntry = true
                    cell.textField.returnKeyType = .next
                    if #available(iOS 12.0, *) {
                        cell.textField.textContentType = UITextContentType.oneTimeCode
                    }
                    break
                case .birthDay:
                    cell.textField.keyboardType = .default
                    cell.textField.returnKeyType = .next
                    break
                case .loveStatus:
                    cell.textField.keyboardType = .default
                    cell.textField.returnKeyType = .next
                    break
                case .sex:
                    cell.textField.keyboardType = .default
                    cell.textField.returnKeyType = .next
                    break
                case .work:
                    cell.textField.keyboardType = .default
                    cell.textField.returnKeyType = .done
                    break
                }
                return cell
            default : return UITableViewCell()
            }
        case .userInfo(_, let rows):
            let cellType = rows[safe: indexPath.row]
            switch cellType {
            case .textCell(let type, let placeHolder):
                let cell = tableView.dequeueReusableCell(with: RegisterTextFieldCell.self, for: indexPath)
                cell.setup(type: type, placeHolder: placeHolder)
                cell.textField.delegate = self
                switch type {
                case .email:
                    cell.textField.keyboardType = .emailAddress
                    cell.textField.becomeFirstResponder()
                    cell.textField.returnKeyType = .next
                    if #available(iOS 12.0, *) {
                        cell.textField.textContentType = UITextContentType.oneTimeCode
                    }
                    break
                case .name:
                    cell.textField.keyboardType = .namePhonePad
                    cell.textField.returnKeyType = .next
                    break
                case .lastName:
                    cell.textField.keyboardType = .namePhonePad
                    cell.textField.returnKeyType = .next
                    break
                case .password:
                    cell.textField.keyboardType = .asciiCapable
                    cell.textField.isSecureTextEntry = true
                    cell.textField.returnKeyType = .next
                    if #available(iOS 12.0, *) {
                        cell.textField.textContentType = UITextContentType.oneTimeCode
                    }
                    break
                case .birthDay:
                    cell.textField.keyboardType = .default
                    cell.textField.returnKeyType = .next
                    cell.textField.setInputViewDatePicker(target: self, selector: #selector(tapDone(sender:datePicker1:)))
                    birthDayTextField = cell.textField
                    break
                case .loveStatus:
                    cell.textField.keyboardType = .default
                    cell.textField.returnKeyType = .next
                    loveTextField = cell.textField
                    break
                case .sex:
                    cell.textField.keyboardType = .default
                    cell.textField.returnKeyType = .next
                    sexTextField = cell.textField
                    break
                case .work:
                    cell.textField.keyboardType = .default
                    cell.textField.returnKeyType = .done
                    workTextField = cell.textField
                    break
                }
                return cell
            default : return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension RegisterViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = RegisterHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        guard let type = rows[safe: section] else { return UIView() }
        switch type {
        case .userBase(let title, _):
            view.setTitle(title: title)
        case .userInfo(let title, _):
            view.setTitle(title: title)
        }
        return view
    }
}

extension RegisterViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let txtTag:Int = textField.tag
        if let textFieldNxt = self.view.viewWithTag(txtTag+1) as? UITextField {
            textFieldNxt.becomeFirstResponder()
            activeField = textFieldNxt
        }else{
            textField.resignFirstResponder()
            sendData()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let txtTag:Int = textField.tag
        if let textFieldNxt = self.view.viewWithTag(txtTag+1) as? UITextField {
            activeField = textFieldNxt
            if let textFieldNxt = self.view.viewWithTag(txtTag+1) as? UITextField {
                if let parentCell = textFieldNxt.superview?.superview as? RegisterTextFieldCell {
                    if let cellIndexPath = tableView.indexPath(for: parentCell) {
                        self.tableView.scrollToRow(at: cellIndexPath, at: .bottom, animated: true)
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        let currentText = isBackSpace == -92 ? String(textField.text![..<textField.text!.index(before: textField.text!.endIndex)]) : textField.text! + string
        
        switch textField.tag {
        case 0:
            emailHolder = currentText
            return true
        case 1:
            passwordHolder = currentText
            return true
        case 2:
            nameHolder = currentText
            return true
        case 3:
            lastNameHolder = currentText
            return true
        default: break
        }
        return false
    }
}

extension RegisterViewController {
    private func addKeyboardListener () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(with:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardListener() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(with notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 66 + 4, right: 0)
            UIView.animate(withDuration: duration) {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    let bottomPadding = window?.safeAreaInsets.bottom
                    self.bottomConstraint.constant = keyboardSize.height - (bottomPadding ?? 0)
                }else {
                    self.bottomConstraint.constant = keyboardSize.height
                }
                
                //self.tableViewBottomConstraint.constant = -(keyboardSize.height+66)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(with notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.bottomConstraint.constant = 0
                //self.tableViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension RegisterViewController {
    @objc func tapDone(sender: Any, datePicker1: UIDatePicker) {
        guard let textfield = birthDayTextField else { return }
        if let datePicker = textfield.inputView as? UIDatePicker {
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .automatic
            }
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd.MM.yyyy"
            textfield.text = dateformatter.string(from: datePicker.date)
            birthDayHolder = datePicker.date
        }
        _ = textFieldShouldReturn(textfield)
    }
}

extension RegisterViewController:  UIPickerViewDelegate, UIPickerViewDataSource{
    func loveCreatePickerView() {
        guard let loveTextField = loveTextField else { return }
        let pickerView = UIPickerView()
        pickerView.tag = 1
        pickerView.delegate = self
        loveTextField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Tamam", style: .plain, target: target, action: #selector(loveAction))
        toolBar.setItems([flexible, barButton], animated: false) //8
        loveTextField.inputAccessoryView = toolBar
    }
    
    func sexCreatePickerView() {
        guard let sexTextField = sexTextField else { return }
        let pickerView = UIPickerView()
        pickerView.tag = 2
        pickerView.delegate = self
        sexTextField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Tamam", style: .plain, target: target, action: #selector(sexAction))
        toolBar.setItems([flexible, barButton], animated: false) //8
        sexTextField.inputAccessoryView = toolBar
    }
    
    func workCreatePickerView() {
        guard let workTextField = workTextField else { return }
        let pickerView = UIPickerView()
        pickerView.tag = 3
        pickerView.delegate = self
        workTextField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Tamam", style: .plain, target: target, action: #selector(workAction))
        toolBar.setItems([flexible, barButton], animated: false) //8
        workTextField.inputAccessoryView = toolBar
    }
    
    @objc func loveAction() {
        guard let loveTextField = loveTextField else { return }
        _ = textFieldShouldReturn(loveTextField)
    }
    @objc func sexAction() {
        guard let sexTextField = sexTextField else { return }
        _ = textFieldShouldReturn(sexTextField)
    }
    @objc func workAction () {
        guard let workTextField = workTextField else { return }
        _ = textFieldShouldReturn(workTextField)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return loveData.items.count
        }else if pickerView.tag == 2 {
            return sexData.items.count
        }else if pickerView.tag == 3 {
            return workData.items.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return loveData.items[row].name
        }else if pickerView.tag == 2 {
            return sexData.items[row].name
        }else if pickerView.tag == 3 {
            return workData.items[row].name
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            guard let loveTextField = loveTextField else { return }
            loveTextField.text = loveData.items[row].name
            loveHolder = loveData.items[row]
            
            for (index,element) in loveData.items.enumerated() {
                loveData.items[index].status = loveData.items[row].id == element.id
            }
        }else if pickerView.tag == 2 {
            guard let sexTextField = sexTextField else { return }
            sexTextField.text = sexData.items[row].name
            sexHolder = sexData.items[row]
            for (index, element) in sexData.items.enumerated() {
                sexData.items[index].status = sexData.items[row].id == element.id
            }
        }else if pickerView.tag == 3 {
            guard let workTextField = workTextField else { return }
            workTextField.text = workData.items[row].name
            workHolder = workData.items[row]
            for (index, element) in workData.items.enumerated() {
                workData.items[index].status = workData.items[row].id == element.id
            }
        }
    }
}

extension RegisterViewController {
    // return
    func checkStringData() -> (status:Bool, message: String){
        
        guard let email = emailHolder?.trimmingCharacters(in: .whitespacesAndNewlines), email.isEmail() else {
            return (false, "E-posta adresi hatalı.")
        }
        
        guard let password = passwordHolder?.trimmingCharacters(in: .whitespacesAndNewlines), password.isValidPassword() else {
            return (false, "Lütfen şifrenizin 6 karakterden oluştuğuna bir büyük harf ve en az bir sayı içerdiğinden emin olun.")
        }
        
        guard let name = nameHolder?.trimmingCharacters(in: .whitespacesAndNewlines), name != "" else {
            return (false, "Lütfen isminizi boş bırakmayın.")
        }
        
        guard let lastName = lastNameHolder?.trimmingCharacters(in: .whitespacesAndNewlines), lastName != "" else {
            return (false, "Lütfen isminizi boş bırakmayın.")
        }
        
        guard birthDayHolder != nil else {
            return (false, "Lütfen soyisminizi boş bırakmayın.")
        }
        
        /*let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        print("birthDay \(dateformatter.string(from: birthDay))")*/
        guard loveHolder != nil else {
            return (false, "Lütfen ilişki durumunu belirtiniz.")
        }
        
        guard sexHolder != nil else {
            return (false, "Lütfen cinsiyetinizi belirtiniz.")
        }
        
        guard workHolder != nil else {
            return (false, "Lütfen iş durumunuzu belirtiniz.")
        }
        
        return (status:true, message:"")
    }
    
    func registerDataParse(name:String,
                           email:String,
                           lastName:String,
                           password:String,
                           birthDay:Date,
                           loveAllData:UserInformationDataModel,
                           sexAllData:UserInformationDataModel,
                           workAllData:UserInformationDataModel) -> [String : Any]{
        
        var loveSendingData:[String : Bool] = [:]
        loveAllData.items.forEach { (item: StatusItem) in
            loveSendingData[item.model.key] = item.status
        }
        var sexSendingData:[String : Bool] = [:]
        sexAllData.items.forEach { (item:StatusItem) in
            sexSendingData[item.model.key] = item.status
        }
        var workSendingData:[String : Bool] = [:]
        workAllData.items.forEach { (item:StatusItem) in
            workSendingData[item.model.key] = item.status
        }
        
        let data = [emailKey: email,
                    passwordKey: password,
                    userNameKey: name,
                    lastNameKey : lastName,
                    birthDayKey : birthDay,
                    iliskiDurumu : loveSendingData,
                    kariyer : workSendingData,
                    userGender : sexSendingData] as [String : Any]
        return data
    }
}
