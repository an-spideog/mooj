//
//  ReportView.swift
//  Mooj
//
//  Created by Leisure on 06/07/2021.
//

import SwiftUI

struct ReportView: View {
    
    @State private var debug = 0
    @ObservedObject var dailyMoods: DailyMoods
    
    let months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    var columns: [GridItem] = [.init(.adaptive(minimum:20, maximum: 20))]
    
    var body: some View {
        VStack {
            /*if dailyMoods.list.isEmpty == false {
                Text(dailyMoods.list[0].mood)
            }*/
            //Text(dailyMoods.list[0].mood ?? "aa")
            ScrollView {
                
                ForEach((1...12), id: \.self) { month in
                    let calendar = Calendar.current
                    let year = calendar.component(.year, from: Date())
                    let range = calendar.range(of: .day, in: .month, for: calendar.date(from: DateComponents(month: month))!)!
                    Text("\(months[month])")
                        .font(.headline)
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach((range)) { day in
                            /*let color = Color.gray
                            if let match = dailyMoods.list.firstIndex(where: {
                                $0.formattedDate == giveDate(year: year, month: month, day: day)
                            }) {
                                if dailyMoods.list[match].mood == "Good" {
                                     color = Color.green
                                } else if dailyMoods.list[match].mood == "Bad" {
                                     color = Color.red
                                }
                                    
                                
                            }*/
                            let match = dailyMoods.list.firstIndex(where: {
                                $0.formattedDate == giveDate(year: year, month: month, day: day)
                            })
                            
                            if let match = match {
                                if dailyMoods.list[match].mood == "Good" {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.green)
                                    .frame(height: 20)
                                } else if dailyMoods.list[match].mood == "Bad" {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.red)
                                        .frame(height: 20)
                                }
                            }
                                
                                else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.gray)
                                        .frame(height: 20)
                                }
                        }
                    }
                
                
                
                
                }
                
                
            
            }
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: calendar.date(from: DateComponents(month: 3))!)!

    }
        
        func giveDate(year: Int, month: Int, day: Int) -> String {
            let calendar = Calendar.current
            let formatter = DateFormatter()
            formatter.dateFormat = "y-MM-dd"
            let formattedDate = formatter.string(from: calendar.date(from: DateComponents(year: year, month: month, day: day))!)
            return formattedDate
        }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(dailyMoods: DailyMoods())
    }
}
