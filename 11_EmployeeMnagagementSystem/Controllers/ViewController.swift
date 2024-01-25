//name,email,number last character not taken


import UIKit

class ViewController: UIViewController, EmployeeAddDelegate {
    
    @IBOutlet var empTableView: UITableView!
    @IBOutlet var searchBox: UISearchBar!
    @IBOutlet var sortButton: UIButton!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var filterOptionUI: UIView!
    @IBOutlet var filterDesignationLbl: UILabel!
    @IBOutlet var filterDesignationButton: UIButton!
    @IBOutlet var cancelFilterUIButton: UIButton!
    @IBOutlet var resetFilterButton: UIButton!
    @IBOutlet var applyFilterButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    let defaults = UserDefaults.standard
    var employees = [Employee]()
    var allEmployees = [Employee]()
    var tableViewMode: TableViewMode?
    var delegate: EmployeeAddDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addButton.setTitle("", for: .normal)
        sortButton.setTitle("", for: .normal)
        
        employees = allEmployees
        
        empTableView.dataSource = self
        empTableView.delegate = self
        loadEmployeeData()
        sortButton.addTarget(self, action: #selector(sortBtnClicked), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterBtnClicked), for: .touchUpInside)
        cancelFilterUIButton.addTarget(self, action: #selector(cancelFilterBtnClicked), for: .touchUpInside)
        resetFilterButton.addTarget(self, action: #selector(resetFilterBtnClicked), for: .touchUpInside)
        applyFilterButton.addTarget(self, action: #selector(applyFilterButtonClicked), for: .touchUpInside)
        filterDesignationButton.addTarget(self, action: #selector(filterDesignationButtonClicked), for: .touchUpInside)
        
        searchBox.layer.cornerRadius = 20.0
        searchBox.layer.masksToBounds = true
        filterOptionUI.layer.cornerRadius = 20.0
        filterDesignationButton.layer.borderWidth = 1.0
        filterDesignationButton.layer.borderColor = UIColor(red: 240/255, green: 64/255, blue: 80/255, alpha: 1.0).cgColor
        filterDesignationButton.layer.cornerRadius = 10.0
        
        addButton.layer.cornerRadius = 30
        addButton.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filterOptionUI.isHidden = true
        self.title = "Employee List"
        self.empTableView.reloadData()
        if(employees.count == 0) {
            title = "Empty List!!"
        }
    }
    
    func saveEmployeeData() {
        if let encodedData = try? PropertyListEncoder().encode(employees) {
            defaults.set(encodedData, forKey: "EmployeeDetails")
        }
    }
    
    func loadEmployeeData() {
        if let savedData = defaults.value(forKey: "EmployeeDetails") as? Data,
           let loadedEmployees = try? PropertyListDecoder().decode([Employee].self, from: savedData) {
            employees = loadedEmployees
        }
    }
    
    func getEmployeeData() -> [Employee] {
        return employees
    }
    
    func sendDetail(dataModel: Employee, indexPath: Int?) {
        if(indexPath != nil){
            employees[indexPath!] = dataModel
        } else {
            employees.append(dataModel)
        }
        saveEmployeeData()
        empTableView.reloadData()
    }
    
    // Function to present EmployeeAddViewController
    func presentEmployeeAddViewController(mode: TableViewMode, indexPath: Int?) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeAddViewController") as? EmployeeAddViewController else {
            return
        }
        if let index = indexPath {
            vc.employee = employees[index]
            vc.empProfilePic = employees[index].empProfilePic
            vc.empId = employees[index].empId
            vc.empName = employees[index].empName
            vc.empEmail = employees[index].empEmail
            vc.empMobileNo = employees[index].empMobileNo
            vc.empGender = employees[index].empGender
            vc.empDesignation = employees[index].empDesignation
            vc.empDOB = employees[index].empDOB
            vc.index = indexPath
        }
        vc.delegate = self
        vc.mode = mode
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        presentEmployeeAddViewController(mode: .add, indexPath: nil)
    }
    @IBAction func editButtonClicked(_ sender: UIButton) {
        var index = sender.tag
        presentEmployeeAddViewController(mode: .edit, indexPath: index)
    }
    @IBAction func viewDetailsButtonClicked(_ sender: UIButton) {
        var index = sender.tag
        presentEmployeeAddViewController(mode: .viewDetails, indexPath: index)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Remove the item from the data source
            employees.remove(at: indexPath.row)
            
            // Save the updated data source to UserDefaults
            saveEmployeeData()
            
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if(employees.count == 0) {
            self.title = "Empty List!!"
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let empCell = empTableView.dequeueReusableCell(withIdentifier: "VCEmployeeTableViewCell") as! VCEmployeeTableViewCell
        empCell.nameLabel.text = employees[indexPath.row].empName
        empCell.designationLabel.text = employees[indexPath.row].empDesignation
        empCell.empImageView.image = employees[indexPath.row].empProfilePic
        empCell.selectionStyle = .none
        empCell.details.tag = indexPath.row
        empCell.edit.tag = indexPath.row
        
        return empCell
    }
}

//MARK: - Navigation Bar

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            // Reset the employees array to the original list when the search bar is empty
            loadEmployeeData()
        } else {
            // Filter the employees array based on the empName property
            let filteredEmployee = employees.filter { employee in
                return employee.empName.lowercased().contains(searchText.lowercased())
            }
            
            // Update the employees array with the filtered results
            employees = filteredEmployee
        }
        
        // Reload the table view to reflect the changes
        empTableView.reloadData()
    }
    
    @objc func sortBtnClicked() {
        let alert = UIAlertController(title: nil, message: "Choose", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 240/255, green: 64/255, blue: 80/255, alpha: 1.0)
        
        let ascending = UIAlertAction(title: "Ascending Order", style: .default) { AscendingOrderAction in
            let sortedEmployees = self.employees.sorted { employee1, employee2 in
                return employee1.empName.lowercased() < employee2.empName.lowercased()
            }
            self.employees = sortedEmployees
            self.empTableView.reloadData()
        }
        let descending = UIAlertAction(title: "Descending Order", style: .default) { DescendingOrderAction in
            let sortedEmployees = self.employees.sorted() { employee1, employee2 in
                return employee1.empName.lowercased() > employee2.empName.lowercased()
            }
            self.employees = sortedEmployees
            self.empTableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(ascending)
        alert.addAction(descending)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    @objc func filterBtnClicked() {
        filterOptionUI.isHidden = false
    }
    @objc func applyFilterButtonClicked() {
        if (filterDesignationLbl.text != "Not Selected") {
            allEmployees = employees
            let filteredEmployees = self.allEmployees.filter { employee in
                return employee.empDesignation.lowercased() == filterDesignationLbl.text!.lowercased()
            }
            self.employees = filteredEmployees
            applyFilterButton.isEnabled = false
            if(employees.count == 0){
                self.title = "Empty List!!"
            }
            self.empTableView.reloadData()
        }
        filterOptionUI.isHidden = true
    }
    @objc func cancelFilterBtnClicked() {
        filterOptionUI.isHidden = true
    }
    @objc func resetFilterBtnClicked() {
        filterDesignationLbl.text = "Not Selected"
        if(!allEmployees.isEmpty){
            applyFilterButton.isEnabled = true
            employees = allEmployees
            self.title = "Employee List"
        }
        empTableView.reloadData()
        filterOptionUI.isHidden = true
    }
    @objc func filterDesignationButtonClicked() {
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
                    self.filterDesignationButtonClicked()
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
                self.filterDesignationLbl.text = " \(employeeSelectDesignation.title!)"
            }
            return employeeDesignation
        }
    }
    
}
