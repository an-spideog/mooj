//
//  SwiftUIView.swift
//  Mooj
//
//  Created by Kill on 20/07/2021.
//

import SwiftUI

struct SetupView: View {
    @Environment(\.presentationMode) var presentationMode
    let defaultDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    @State private var showingExporter = false
    @State private var jsonData = JSONFile()
    @State private var urlToJSONData = URL(string: "") {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(urlToJSONData) {
                    UserDefaults.standard.set(encoded, forKey: "urlToJSONData")
                }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("All data for this app will be stored locally on your pone unless you choose to sync it to the cloud")
                    .padding()
                Text("Where would you like your data to be stored, this can be changed later in settings (Click default if you're not sure)")
                    .padding()
                Spacer()
                HStack {
                    Spacer()
                    Button("Default") {
                        // TODO: Implement quicker default option
                        showingExporter = true
                        
                    }
                    Spacer()
                    Button("Custom") {
                        showingExporter = true
                    }
                    Spacer()
                    
                }
                Spacer()
            }
            .navigationTitle("Welcome to Mooj!")
            // .interactiveDismissDisabled() this cannot be included until iOS 15, may have to hack around it
        }
        
        .fileExporter(isPresented: $showingExporter, document: jsonData, contentType: .json, defaultFilename: "moojData.json") { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                    urlToJSONData = url
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
