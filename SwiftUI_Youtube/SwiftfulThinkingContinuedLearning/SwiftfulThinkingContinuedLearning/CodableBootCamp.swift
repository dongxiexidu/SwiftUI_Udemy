//
//  CodableBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

// DOWNLOAD DATA FROM NETWORK AS JSON
// JSON CONVERT -> DATA WE USE

struct CustomerModel: Identifiable, Decodable, Encodable {
    let id: String
    let name: String
    let points: Int
    let isPremium: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case points
        case isPremium
    }

    init(id: String, name: String, points: Int, isPremium: Bool) {
        self.id = id
        self.name = name
        self.points = points
        self.isPremium = isPremium
    }

    // DECODABLE
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.points = try container.decode(Int.self, forKey: .points)
        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
    }
    
    // ENCODABLE
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(points, forKey: .points)
        try container.encode(isPremium, forKey: .isPremium)
    }
}

class CodableViewModel: ObservableObject {
    @Published var customer: CustomerModel? = nil
    
    init() {
        getDataDecoder()
    }
    
    func getDataDictionary() {
        guard let data = getJSONData() else { return }
        let jsonString = String(data: data, encoding: .utf8)
        print(jsonString)
//        Optional("{\"isPremium\":true,\"name\":\"Henry\",\"id\":\"12345\",\"points\":5}")
        
        if
            let localData = try? JSONSerialization.jsonObject(with: data),
            let dictionary = localData as? [String:Any],
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let points = dictionary["points"] as? Int,
            let isPremium = dictionary["isPremium"] as? Bool {
            
            let newCustomer = CustomerModel(id: id, name: name, points: points, isPremium: isPremium)
            customer = newCustomer
        }
        // getData as Dictionary
    }
    
    func getDataDecoder() {
        guard let data = getJSONData2() else { return }
        
        do {
            self.customer = try JSONDecoder().decode(CustomerModel.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getJSONData() -> Data? {
        // DOWNLOAD FROM NETWORK
        // ASNYC -> ESCAPING CLOSURE OR AWAIT, ETC.
        
        let dictionary: [String:Any] = [
            "id" : "12345",
            "name" : "Henry",
            "points" : 5,
            "isPremium" : true,
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
            return jsonData
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func getJSONData2() -> Data? {
        let customer = CustomerModel(id: "111", name: "Amy", points: 30, isPremium: false)
        let jsonData = try? JSONEncoder().encode(customer)
        return jsonData
    }
}

struct CodableBootCamp: View {
    @StateObject private var viewModel = CodableViewModel()
    var body: some View {
        VStack(spacing: 20) {
            if let customer = viewModel.customer {
                Text(customer.id)
                Text(customer.name)
                Text("\(customer.points)")
                Text(customer.isPremium.description)
            }
        }
    }
}

struct CodableBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        CodableBootCamp()
    }
}
