//
//  DataBaseManager.swift
//  ImageMerger
//
//  Created by Godwin A on 30/03/2023.
//

import UIKit
import CoreData

class DataBaseHelper: NSObject {
    
    static let sharedInstance = DataBaseHelper()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImagesData(image : UIImage) {

        do {
            
            let imageEntity = NSEntityDescription.insertNewObject(forEntityName: "ImageEntity", into: context) as! ImageEntity
            if let imageData = image.pngData() {
                imageEntity.imageData = imageData
            }
            try context.save()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func getAllImagesData() -> [ImageEntity] {
        
        var imagesArray = [ImageEntity]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageEntity")
        do {
            imagesArray = try context.fetch(fetchRequest) as! [ImageEntity]
        } catch let err {
            print(err.localizedDescription)
        }
        
        return imagesArray
    }
    
    func deleteAllData() {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageEntity")
        fetchRequest.returnsObjectsAsFaults = false

        do{
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in error : \(error) \(error.userInfo)")
        }
    }
}
