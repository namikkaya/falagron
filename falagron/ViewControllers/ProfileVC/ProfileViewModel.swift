//
//  ProfileViewModel.swift
//  falagron
//
//  Created by namik kaya on 6.04.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {
    private var dataRows:[SectionType] = []
    
    private var userInfo: UserModel?
    
    private var sendData: [String : Any] = [:]
    
    override init() {
        super.init()
    }
    
    convenience init(test1:String) {
        self.init()
    }
    
    var reloadViewClosure: (()->())?
    
    var sendDataClosure: ( (_ sendDataStatus: Bool, _ errorMessage:Error?) -> () )?
}

extension ProfileViewModel {
    private func updateUI() {
        if let userInfo = userInfo {
            dataRows.removeAll()
            let birthDayDate = userInfo.birthDay?.dateValue()
            dataRows.append(.required(rowTypes: [.customerInfo(email: userInfo.email ?? "" )]))
            dataRows.append(.replaceable(rowTypes: [.replaceable(name: userInfo.userName, surname: userInfo.lastName, birthDay: birthDayDate, gender: userInfo.cinsiyet, iliski_durumu: userInfo.iliskiDurumu, kariyer: userInfo.kariyer)]))
            self.reloadViewClosure?()
        }
    }
    
    func loading() {
        dataRows.removeAll()
        dataRows.append(.loading(rowsTypes: [.loading]))
        self.reloadViewClosure?()
    }
}

extension ProfileViewModel {
    enum SectionType {
        case required(rowTypes: [RowType]), replaceable(rowTypes: [RowType]), loading(rowsTypes: [RowType])
        
        var height:CGFloat {
            switch self {
            case .replaceable: return 50
            case .required: return 50
            case .loading: return 0
            }
        }
    }
    
    enum RowType {
        case customerInfo(email: String?), replaceable(name:String?, surname:String?, birthDay:Date?, gender:GenderModel?, iliski_durumu:LoveStatus?, kariyer: WorkStatus?), loading
    }
}

extension ProfileViewModel {
    func getCell(tableView:UITableView, indexPath: IndexPath) -> UITableViewCell {
        let sectionType = dataRows[indexPath.section]
        switch sectionType {
        case .required(let rowTypes):
            let rowType = rowTypes[indexPath.row]
            switch rowType{
            case .customerInfo(let email):
                let cell = tableView.dequeueReusableCell(with: UnchangeableCell.self, for: indexPath)
                cell.setup(email: email)
                return cell
            default:
                return UITableViewCell()
            }
        case .replaceable(let rowTypes):
            let rowType = rowTypes[indexPath.row]
            switch rowType {
            case .replaceable(let name, let surname, let birthDay, let gender, let iliski_durumu, let kariyer):
                let cell = tableView.dequeueReusableCell(with: ChangeableCell.self, for: indexPath)
                cell.delegate = self
                cell.setup(name: name, surName: surname, birthDay: birthDay, gender: gender, iliski_durumu: iliski_durumu, kariyer: kariyer)
                return cell
            default:
                return UITableViewCell()
            }
        case .loading(let rowsTypes):
            let rowType = rowsTypes[indexPath.row]
            switch rowType{
            case .loading:
                let cell = tableView.dequeueReusableCell(with: loadingCell.self, for: indexPath)
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func numberOfRowsInSection(section:Int) -> Int {
        let type = dataRows[section]
        switch type {
        case .replaceable(let rowTypes):
            return rowTypes.count
        case .required(let rowTypes):
            return rowTypes.count
        case .loading(rowsTypes: let rowsTypes):
            return rowsTypes.count
        }
    }
    
    func numberOfSections() -> Int {
        return dataRows.count
    }
    
    func getSectionHeader(tableView:UITableView, section:Int) -> UIView? {
        let type = dataRows[section]
        switch type {
        case .replaceable:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            view.backgroundColor = UIColor.red
            return view
        case .required:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            view.backgroundColor = UIColor.yellow
            return view
        case .loading:
            return nil
        }
    }
    
    func getSectionHeaderHeight(section:Int) -> CGFloat?{
        let type = dataRows[section]
        return type.height
    }
}


extension ProfileViewModel {
    func fetchData() {
        guard let uid = FirebaseManager.shared.user?.uid else { return }
        FirebaseManager.shared.getUserData(userId: uid) { [weak self] (userModel: UserModel?, error: Error?) in
            self?.userInfo = userModel
            self?.updateUI()
        }
    }
}

extension ProfileViewModel:ChangeableCellDelegate {
    func changeDataModel(name: String, lastName: String, password: String, birthDay: Date, loveAllData: UserInformationDataModel, sexAllData: UserInformationDataModel, workAllData: UserInformationDataModel) {
        sendData = updateDataParse(name: name, email: self.userInfo?.email ?? "", lastName: lastName, password: "", birthDay: birthDay, loveAllData: loveAllData, sexAllData: sexAllData, workAllData: workAllData)
    }
}

extension ProfileViewModel {
    func updateDataParse(name:String,
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


extension ProfileViewModel {
    func sendService() {
        FirebaseManager.shared.updateUserData(userDocumentId: userInfo?.documentId ?? "", data: sendData) { [weak self] status, error in
            self?.sendDataClosure?(status, error)
        }
    }
}
