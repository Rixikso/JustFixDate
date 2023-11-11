//
//  MetadataProcessor.swift
//  JustFixDate
//
//  Created by Marcin Misiek on 26/08/2023.
//

import Foundation
import ImageIO

public class MetadataProcessor {
    
    public func GetExifData(filePath: String) -> Date {
        // Create a FileManager instance
        let imageURL = URL(fileURLWithPath: filePath)
        
        // Create an image source from the URL
        if let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil) {
            
            // Get the count of image properties (including Exif data)
            let propertiesCount = CGImageSourceGetCount(imageSource)
            
            // Loop through the properties and find the Exif data
            for i in 0..<propertiesCount {
                if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String: Any] {
                    
                    // Check if Exif data is available
                    if let exifData = properties[kCGImagePropertyExifDictionary as String] as? [String: Any] {
                        // Access and print Exif metadata
                        for (key, value) in exifData {
                            if (key.compare("DateTimeOriginal", options: [.caseInsensitive]) == .orderedSame) {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                                
                                if let date = dateFormatter.date(from: value as! String) {
                                    return date
                                } else {
                                    return Date()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return Date()
    }
    
    public func GetMetadata() {
        let filePath = "/Users/mmm/Documents/Dev/PhotosMetadata/Photos Quick Fix/Photos Quick Fix/Assets.xcassets/iCloud Photos/IMG_0032.HEIC"
        
        // Create a FileManager instance
        let fileManager = FileManager.default
        
        // Check if the file exists at the specified path
        if fileManager.fileExists(atPath: filePath) {
            // Attempt to retrieve the file's metadata
            if let fileAttributes = try? fileManager.attributesOfItem(atPath: filePath) {
                // Print the metadata
                for (key, value) in fileAttributes {
                    switch key {
                    case .creationDate:
                        let createtionDate = value as! Date
                        print("Creation Date: \(createtionDate)")
                    case .modificationDate:
                        let modificationDate = value as! Date
                        print("Modification Date: \(modificationDate)")
                    default:
                        break
                    }
                }
            } else {
                print("Failed to retrieve metadata for the file.")
            }
        } else {
            print("File does not exist at the specified path.")
        }
    }
    
    public func ModifyDateToOriginal(filePath: String, fileManager: FileManager) {
        do {
            // Get the current attributes of the file
            var fileAttributes = try fileManager.attributesOfItem(atPath: filePath) as [FileAttributeKey: Any]
            
            // Modify the attributes as needed
            
            let originalDate = GetExifData(filePath: filePath)
            fileAttributes[.modificationDate] = originalDate
            fileAttributes[.creationDate] = originalDate
            
            // Set the attributes back to the file
            try fileManager.setAttributes(fileAttributes, ofItemAtPath: filePath)
            
            print("File attributes modified successfully.")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    public func ModifyFolderToOriginal(folderPath: String){
        // Create a FileManager instance
        let fileManager = FileManager.default
        
        do {
            // Get a list of all files in the folder
            let folderContents = try fileManager.contentsOfDirectory(atPath: folderPath)
            
            // Filter for files with the ".jpg" extension
            let jpgFiles = folderContents.filter { $0.lowercased().hasSuffix(".jpg") }
            
            // Now, you can iterate over the JPG files
            for jpgFile in jpgFiles {
                let fullPath = (folderPath as NSString).appendingPathComponent(jpgFile)
                print("Found JPG file: \(fullPath)")
                
                self.ModifyDateToOriginal(filePath: fullPath, fileManager: fileManager);
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
