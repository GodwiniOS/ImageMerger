//
//  ViewModel.swift
//  ImageMerger
//
//  Created by Anto Jero on 01/04/2023.
//

import Foundation

protocol ViewModelDelegate:AnyObject {
    func updateUI(_ text: String,_ removebuttonState: Bool,
                  _ stitchButtonstate: Bool)
    func imagesFromDatabase(imagesEntities: [ImageEntity])
}

class ImageMergerViewModel{
    
    weak var delegate: ViewModelDelegate?
    var title = "Select Image"

    var noOfImages = 0 {
        didSet {
            title = noOfImages == 0 ? "Select Image" : "(\(noOfImages)) Select Image"
            let removebuttonState = noOfImages > 0
            let stitchButtonstate = noOfImages > 1
            delegate?.updateUI(title, !removebuttonState, !stitchButtonstate)
        }
    }
    
    init(vc: ImageMergeViewController) {
        delegate = vc
        loadOfflineImages()
    }
    
    private func loadOfflineImages(){
        
        let images = DataBaseHelper.sharedInstance.getAllImagesData()
        delegate?.imagesFromDatabase(imagesEntities: images)
        noOfImages = images.count
    }

    
    func removeAction() {
        
        DataBaseHelper.sharedInstance.deleteAllData()
        noOfImages = 0
    }
}
