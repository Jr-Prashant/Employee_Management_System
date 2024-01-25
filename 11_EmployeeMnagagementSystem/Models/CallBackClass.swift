
import Foundation
import UIKit

let designation = ["Software Developer/Engineer", "Systems Administrator", "Database Administrator(DBA)", "Web Developer", "IT Support/Help Desk", "Network Engineer", "Security Analyst/Engineer", "Project Manager", "QA/Test Engineer", "Business Analyst", "DevOps Engineer", "Data Scientist/Analyst", "IT Manager/Director", "UX/UI Designer", "Cloud Engineer/Architect"]

enum TableViewMode {
    case add;
    case edit;
    case viewDetails;
}

struct Employee: Codable {
    var empId: String
    var empProfilePicData: Data
    var empName: String
    var empEmail: String
    var empMobileNo: String
    var empCountryCode: String
    var empGender: String
    var empDesignation: String
    var empDOB: String

    // Computed property to convert data to UIImage
    var empProfilePic: UIImage? {
        return UIImage(data: empProfilePicData)
    }

    // Initializer to create an instance from UIImage
    init(empId: String, empProfilePic: UIImage, empName: String, empEmail: String, empMobileNo: String,empCountryCode: String, empGender: String, empDesignation: String, empDOB: String) {
        self.empId = empId
        self.empProfilePicData = empProfilePic.pngData() ?? Data()
        self.empName = empName
        self.empEmail = empEmail
        self.empMobileNo = empMobileNo
        self.empCountryCode = empCountryCode
        self.empGender = empGender
        self.empDesignation = empDesignation
        self.empDOB = empDOB
    }
}

protocol EmployeeAddDelegate: AnyObject {
    func sendDetail(dataModel: Employee, indexPath: Int?)
    func getEmployeeData() -> [Employee]
}

protocol MyProtocol
{
    func sendDetail(dataModel: Employee)
}
