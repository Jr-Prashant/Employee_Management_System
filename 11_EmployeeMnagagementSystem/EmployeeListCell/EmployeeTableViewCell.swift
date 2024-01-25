
import UIKit
import MobileCoreServices
import CountryPicker


class EmployeeTableViewCell: UITableViewCell {
    
    //    Connect outlets
    @IBOutlet var profileImageUIView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var cameraUIView: UIView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var genderBtn: UIButton!
    @IBOutlet var designationBtn: UIButton!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var idLbl: UILabel!
    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var mobileNoTxtField: UITextField!
    @IBOutlet var genderLbl: UILabel!
    @IBOutlet var designationLbl: UILabel!
    @IBOutlet var countryPickerTxtField: UITextField!
    
    
    var imageFlag = 0
    var imagePicker :UIImagePickerController?
    //        var textFieldType: TextFieldType = .name
    
    //    Define Callback Closures
    var profileImgDataTransferCallback: ((UIImage) -> Void)?
    var idDataTransferCallback: ((String) -> Void)?
    var nameDataTransferCallback: ((String) -> Void)?
    var emailDataTransferCallback: ((String) -> Void)?
    var mobileNoDataTransferCallback: ((String) -> Void)?
    var countryPickerDataTransferCallback: ((String) -> Void)?
    var genderDataTransferCallback: ((String) -> Void)?
    var designationDataTransferCallback: ((String) -> Void)?
    var dobDataTransferCallback: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cameraButton.setTitle("", for: .normal)
        genderBtn.setTitle("", for: .normal)
        designationBtn.setTitle("", for: .normal)
        
        btnBorder(genderBtn)
        btnBorder(designationBtn)
        btnBorder(saveBtn)
        uiViewCircle(profileImageUIView, cameraUIView, profileImg, cameraButton)
        genderBtn.addTarget(self, action: #selector(genderButtonClicked), for: .touchUpInside)
        designationBtn.addTarget(self, action: #selector(desigantionButtonClicked), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonClicked), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.idGenerator()
        }
        
        nameTxtField.delegate = self
        emailTxtField.delegate = self
        mobileNoTxtField.delegate = self
        
        createCountryPicker()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    @objc func genderButtonClicked() {
        genderActionSheet { selectedGender in
            self.genderLbl.text = selectedGender
            self.genderDataTransferCallback?(selectedGender)
        }
    }
    @objc func dateChanged() {
        print(datePicker.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let selectedDateAsString = formatter.string(from: datePicker.date)
        dobDataTransferCallback?(selectedDateAsString)
    }
    
    @objc func desigantionButtonClicked() {
        designationActionSheet()
    }
    
}

//MARK: - Profile Photo

extension EmployeeTableViewCell: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func cameraButtonClicked() {
        let alert = UIAlertController(title: nil, message: "Choose", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 240/255, green: 64/255, blue: 80/255, alpha: 1.0)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] cameraAction in
            self!.capture()
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { galleryAction in
            self.imagePicker = UIImagePickerController()
            self.imagePicker?.sourceType = .photoLibrary
            self.imagePicker?.allowsEditing = true
            self.imagePicker?.delegate = self
            
            self.uiviewController()?.present(self.imagePicker!, animated: true, completion: nil)
        }
        
        let remove = UIAlertAction(title: "Remove", style: .default) { [self] UIAlertAction in
            self.profileImg.image = UIImage(named: "BlankProfileImg-removebg-preview.png")
            self.imageFlag = 0
        }
        
        let viewPhoto = UIAlertAction(title: "View", style: .default) { UIAlertAction in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePhotoViewController")as? ProfilePhotoViewController
            if(self.imageFlag == 0){
                vc?.flag = 0
            } else {
                vc?.image = self.profileImg.image
            }
            // Check if the current view controller is embedded in a navigation controller
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                // Push the view controller onto the navigation stack
                navigationController.pushViewController(vc!, animated: true)
            } else {
                // If not embedded in a navigation controller, present it
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let topViewController = windowScene.windows.first?.rootViewController {
                    topViewController.present(vc!, animated: true, completion: nil)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(viewPhoto)
        alert.addAction(remove)
        alert.addAction(cancel)
        // Add other actions as needed
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topViewController = windowScene.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    //    For Gallery
    func uiviewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let currentResponder = responder {
            responder = currentResponder.next
            if let viewController = currentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    //    For gallery and Camera Both
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            profileImg.image = pickedImage
            profileImgDataTransferCallback?(pickedImage)
            self.imageFlag = 1;
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //    For Gallery: it is called when the user cancels the image picker without selecting an image but if we not implement this method then it's by default behavior of 'UIImagePickerController'
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //    For camera
    func capture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Button capture")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topViewController = windowScene.windows.first?.rootViewController {
                topViewController.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
}

extension EmployeeTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Dismiss the keyboard

            switch textField {
            case nameTxtField:
                nameDataTransferCallback?(textField.text ?? "")
            case emailTxtField:
                emailDataTransferCallback?(textField.text ?? "")
            case mobileNoTxtField:
                mobileNoDataTransferCallback?(textField.text ?? "")
            default:
                break
            }

            return true
        }
    
}


//MARK: - Own Define Functions

extension EmployeeTableViewCell {
    
    func btnBorder(_ btnName: UIButton){
        btnName.layer.borderWidth = 1.0
        btnName.layer.borderColor = UIColor(red: 240/255, green: 64/255, blue: 80/255, alpha: 1.0).cgColor
        btnName.layer.cornerRadius = 10.0
    }
    
    func uiViewCircle(_ Imgview: UIView, _ btnView: UIView, _ img: UIImageView, _ btn: UIButton){
        Imgview.layer.masksToBounds = true
        Imgview.layer.cornerRadius = 62
        Imgview.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 62
        img.clipsToBounds = true
        
        btnView.layer.masksToBounds = true
        btnView.layer.cornerRadius = 17
        btnView.clipsToBounds = true
        btn.contentMode = .scaleAspectFit
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 17
        btn.clipsToBounds = true
    }
    
    func idGenerator() {
        let randomNumber = 100000 + arc4random_uniform(999999)
        idDataTransferCallback?("\(randomNumber)")
    }
    
    func genderActionSheet(completion: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 240/255, green: 64/255, blue: 80/255, alpha: 1.0)
        
        let maleAction = UIAlertAction(title: " Male", style: .default) { selectMale in
            completion(selectMale.title!)
        }
        let femaleAction = UIAlertAction(title: " Female", style: .default) { selectFemale in
            completion(selectFemale.title!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
        alert.addAction(maleAction)
        alert.addAction(femaleAction)
        alert.addAction(cancelAction)
        
        // Obtain the topmost view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topViewController = windowScene.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func designationActionSheet() -> Void {
        let alert = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 240/255, green: 64/255, blue: 80/255, alpha: 1.0)
        
        for i in 0..<designation.count {
            insideActionSheet(designation[i])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topViewController = windowScene.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
        
        func insideActionSheet(_ title: String) -> Void {
            let designationAction = UIAlertAction(title: title, style: .default) { selectDesignation in
                let secondAlert = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
                secondAlert.view.tintColor = UIColor(red: 240/255, green: 64/255, blue: 80/255, alpha: 1.0)
                switch selectDesignation.title {
                case designation[0]:
                    let softwareEngineer = ["Junior Software Developer", "Software Engineer", "Senior Software Engineer", "Lead Software Developer"]
                    for i in 0..<softwareEngineer.count {
                        secondAlert.addAction(secondActionSheet(softwareEngineer[i]))
                    }
                    break;
                case designation[1]:
                    let systemsAdministrator = ["Systems Administrator", "Network Administrator", "Systems Engineer", "IT Administrator"]
                    for i in 0..<systemsAdministrator.count {
                        secondAlert.addAction(secondActionSheet(systemsAdministrator[i]))
                    }
                    break;
                case designation[2]:
                    let DBA = ["Database Administrator", "Database Developer", "Senior DBA"]
                    for i in 0..<DBA.count {
                        secondAlert.addAction(secondActionSheet(DBA[i]))
                    }
                    break;
                case designation[3]:
                    let webDeveloper = ["Web Developer", "Front-End Developer", "Back-End Developer", "Full-Stack Developer"]
                    for i in 0..<webDeveloper.count {
                        secondAlert.addAction(secondActionSheet(webDeveloper[i]))
                    }
                    break;
                case designation[4]:
                    let itSupport = ["IT Support Specialist", "Help Desk Technician", "Desktop Support Technician", "Technical Support Engineer"]
                    for i in 0..<itSupport.count {
                        secondAlert.addAction(secondActionSheet(itSupport[i]))
                    }
                    break;
                case designation[5]:
                    let networkEngineer = ["Network Engineer", "Network Administrator", "Network Architect"]
                    for i in 0..<networkEngineer.count {
                        secondAlert.addAction(secondActionSheet(networkEngineer[i]))
                    }
                    break;
                case designation[6]:
                    let securityAnalyst = ["Security Analyst", "Information Security Engineer", "Cybersecurity Specialist"]
                    for i in 0..<securityAnalyst.count {
                        secondAlert.addAction(secondActionSheet(securityAnalyst[i]))
                    }
                    break;
                case designation[7]:
                    let projectManager = ["IT Project Manager", "Project Coordinator", "Scrum Master"]
                    for i in 0..<projectManager.count {
                        secondAlert.addAction(secondActionSheet(projectManager[i]))
                    }
                    break;
                case designation[8]:
                    let qaEngineer = ["QA Engineer", "Test Analyst", "Software Tester"]
                    for i in 0..<qaEngineer.count {
                        secondAlert.addAction(secondActionSheet(qaEngineer[i]))
                    }
                    break;
                case designation[9]:
                    let businessAnalyst = ["Business Analyst", "Systems Analyst"]
                    for i in 0..<businessAnalyst.count {
                        secondAlert.addAction(secondActionSheet(businessAnalyst[i]))
                    }
                    break;
                case designation[10]:
                    let devOpsEngineer = ["DevOps Engineer", "Site Reliability Engineer (SRE)"]
                    for i in 0..<devOpsEngineer.count {
                        secondAlert.addAction(secondActionSheet(devOpsEngineer[i]))
                    }
                    break;
                case designation[11]:
                    let dataScientist = ["Data Scientist", "Data Analyst", "Business Intelligence Analyst"]
                    for i in 0..<dataScientist.count {
                        secondAlert.addAction(secondActionSheet(dataScientist[i]))
                    }
                    break;
                case designation[12]:
                    let itManager = ["IT Manager", "Director of IT", "Chief Information Officer (CIO)"]
                    for i in 0..<itManager.count {
                        secondAlert.addAction(secondActionSheet(itManager[i]))
                    }
                    break;
                case designation[13]:
                    let uiDesigner = ["UX Designer", "UI Designer", "Interaction Designer"]
                    for i in 0..<uiDesigner.count {
                        secondAlert.addAction(secondActionSheet(uiDesigner[i]))
                    }
                    break;
                case designation[14]:
                    let cloudEngineer = ["Cloud Engineer", "Cloud Architect"]
                    for i in 0..<cloudEngineer.count {
                        secondAlert.addAction(secondActionSheet(cloudEngineer[i]))
                    }
                    break;
                default:
                    break;
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
                    self.desigantionButtonClicked()
                }
                cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
                secondAlert.addAction(cancelAction)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let topViewController = windowScene.windows.first?.rootViewController {
                    topViewController.present(secondAlert, animated: true, completion: nil)
                }
            }
            alert.addAction(designationAction)
        }
        
        func secondActionSheet(_ title: String) -> UIAlertAction {
            let employeeDesignation = UIAlertAction(title: title, style: .default) { employeeSelectDesignation in
                self.designationLbl.text = " \(employeeSelectDesignation.title!)"
                self.designationDataTransferCallback?(" \(employeeSelectDesignation.title!)")
            }
            return employeeDesignation
        }
    }
    
}

extension EmployeeTableViewCell: CountryPickerDelegate {
    
    func createCountryPicker() {
        let picker = CountryPicker()
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        countryPickerTxtField.inputView = picker
        picker.selectRow(0, inComponent: 0, animated: true)
    }
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryPickerTxtField.text = phoneCode
        countryPickerDataTransferCallback?(countryPickerTxtField.text ?? "+91")
    }
    
}
