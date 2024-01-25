
import UIKit

class EmployeeAddViewController: UIViewController {
    
    @IBOutlet var TableView: UITableView!
    
    weak var delegate: EmployeeAddDelegate?
    var employee: Employee?
    var mode: TableViewMode = .add
    var index: Int?
    
    var empId: String?
    var empProfilePic: UIImage?
    var empName: String?
    var empEmail: String?
    var empMobileNo: String?
    var empCountryCode: String?
    var empGender: String?
    var empDesignation: String?
    var empDOB: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableViewCell")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        TableView.separatorStyle = .none
        
    }
    
}

extension EmployeeAddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell") as! EmployeeTableViewCell
        cell.selectionStyle = .none
        switch mode {
        case .add:
            self.title = "Add Employee"
            cell.saveBtn.setTitle("Save Details", for: .normal)
            cell.saveBtn.isHidden = false
            cell.profileImgDataTransferCallback = {data in
                self.empProfilePic = data
                print("printImage1--> \(data)")
            }
            cell.idDataTransferCallback = { data in
                cell.idLbl.text = data
                self.empId = data
                print("printId1--> \(data)")
            }
            cell.nameDataTransferCallback = { data in
                self.empName = data
                print("printName1--> \(data)")
            }
            cell.emailDataTransferCallback = { data in
                self.empEmail = data
                print("printEmail1--> \(data)")
            }
            cell.mobileNoDataTransferCallback = { data in
                self.empMobileNo = data
                print("printMobile1--> \(data)")
            }
            cell.countryPickerDataTransferCallback = { data in
                self.empCountryCode = data
                print("printCountry1--> \(data)")
            }
            cell.genderDataTransferCallback = { data in
                self.empGender = data
                print("printGender1--> \(data)")
            }
            cell.designationDataTransferCallback = { data in
                self.empDesignation = data
                print("printDesti1--> \(data)")
            }
            cell.dobDataTransferCallback = { data in
                self.empDOB = data
                print("printDOB1--> \(data)")
            }
        case .viewDetails:
            self.title = employee?.empName
            cell.cameraButton.isUserInteractionEnabled = false
            cell.nameTxtField.isUserInteractionEnabled = false
            cell.emailTxtField.isUserInteractionEnabled = false
            cell.mobileNoTxtField.isUserInteractionEnabled = false
            cell.countryPickerTxtField.isUserInteractionEnabled = false
            cell.genderBtn.isUserInteractionEnabled = false
            cell.designationBtn.isUserInteractionEnabled = false
            cell.datePicker.isUserInteractionEnabled = false
            cell.saveBtn.isHidden = true
            cell.profileImg.image = employee?.empProfilePic
            cell.idLbl.text = employee?.empId
            cell.nameTxtField.text = employee?.empName
            cell.emailTxtField.text = employee?.empEmail
            cell.mobileNoTxtField.text = employee?.empMobileNo
            cell.countryPickerTxtField.text = employee?.empCountryCode
            cell.genderLbl.text = employee?.empGender
            cell.designationLbl.text = employee?.empDesignation
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            cell.datePicker.date = dateFormatter.date(from: employee!.empDOB)!
        case .edit:
            self.title = employee?.empName
            cell.saveBtn.setTitle("Update", for: .normal)
            cell.profileImg.image = employee?.empProfilePic
            cell.imageFlag = 1
            cell.idLbl.text = employee?.empId
            cell.nameTxtField.text = employee?.empName
            cell.emailTxtField.text = employee?.empEmail
            cell.mobileNoTxtField.text = employee?.empMobileNo
            cell.countryPickerTxtField.text = employee?.empCountryCode
            cell.genderLbl.text = employee?.empGender
            cell.designationLbl.text = employee?.empDesignation
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            cell.datePicker.date = dateFormatter.date(from: employee!.empDOB)!
            self.empProfilePic = employee?.empProfilePic
            self.empId = employee?.empId
            self.empName = employee?.empName
            self.empEmail = employee?.empEmail
            self.empMobileNo = employee?.empMobileNo
            self.empCountryCode = employee?.empCountryCode
            self.empGender = employee?.empGender
            self.empDesignation = employee?.empDesignation
            self.empDOB = employee?.empDOB
            
            cell.profileImgDataTransferCallback = {data in
                self.empProfilePic = data
                print(data)
            }
            cell.nameDataTransferCallback = { data in
                self.empName! = data
                print(data)
            }
            cell.emailDataTransferCallback = { data in
                self.empEmail = data
                print(data)
            }
            cell.mobileNoDataTransferCallback = { data in
                self.empMobileNo = data
                print(data)
            }
            cell.countryPickerDataTransferCallback = { data in
                self.empCountryCode = data
                print(data)
            }
            cell.genderDataTransferCallback = { data in
                self.empGender = data
                print(data)
            }
            cell.designationDataTransferCallback = { data in
                self.empDesignation = data
                print(data)
            }
            cell.dobDataTransferCallback = { data in
                self.empDOB = data
                print(data)
            }
        default:
            break
        }
        
        configureCell(cell, at: indexPath.row)
        return cell
    }
    
}

extension EmployeeAddViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800.0
    }
    
}

extension EmployeeAddViewController {
    func configureCell(_ cell: EmployeeTableViewCell, at index: Int) {
        cell.saveBtn.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        // Validate the email format using a regular expression
        var isValidEmail = false
        
        let emailRegex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                                                  options: .caseInsensitive)
        if let empEmail = empEmail{
            isValidEmail = emailRegex.firstMatch(in: empEmail, options: [],
                                                     range: NSRange(location: 0, length: empEmail.count)) != nil
            // Provide user feedback (e.g., change text color, show/hide error message)
            let emailAlert = UIAlertController(title: "Entered Wrong Email", message: nil, preferredStyle: .alert)
            let mobileNoAlert = UIAlertController(title: "Entered Wrong Mobile Number", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            emailAlert.addAction(cancel)
            mobileNoAlert.addAction(cancel)
            if(!isValidEmail && empEmail.count > 0) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let topViewController = windowScene.windows.first?.rootViewController {
                    topViewController.present(emailAlert, animated: true, completion: nil)
                }
                return
            } else if (empMobileNo?.count != 10) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let topViewController = windowScene.windows.first?.rootViewController {
                    topViewController.present(mobileNoAlert, animated: true, completion: nil)
                }
                return
            }
        }
        
        TableView.reloadData()
        switch mode {
        case .add:
                guard let empName = self.empName, !empName.isEmpty,
                      let empEmail = self.empEmail, !empEmail.isEmpty,
                      let empMobileNo = self.empMobileNo, !empMobileNo.isEmpty else {
                    // At least one of the required values is nil or empty
                    self.emptyData()
                    return
                }
                if let empId = self.empId,
                   let empProfilePic = self.empProfilePic,
                   let empName = self.empName,
                   let empEmail = self.empEmail,
                   let empMobileNo = self.empMobileNo,
                   let empCountryCode = self.empCountryCode,
                   let empGender = self.empGender,
                   let empDesignation = self.empDesignation,
                   let empDOB = self.empDOB {
                    
                    let employee = Employee(
                        empId: empId,
                        empProfilePic: empProfilePic,
                        empName: empName,
                        empEmail: empEmail,
                        empMobileNo: empMobileNo,
                        empCountryCode: empCountryCode,
                        empGender: empGender,
                        empDesignation: empDesignation,
                        empDOB: empDOB
                    )
                    DispatchQueue.main.async {
                        self.delegate?.sendDetail(dataModel: employee, indexPath: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.emptyData()
                }
        case .edit:
            
            if let empId = self.empId,
               let empProfilePic = self.empProfilePic,
               let empName = self.empName,
               let empEmail = self.empEmail,
               let empMobileNo = self.empMobileNo,
               let empCountryCode = self.empCountryCode,
               let empGender = self.empGender,
               let empDesignation = self.empDesignation,
               let empDOB = self.empDOB {
                
//                let vc = ViewController()
                let employee = Employee(
                    empId: empId,
                    empProfilePic: empProfilePic,
                    empName: empName,
                    empEmail: empEmail,
                    empMobileNo: empMobileNo,
                    empCountryCode: empCountryCode,
                    empGender: empGender,
                    empDesignation: empDesignation,
                    empDOB: empDOB
                )
                self.delegate?.sendDetail(dataModel: employee, indexPath: index)
                
                self.navigationController?.popViewController(animated: true)
            } else {
                self.emptyData()
            }

        default:
            return
        }
        
        
        
    }
    func emptyData(){
        let alert = UIAlertController(title: nil, message: "Please Fill All Details", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
