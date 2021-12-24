//
//  FileDocument.swift
//  SavingJSONtoDocuments
//
//  Created by Kill on 19/07/2021.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct JSONFile: FileDocument {
    // tell the system we support only json
    static var readableContentTypes = [UTType.json]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else { 
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
