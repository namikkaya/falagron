//
//  ChangeableCell.swift
//  falagron
//
//  Created by namik kaya on 10.04.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

protocol ChangeableCellDelegate: AnyObject {
    func changeDataModel(name: String, lastName:String, password:String, birthDay:Date, loveAllData: UserInformationDataModel, sexAllData: UserInformationDataModel, workAllData: UserInformationDataModel)
}
extension ChangeableCellDelegate {
    func changeDataModel(name: String, lastName:String, password:String, birthDay:Date, loveAllData: UserInformationDataModel, sexAllData: UserInformationDataModel, workAllData: UserInformationDataModel) {}
}

class ChangeableCell: UITableViewCell {
    weak var delegate: ChangeableCellDelegate?
    @IBOutlet private weak var nameField: UITextField! {
        didSet {
            nameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet private weak var surNameField: UITextField! {
        didSet {
            surNameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet private weak var birthDayField: UITextField!
    @IBOutlet private weak var iliskiDurumuField: UITextField!
    @IBOutlet private weak var genderField: UITextField!
    @IBOutlet private weak var workField: UITextField!
    
    typealias SelectedItem = (key:String, selectedIndex: Int)
    
    private var dataDatePicker: KayaDatePicker?
    
    var workData = UserInformationDataModel(id: "work", type: UserInfoDataType.work)
    var loveData = UserInformationDataModel(id: "love", type: UserInfoDataType.love)
    var cinsiyetData = UserInformationDataModel(id: "sex", type: UserInfoDataType.sex)
    
    var kariyer: WorkStatus?
    var kariyerSelected:SelectedItem?
    
    var iliskiDurumu:LoveStatus?
    var iliskiDurumuSelected:SelectedItem?
    
    var cinsiyetDurumu:GenderModel?
    var cinsiyetDurumuSelected:SelectedItem?
    
    var name:String?
    var lastName:String?
    var birthDay:Date?
    var password:String = ""
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == nameField {
            sendData()
        }else if textField == surNameField {
            sendData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    deinit {
        dataDatePicker = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(name:String?, surName:String?, birthDay:Date?, gender:GenderModel?, iliski_durumu:LoveStatus?, kariyer: WorkStatus?) {
        self.kariyer = kariyer
        nameField.text = name
        surNameField.text = surName
        birthDayField.text = birthDay?.convertDate(formate: "dd/MM/YYYY")
        
        self.name = name
        self.lastName = surName
        self.birthDay = birthDay
        
        birthDaySetup(birthDay: birthDay)
        kariyerSetup(kariyer: kariyer)
        iliskiDurumuSetup(iliskiDurumu: iliski_durumu)
        cinsiyetDurumuSetup(gender: gender)
    }
}

extension ChangeableCell {
    private func birthDaySetup(birthDay: Date?) {
        self.sendData()
        self.birthDay = birthDay
        dataDatePicker = KayaDatePicker(toolBarWidth: self.frame, field: birthDayField, selectedDate: birthDay ?? Date()) { [weak self] _birthDay in
            self?.birthDayField.text = _birthDay?.convertDate(formate: "dd/MM/YYYY")
            self?.birthDay = _birthDay
            self?.sendData()
        }
    }
}

extension ChangeableCell {
    private func kariyerSetup(kariyer: WorkStatus?) {
        kariyerSelected = getWorkItemIndex(data: workData.getElements(type: .work), work: kariyer)
        let kayaPickerKariyerData = KayaPickerStringData(items: getData(data: workData.getElements(type: .work)))
        setWorkData(type: kariyerSelected?.key ?? "")
        self.sendData()
        self.workField.text = self.getItemName(data: self.workData.getElements(type: .work), index: kariyerSelected?.selectedIndex ?? 0)
        _ = KayaPicker(toolBarWidth: self.frame, field: workField, data: kayaPickerKariyerData, defaultSelectedIndex: kariyerSelected?.selectedIndex ?? 0, callBack: { [weak self] selectedIndex in
            guard let self = self else { return }
            self.kariyerSelected = self.getWorkIndexToItem(data: self.workData.getElements(type: .work), work: kariyer, indexItem: selectedIndex ?? 0)
            self.setWorkData(type: self.kariyerSelected?.key ?? "")
            self.workField.text = self.getItemName(data: self.workData.getElements(type: .work), index: selectedIndex ?? 0)
            self.sendData()
        })
    }
}

extension ChangeableCell {
    private func iliskiDurumuSetup(iliskiDurumu: LoveStatus?) {
        iliskiDurumuSelected = getLoveItemIndex(data: loveData.getElements(type: .love), love: iliskiDurumu)
        let kayaPickerIliskiDurumuData = KayaPickerStringData(items: getData(data: loveData.getElements(type: .love)))
        setLoveData(type: iliskiDurumuSelected?.key ?? "")
        self.sendData()
        self.iliskiDurumuField.text = self.getItemName(data: self.loveData.getElements(type: .love), index: iliskiDurumuSelected?.selectedIndex ?? 0)
        _ = KayaPicker(toolBarWidth: self.frame, field: iliskiDurumuField, data: kayaPickerIliskiDurumuData, defaultSelectedIndex: iliskiDurumuSelected?.selectedIndex ?? 0, callBack: { [weak self] selectedIndex in
            guard let self = self else { return }
            self.iliskiDurumuSelected = self.getLoveIndexToItem(data: self.loveData.getElements(type: .love), love: iliskiDurumu, itemIndex: selectedIndex ?? 0)
            self.iliskiDurumuField.text = self.getItemName(data: self.loveData.getElements(type: .love), index: selectedIndex ?? 0)
            self.setLoveData(type: self.iliskiDurumuSelected?.key ?? "")
            self.sendData()
        })
    }
}

extension ChangeableCell {
    private func cinsiyetDurumuSetup(gender: GenderModel?) {
        cinsiyetDurumuSelected = getGenderItemIndex(data: cinsiyetData.getElements(type: .sex), gender: gender) //getItemIndex(data: cinsiyetData)
        let kayaPickerCinsiyetdurumu = KayaPickerStringData(items: getData(data: cinsiyetData.getElements(type: .sex)))
        self.genderField.text = self.getItemName(data: self.cinsiyetData.getElements(type: .sex), index: cinsiyetDurumuSelected?.selectedIndex ?? 0)
        setGenderData(type: cinsiyetDurumuSelected?.key ?? "")
        sendData()
        _ = KayaPicker(toolBarWidth: self.frame, field: genderField, data: kayaPickerCinsiyetdurumu, defaultSelectedIndex: cinsiyetDurumuSelected?.selectedIndex ?? 0, callBack: { [weak self] selectedIndex in
            guard let self = self else { return }
            self.cinsiyetDurumuSelected = self.getGenderIndexToItem(data: self.cinsiyetData.getElements(type: .sex), gender: gender, indexItem: selectedIndex ?? 0)
            self.setGenderData(type: self.cinsiyetDurumuSelected?.key ?? "")
            self.genderField.text = self.getItemName(data: self.cinsiyetData.getElements(type: .sex), index: selectedIndex ?? 0)
            self.sendData()
        })
    }
}


extension ChangeableCell {
    private func getData(data: [StatusItem]) -> [String] {
        var stringData: [String] = []
        data.forEach { item in
            stringData.append(item.model.value)
        }
        return stringData
    }
    
    private func getItemIndex(data: [StatusItem]) -> Int {
        var returnIndex:Int = 0
        for (index, element) in data.enumerated() {
            if element.status {
                returnIndex = index
            }
        }
        return returnIndex
    }
    
    private func getItemName(data: [StatusItem], index: Int) -> String {
        return data[index].model.value
    }
    
    private func getGenderItemIndex(data: [StatusItem], gender: GenderModel?) -> SelectedItem {
        var returnIndex = 0
        var key = ""
        for (index, element) in data.enumerated() {
            switch element.model.key {
            case userGenderFemale:
                if gender?.Kadin ?? false {
                    returnIndex = index
                    key = userGenderFemale
                }
                break
            case userGenderMale:
                if gender?.Erkek ?? false {
                    returnIndex = index
                    key = userGenderFemale
                }
                break
            case userGenderLGBT:
                if gender?.LGBT ?? false{
                    returnIndex = index
                    key = userGenderFemale
                }
                break
            default:
                returnIndex = 0
                key = userGenderFemale
                break
            }
        }
        return (key, returnIndex)
    }
    private func getGenderIndexToItem(data: [StatusItem], gender: GenderModel?, indexItem:Int = 0) -> SelectedItem {
        var returnIndex = 0
        var key = ""
        for (index, element) in data.enumerated() {
            if indexItem == index {
                switch element.model.key {
                case userGenderFemale:
                    returnIndex = index
                    key = userGenderFemale
                    break
                case userGenderMale:
                    returnIndex = index
                    key = userGenderMale
                    break
                case userGenderLGBT:
                    returnIndex = index
                    key = userGenderLGBT
                    break
                default:
                    returnIndex = 0
                    key = ""
                    break
                }
            }
        }
        return (key, returnIndex)
    }
    private func setGenderData(type:String) {
        for (index, value) in self.cinsiyetData.getElements(type: .sex).enumerated() {
            if type == value.model.key {
                self.cinsiyetData.items[index].status = true
            }else {
                self.cinsiyetData.items[index].status = false
            }
        }
        sendData()
    }
    
    // Kariyer
    private func getWorkItemIndex(data: [StatusItem], work: WorkStatus?) -> SelectedItem {
        var returnIndex = 0
        var key = ""
        for (index, element) in data.enumerated() {
            switch element.model.key {
            case kariyer_Calisiyor:
                if work?.kariyer_Calisiyor ?? false {
                    returnIndex = index
                    key = kariyer_Calisiyor
                }
                break
            case kariyer_Calismiyor:
                if work?.kariyer_Calismiyor ?? false {
                    returnIndex = index
                    key = kariyer_Calismiyor
                }
                break
            case kariyer_Ogrenci:
                if work?.kariyer_Ogrenci ?? false{
                    returnIndex = index
                    key = kariyer_Ogrenci
                }
                break
            case kariyer_EvHanimi:
                if work?.kariyer_EvHanimi ?? false{
                    returnIndex = index
                    key = kariyer_EvHanimi
                }
                break
            default:
                returnIndex = 0
                key = ""
                break
            }
        }
        return (key, returnIndex)
    }
    private func getWorkIndexToItem(data: [StatusItem], work: WorkStatus?, indexItem:Int = 0) -> SelectedItem {
        var returnIndex = 0
        var key = ""
        for (index, element) in data.enumerated() {
            if indexItem == index {
                switch element.model.key {
                case kariyer_Calisiyor:
                    returnIndex = index
                    key = kariyer_Calisiyor
                    break
                case kariyer_Calismiyor:
                    returnIndex = index
                    key = kariyer_Calismiyor
                    break
                case kariyer_Ogrenci:
                    returnIndex = index
                    key = kariyer_Ogrenci
                    break
                case kariyer_EvHanimi:
                    returnIndex = index
                    key = kariyer_EvHanimi
                    break
                default:
                    returnIndex = 0
                    key = ""
                    break
                }
            }
        }
        return (key, returnIndex)
    }
    private func setWorkData(type:String) {
        for (index, value) in self.workData.getElements(type: .work).enumerated() {
            if type == value.model.key {
                self.workData.items[index].status = true
            }else {
                self.workData.items[index].status = false
            }
        }
        sendData()
    }
    
    // iliski durumu
    private func getLoveItemIndex(data: [StatusItem], love: LoveStatus?) -> SelectedItem {
        var returnIndex = 0
        var key = ""
        for (index, element) in data.enumerated() {
            switch element.model.key {
            case iliskiDurumu_IliskisiVar:
                if love?.iliskiDurumu_IliskisiVar ?? false {
                    returnIndex = index
                    key = iliskiDurumu_IliskisiVar
                }
                break
            case iliskiDurumu_IliskisiYok:
                if love?.iliskiDurumu_IliskisiYok ?? false {
                    returnIndex = index
                    key = iliskiDurumu_IliskisiYok
                }
                break
            case iliskiDurumu_YeniAyrilmis:
                if love?.iliskiDurumu_YeniAyrilmis ?? false{
                    returnIndex = index
                    key = iliskiDurumu_YeniAyrilmis
                }
                break
            case iliskiDurumu_Evli:
                if love?.iliskiDurumu_Evli ?? false{
                    returnIndex = index
                    key = iliskiDurumu_Evli
                }
                break
            case iliskiDurumu_Nisanli:
                if love?.iliskiDurumu_Nisanli ?? false{
                    returnIndex = index
                    key = iliskiDurumu_Nisanli
                }
                break
            case iliskiDurumu_YeniBosanmis:
                if love?.iliskiDurumu_YeniBosanmis ?? false{
                    returnIndex = index
                    key = iliskiDurumu_YeniBosanmis
                }
                break
            default:
                returnIndex = 0
                key = ""
                break
            }
        }
        return (key, returnIndex)
    }
    private func getLoveIndexToItem(data: [StatusItem], love: LoveStatus?, itemIndex: Int = 0) -> SelectedItem {
        var returnIndex = 0
        var returnKey = ""
        for (index, element) in data.enumerated() {
            if index == itemIndex {
                switch element.model.key {
                case iliskiDurumu_IliskisiVar:
                    returnIndex = index
                    returnKey = iliskiDurumu_IliskisiVar
                    break
                case iliskiDurumu_IliskisiYok:
                    returnIndex = index
                    returnKey = iliskiDurumu_IliskisiYok
                    break
                case iliskiDurumu_YeniAyrilmis:
                    returnIndex = index
                    returnKey = iliskiDurumu_YeniAyrilmis
                    break
                case iliskiDurumu_Evli:
                    returnIndex = index
                    returnKey = iliskiDurumu_Evli
                    break
                case iliskiDurumu_Nisanli:
                    returnIndex = index
                    returnKey = iliskiDurumu_Nisanli
                    break
                case iliskiDurumu_YeniBosanmis:
                    returnIndex = index
                    returnKey = iliskiDurumu_YeniBosanmis
                    break
                default:
                    returnIndex = 0
                    returnKey = ""
                    break
                }
            }
        }
        return (returnKey, returnIndex)
    }
    private func setLoveData(type:String) {
        for (index, value) in self.loveData.getElements(type: .love).enumerated() {
            if type == value.model.key {
                self.loveData.items[index].status = true
            }else {
                self.loveData.items[index].status = false
            }
        }
        sendData()
    }
}

extension ChangeableCell {
    func sendData() {
        self.delegate?.changeDataModel(name: self.name ?? "", lastName: self.lastName ?? "", password: "", birthDay: self.birthDay ?? Date(), loveAllData: self.loveData, sexAllData: self.cinsiyetData, workAllData: self.workData)
    }
}
