//
//  DailyMoods.swift
//  Mooj
//
//  Created by Leisure on 07/07/2021.
//

import Foundation

struct DailyMood: Codable {
    var date = Date()
    var mood = ""
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        return formatter.string(from: date)
    }
}

class DailyMoods: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case list
    }
    
    @Published var list: [DailyMood] {
        didSet {
            if let undecodedURLToJSONData = UserDefaults.standard.data(forKey: "urlToJSONData") {
                let decoder = JSONDecoder()
                
                if let url = try? decoder.decode(URL.self, from: undecodedURLToJSONData) {
                        let encoder = JSONEncoder()
                        let defaultDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                        // Reloading url here just in case, probably could be done more elegantly? maybe with onDismiss()
                        if let encoded = try? encoder.encode(list) {
                                try? encoded.write(to: url)
                                print("encoded to \(url)")
                        }
                }
            } // add initialiser to find the saved value of list
            
        }
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        list = try container.decode([DailyMood].self, forKey: .list)
    }
    
    init() {
        if let undecodedURLToJSONData = UserDefaults.standard.data(forKey: "urlToJSONData") {
            let decoder = JSONDecoder()
            
            if let url = try? decoder.decode(URL.self, from: undecodedURLToJSONData) {
            if let undecodedDailyMoods = try? Data(contentsOf: url) {
                print("loading from \(url)")
                print(undecodedDailyMoods)
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([DailyMood].self, from: undecodedDailyMoods) {
                    self.list = decoded
                    print("data loaded in initialiser") // I think there's something going wrong here with where it's decoding from
                    return
                }
            }
            }
        }
        list = [DailyMood]()
        print("starting new list data")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(list, forKey: .list)
    }
}
