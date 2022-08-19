//
//  CoreDataRelationshipsBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/19.
//

import SwiftUI
import CoreData

// Three Entities
// 1. BusinessEntity
// 2. DepartmentEntity
// 3. EmployeeEntity

class CoreDataManager {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    private init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA")
                print(error.localizedDescription)
            } else {
                print("SUCCESSFULLY LOADING CORE DATA")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("ERROR SAVING CORE DATA")
            print(error.localizedDescription)
        }
    }
}

class CoreDataRelationshipViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    @Published var businesses: [BusinessEntity] = []
    @Published var departments: [DepartmentEntity] = []
    @Published var employees: [EmployeeEntity] = []
    
    init() {
        getBusinesses()
        getDepartments()
        getEmployees()
    }
    
    func addBusiness(name: String) {
        guard !name.isEmpty else { return }
        if businesses.filter{$0.name == name}.isEmpty {
            let newBusiness = BusinessEntity(context: manager.context)
            newBusiness.name = name
            save()
        }
    }
    
    func addDepartment(businessName: String, departmentName: String) {
        if !businesses.filter{$0.name == businessName}.isEmpty {
            guard let business = businesses.filter{$0.name == businessName}.first else { return }
            if departments.filter{$0.name == departmentName}.isEmpty {
                let newDeparment = DepartmentEntity(context: manager.context)
                newDeparment.name = departmentName
                newDeparment.businesses = [business]
                if var curDepartments = business.departments {
                    curDepartments = curDepartments.adding(newDeparment) as NSSet
                    business.departments = curDepartments
                } else {
                    business.departments = [newDeparment]
                }
            } else {
                guard let curDepartment = departments.filter{$0.name == departmentName}.first else { return }
                if var curBusinesses = curDepartment.businesses {
                    curBusinesses = curBusinesses.adding(business) as NSSet
                    curDepartment.businesses = curBusinesses
                } else {
                    curDepartment.businesses = [business]
                }
                
            }
            save()
        }
    }
    
    func addEmployee(name: String, age: String, business: String, department: String) {
        guard !name.isEmpty && !age.isEmpty && !business.isEmpty && !department.isEmpty, let age = Int16(age) else { return }
        guard let business = businesses.filter{$0.name == business}.first, let department = departments.filter{$0.name == department}.first else { return }
        guard var curDepartments = business.departments, var curBusinesses = department.businesses, curDepartments.contains(department), curBusinesses.contains(business) else { return }
        guard employees.filter{$0.name == name && $0.age == age && $0.business == business && $0.department == department}.isEmpty else { return }
        
        let newEmployee = EmployeeEntity(context: manager.context)
        newEmployee.name = name
        newEmployee.age = age
        newEmployee.department = department
        newEmployee.business = business
        newEmployee.dateJoined = Date()
        
        if var businessEmployees = business.employees {
            businessEmployees = businessEmployees.adding(newEmployee) as NSSet
            business.employees = businessEmployees
        } else {
            business.employees = [newEmployee]
        }
        
        if var departmentEmployees = department.employees {
            departmentEmployees = departmentEmployees.adding(newEmployee) as NSSet
            department.employees = departmentEmployees
        } else {
            department.employees = [newEmployee]
        }
        
        save()
    }
    
    func deleteBusiness(entity: BusinessEntity) {
        manager.context.delete(entity)
        save()
    }
    
    func deleteDepartment(entity: DepartmentEntity) {
        manager.context.delete(entity)
        save()
    }
    
    func deleteEmployee(entity: EmployeeEntity) {
        manager.context.delete(entity)
        save()
    }
    
    func getBusinesses() {
        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
        do {
            self.businesses = try manager.context.fetch(request)
        } catch {
            print("ERROR FETCHING CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func getDepartments() {
        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
        do {
            self.departments = try manager.context.fetch(request)
        } catch {
            print("ERROR FETCHING CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func getEmployees() {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        do {
            self.employees = try manager.context.fetch(request)
        } catch {
            print("ERROR FETCHING CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func save() {
        businesses.removeAll()
        departments.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.manager.save()
            self.getBusinesses()
            self.getDepartments()
            self.getEmployees()
        }
    }
    
}

struct CoreDataRelationshipsBootCamp: View {
    @StateObject private var viewModel = CoreDataRelationshipViewModel()
    @State private var insertMode: Int = 0
    @State private var businessName: String = ""
    @State private var departmentName: String = ""
    @State private var employeeName: String = ""
    @State private var emplyeeAge: String = ""
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Button("Business") {
                            insertMode = 0
                            resetTextFieldText()
                        }
                        Button("Department") {
                            insertMode = 1
                            resetTextFieldText()
                        }
                        Button("Employee") {
                            insertMode = 2
                            resetTextFieldText()
                        }
                    }
                    switch insertMode {
                    case 0:
                        TextField("Add Business Name here...", text: $businessName)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    case 1:
                        TextField("Add Department Name here...", text: $departmentName)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        TextField("Department's Business", text: $businessName)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    default:
                        TextField("Add Employee's Name here...", text: $employeeName)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        TextField("Add Employee's Age here...", text: $emplyeeAge)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        TextField("Employee's Business", text: $businessName)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        TextField("Employee's Department", text: $departmentName)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    Button {
                        switch insertMode {
                        case 0:
                            viewModel.addBusiness(name: businessName)
                        case 1:
                            viewModel.addDepartment(businessName: businessName, departmentName: departmentName)
                        default:
                            viewModel.addEmployee(name: employeeName, age: emplyeeAge, business: businessName, department: departmentName)
                        }
                        resetTextFieldText()
                        
                    } label: {
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                    ScrollView(.horizontal) {
                        HStack(alignment: .top) {
                            ForEach(viewModel.businesses) { business in
                                BusinesView(entity: business)
                                    .onTapGesture {
                                        viewModel.deleteBusiness(entity: business)
                                    }
                            }
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack(alignment: .top) {
                            ForEach(viewModel.departments) { department in
                                DepartmentView(entity: department)
                                    .onTapGesture {
                                        viewModel.deleteDepartment(entity: department)
                                    }
                            }
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack(alignment: .top) {
                            ForEach(viewModel.employees) { employee in
                                EmployeeView(entity: employee)
                                    .onTapGesture {
                                        viewModel.deleteEmployee(entity: employee)
                                    }
                            }
                        }
                    }
                    Spacer()
                }
                .navigationTitle("Relationships")
            }
        }
    }
    
    func resetTextFieldText() {
        businessName = ""
        departmentName = ""
        employeeName = ""
        emplyeeAge = ""
    }
}

struct BusinesView: View {
    let entity: BusinessEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("name : \(entity.name ?? "Default name")")
                .bold()
            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
                Text("Departments:")
                    .bold()
                ForEach(departments) { department in
                    Text(department.name ?? "Default name")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("Employees:")
                    .bold()
                ForEach(employees) { employee in
                    Text(employee.name ?? "Default name")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct DepartmentView: View {
    let entity: DepartmentEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("name : \(entity.name ?? "Default name")")
                .bold()
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
                Text("Business")
                    .bold()
                ForEach(businesses) { business in
                    Text(business.name ?? "Default name")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("Employees:")
                    .bold()
                ForEach(employees) { employee in
                    Text(employee.name ?? "Default name")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct EmployeeView: View {
    let entity: EmployeeEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("name: \(entity.name ?? "Default name")")
                .bold()
            Text("age: \(entity.age)")
                .bold()
            Text("Date Joined: \(entity.dateJoined ?? Date())")
                .bold()
            Text("Business:")
                .bold()
            Text(entity.business?.name ?? "Default name")
                .bold()
            Text("Department: ")
                .bold()
            Text(entity.department?.name ?? "Default name")
                .bold()
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct CoreDataRelationshipsBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataRelationshipsBootCamp()
    }
}


