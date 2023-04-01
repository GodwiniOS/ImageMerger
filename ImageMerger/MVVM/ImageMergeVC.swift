//
//  ViewController.swift
//  ImageMerger
//
//  Created by Godwin A on 29/03/2023.
//

import UIKit

class ImageMergeViewController: UIViewController {

    
    @IBOutlet weak var stitchButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var images = [UIImage]()
    var viewModel:ImageMergerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ImageMergerViewModel(vc: self)
    }


    @IBAction func uploadAction(_ sender: UIButton) {

        let picker =  UIImagePickerController()
        picker.allowsEditing = false
        picker.modalPresentationStyle = .overFullScreen
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @IBAction func stitchAction(_ sender: Any) {
        updateImage(image: images.stitchImages())
    }
    
    private func updateImage(image: UIImage? = nil) {
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    @IBAction func removeAction(_ sender: Any) {
        
        images = []
        viewModel.removeAction()
        updateImage()
    }
}

extension ImageMergeViewController: ViewModelDelegate {
    
    func imagesFromDatabase(imagesEntities: [ImageEntity]) {
        
        for fetchingImage in imagesEntities {

            if let imageData = fetchingImage.value(forKey: "imageData") as? Data,
               let image = UIImage(data: imageData){
                images.append(image)
            }
        }
    }
    
    
    func updateUI(_ text: String,_ removebuttonState: Bool,
                  _ stitchButtonstate: Bool) {
        DispatchQueue.main.async {
            self.selectImageButton.setTitle(text,for: .normal)
            self.removeButton.isHidden = removebuttonState
            self.stitchButton.isHidden = stitchButtonstate
        }
    }
}


extension ImageMergeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        images.append(image)
        DataBaseHelper.sharedInstance.saveImagesData(image: image)
        viewModel.noOfImages += 1
        
        picker.dismiss(animated: true)
    }
}
