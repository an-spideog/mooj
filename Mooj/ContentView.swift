//
//  ContentView.swift
//  Mooj
//
//  Created by Leisure on 06/07/2021.
//

import SwiftUI

struct ContentView: View {
    let defaultDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    @ObservedObject var dailyMoods = DailyMoods()
    @State private var mood = ""
    @State private var showingSetup = false
    @State private var urlToJSONData = URL(string: "")
    @State private var hasDoneSetup = false {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(hasDoneSetup) {
                    UserDefaults.standard.set(encoded, forKey: "hasDoneSetup")
                }
        }
    }
    var backgroundColor: Color {
        switch (dailyMoods.list[todayIndex].mood) {
        case "Good": return Color.green
        case "Bad": return Color.red
        default: return Color.white
        }
    }
   
    
    var todayIndex: Int {
        if let index = dailyMoods.list.firstIndex(where: {
            $0.formattedDate == giveDate(date: Date())
        }) {
            return index
        } else {
            dailyMoods.list.append(DailyMood())
            return dailyMoods.list.count - 1
        }
    }
    // Was date() not the same because it was including seconds and minutes etc?
    
    var body: some View {
        TabView {
            ZStack {
                Rectangle()
                    .foregroundColor(backgroundColor)
                    .ignoresSafeArea()
                
                VStack {
                    /*if dailyMoods.list.isEmpty == false {
                        Text(dailyMoods.list[todayIndex].mood)
                    }*/
                    Button("Debug") {
                        showingSetup = true
                        print("Debugging")
                        print("\(defaultDirectory.absoluteString)")
                    }
                    Text("Debug: \(urlToJSONData?.absoluteString ?? "no url")")
                    Spacer()
                    Button(action: {
                        withAnimation {
                            dailyMoods.list[todayIndex].mood = "Good"

                        }
                    }) {
                            Image(systemName: "hand.thumbsup")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    .frame(width: 100, height: 100)
                    .background(backgroundColor)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .foregroundColor(backgroundColor == Color.white ? .green : .white)
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            dailyMoods.list[todayIndex].mood = "Bad"
                        }
                    }) {
                        Image(systemName: "hand.thumbsdown")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    .frame(width: 100, height: 100)
                    .background(backgroundColor)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .foregroundColor(backgroundColor == Color.white ? .red : .white)
                    Spacer()
                }
                }
            .tabItem {
                Image(systemName: "face.smiling")
            }
            
            ReportView(dailyMoods: dailyMoods)
                .navigationTitle("Report")
                .tabItem {
                    Image(systemName: "list.dash")
                }
        }
        .onAppear(perform: {
            loadData()
        })
        .sheet(isPresented: $showingSetup, onDismiss: loadData) {
            SetupView()
        }
            
    }
    
    func giveDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    func unformattedDate(year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar.current
         let date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        return date
    }
    
    func loadData() {
        print("loading data")
        if let undecodedHasDoneSetup = UserDefaults.standard.data(forKey: "hasDoneSetup") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode(Bool.self, from: undecodedHasDoneSetup) {
                self.hasDoneSetup = decoded
            }
        }
        if let undecodedURLToJSONData = UserDefaults.standard.data(forKey: "urlToJSONData") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode(URL.self, from: undecodedURLToJSONData) {
                self.urlToJSONData = decoded
            }
        }
        if let undecodedDailyMoods = try? Data(contentsOf: self.urlToJSONData!) {
            print("loading from \(self.urlToJSONData!)")
            print(undecodedDailyMoods)
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([DailyMood].self, from: undecodedDailyMoods) {
                self.dailyMoods.list = decoded
                print("data loaded") // I think there's something going wrong here with where it's decoding from
            }
            
        } 
        
        
        dailyMoods.list.append(DailyMood(date:
            unformattedDate(year: 2021, month: 3, day: 4), mood: "Good")) // This is a debug date to test things are working
        if hasDoneSetup == false {
            showingSetup = true
            hasDoneSetup = true // TODO: find a better way to track whether setup has been done
        }
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
