# Employee Management System

https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/4fff7dcc-945b-4603-844e-1c0faddd614f

## Screenshots
1. Employee List Screen
<img width="319" alt="Screenshot 2023-11-22 at 5 08 57 PM" src="https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/076170b5-628e-479b-bb74-f11e320a26df">
<img width="319" alt="Screenshot 2023-11-22 at 5 08 57 PM" src="https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/e8856259-1210-4cc7-a74c-28e4977e3bc7">

2. Add Employee Screen
<img width="319" alt="Screenshot 2023-11-22 at 5 08 57 PM" src="https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/48cfb18d-d7a3-4f36-9ed7-21a938bbe3bb">
<img width="319" alt="Screenshot 2023-11-22 at 5 08 57 PM" src="https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/b0e2af06-30d4-496f-9b33-f33bf5a4943e">

3. Profile Photo Screen
<img width="319" alt="Screenshot 2023-11-22 at 5 08 57 PM" src="https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/66a8b583-b160-4908-9a7b-aec14fd673ab">
<img width="319" alt="Screenshot 2023-11-22 at 5 08 57 PM" src="https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/1764fc99-9c3e-45b5-9835-7e53680c1876">

4. View Details Screen
<img width="319" alt="Screenshot 2023-11-22 at 5 08 57 PM" src="https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/408612d1-20cb-4353-b0e4-3b054f3ad0c5">

6. Edit Details Screen
<img width="319" alt="Screenshot 2023-11-22 at 5 08 57 PM" src="https://github.com/Jr-Prashant/Employee_Management_System/assets/151605109/630590f9-9a6c-495f-bc0b-6eb830414c9a">

## Overview
The Employee Management System is a Swift-based iOS application designed to streamline employee information management. It provides functionalities for adding, editing, viewing details, sorting, and filtering employees. The project also incorporates the use of enums, callback closures, and XIB files and UserDefaults as a local database.

## Features
1. **Add Employee:** Add employee details, including name, email, mobile number, gender, designation, profile photo, and date of birth.

2. **Edit Employee:** Modify existing employee information.

3. **View Details:** Access detailed information about a specific employee.

4. **Sort Employees:** Sort the employee list in ascending or descending order.

5. **Filter by Designation:** Filter employees based on their designation.

6. **Email Validation:** Utilizes email regex to ensure the correctness of email formats.

7. **Callback Closure:** Implements callback closures for efficient data transfer between view controllers.

8. **XIB Files:** Utilizes XIB files for modularizing UI components and improving code organization.

9. **UserDefaults Database:** Uses UserDefaults as a simple local database for storing employee information.

## Dependencies

**CountryPicker:** A Swift-based country picker library for iOS. Used for selecting countries.
  - To install, add the following line to your project's 'Podfile':
    ```bash
    pod 'CountryPicker'
    ```
  - Then, run the following command:
    ```bash
    pod install
    ```

## Installation
Getting started with the Objective-C Business App is quick and easy:
1. **Clone the Repository:** git clone https://github.com/Jr-Prashant/Employee_Management_System.git
2. Open the project in Xcode and build/run the app.

## Usage
1. **Adding an Employee:** To add a new employee to the system:
* Open the application on your iOS device.
* Navigate to the "+" button section.
* Fill in the required details, including name, email, mobile number, gender, designation, profile photo, and date of birth.
* Tap the "Save Details" button to save the employee information.

2. **Editing an Employee:** To edit existing employee information:
* Navigate to the "Employee List" section.
* Select the employee whose information you want to edit.
* Choose the "Edit" option.
* Modify the necessary details.
* Save the changes.

3. **Viewing Employee Details:** To view detailed information about a specific employee:
* Navigate to the "Employee List" section.
* Select the employee whose details you want to view.
* Choose the "View Details" option.
* Explore the comprehensive information about the selected employee.

4. **Sorting the Employee List:** To sort the employee list:
* Access the "Employee List" section.
* Navigate to the "Sort" button section.
* Choose the sorting option (ascending or descending) from the provided controls.
* Observe the updated employee list according to the selected sorting order.

5. **Filtering Employees by Designation:** To filter employees based on their designation:
* Navigate to the "Employee List" section.
* Navigate to the "Filter" button section.
* Use the filter option to select a specific designation.
* View the filtered employee list displaying only employees with the chosen designation.

6. **Email Validation:** When adding or editing an employee, the system performs email validation using regex. Ensure that the provided email follows the correct format to avoid validation errors.

7. **UserDefaults Database:** The application uses UserDefaults as a local database for storing employee information. The data is persisted locally, allowing for quick access even after closing and reopening the application.

## Acknowledgments
* The project follows the MVC architecture.
* Learnings from Swift, CountryPicker and UIKit documentation.
