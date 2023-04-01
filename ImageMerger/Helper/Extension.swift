//
//  Extension.swift
//  ImageMerger
//
//  Created by Godwin A on 31/03/2023.
//

import AVKit

extension Array where Element: UIImage {
    
    
    func stitchImages() -> UIImage? {
        
        guard !isEmpty else { return nil}

        let maxWidth = compactMap { $0.size.width }.max()
        let maxHeight = compactMap { $0.size.height }.max()

        let maxSize = CGSize(width: maxWidth ?? 0, height: maxHeight ?? 0)


        let totalSize = CGSize(width: maxSize.width  * (CGFloat)(self.count), height:  maxSize.height)
        let renderer = UIGraphicsImageRenderer(size: totalSize)

        return renderer.image { (context) in
            for (index, image) in self.enumerated() {
                let rect = AVMakeRect(aspectRatio: image.size,
                                      insideRect:
                    CGRect(x: maxSize.width * CGFloat(index), y: 0, width: maxSize.width, height: maxSize.height))
                image.draw(in: rect)
            }
        }
    }
}
