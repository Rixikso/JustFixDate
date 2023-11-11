//
//  ContentView.swift
//  JustFixDate
//
//  Created by Marcin Misiek on 27/10/2023.
//

import SwiftUI

// Define a struct to represent the selected folder
class SelectedFolder {
    var _metadataProcessor = MetadataProcessor()
    
    func getFileList(at folderURLs: [URL]) {
        for folderURL in folderURLs {
            if let decodedPath = folderURL.path().removingPercentEncoding {
                _metadataProcessor.ModifyFolderToOriginal(folderPath: decodedPath)
            }
            else {
                print("Failed to decode")
            }
        }
    }
}

struct FolderSelector: View {
    var selectedFolder = SelectedFolder() // Create an instance of the selected folder

    var body: some View {
        Button("Fix dates for folder photos!") {
            self.selectFolder()
        }
    }

    func selectFolder() {
       let folderChooserPoint = CGPoint(x: 0, y: 0)
       let folderChooserSize = CGSize(width: 500, height: 600)
       let folderChooserRectangle = CGRect(origin: folderChooserPoint, size: folderChooserSize)
       let folderPicker = NSOpenPanel(contentRect: folderChooserRectangle, styleMask: .utilityWindow, backing: .buffered, defer: true)
       
       folderPicker.canChooseDirectories = true
       folderPicker.canChooseFiles = true
       folderPicker.allowsMultipleSelection = true
       folderPicker.canDownloadUbiquitousContents = true
       folderPicker.canResolveUbiquitousConflicts = true
       
       folderPicker.begin { response in
           
           if response == .OK {
               let pickedFolders = folderPicker.urls
               
               self.selectedFolder.getFileList(at: pickedFolders)
           }
       }
   }
}

