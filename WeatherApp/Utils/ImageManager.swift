//
//  ImageManager.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

/* ======================================================================== */
// This class is created for the caching weather icons to the directory
/* ======================================================================== */

class ImageManager:NSObject {
    static let shared = ImageManager()
    
    let imageCacheFolder:String = "ImageCache"

    //MARK:- Public methods
    func setImageFrom(urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        self.setImageFrom(urlString: urlString, resizeLimit: 0) { (image) in
            completion(image)
        }
    }
    
    func setResizedImageFrom(urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        self.setImageFrom(urlString: urlString, resizeLimit: 500) { (image) in
            completion(image)
        }
    }
    
    func clearFullCache() {
        let fileManager = FileManager.default
        let cacheFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageCacheFolder)
        do {
            try fileManager.removeItem(atPath: cacheFolder.path)
        } catch let deleteError {
            print("Could not clear cacheFolder: \(deleteError.localizedDescription)")
        }
    }
    
    //It will help to update cache image, if you are uploading different images to same online path
    func clearSingleFileCache(urlString:String) {
        let imageName = urlString.components(separatedBy: "/").last ?? ""
        let fileManager = FileManager.default
        let cacheFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageCacheFolder)
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: cacheFolder.path)
            for filePath in filePaths {
                if (filePath == imageName) {
                    try fileManager.removeItem(atPath: "\(cacheFolder.path)/\(filePath)")
                }
            }
        } catch {
            print("Could not clear cacheFolder: \(error)")
        }
    }
}

//MARK:- Private Methods
extension ImageManager {
    fileprivate func setImageFrom(urlString: String, resizeLimit:CGFloat, completion: @escaping (_ image: UIImage?) -> Void) {
        let imageName = urlString.components(separatedBy: "/").last ?? ""
        
        let cacheFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageCacheFolder)
        if !FileManager.default.fileExists(atPath: cacheFolder.path) {
            do {
                try FileManager.default.createDirectory(at: cacheFolder, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("coudn't create directory")
                completion(nil)
            }
        }
        
        let imagePath = cacheFolder.appendingPathComponent(imageName)
        if (imageName.count > 0) {
            if (FileManager.default.fileExists(atPath: imagePath.path)) {
                //File already cached
                completion(UIImage(contentsOfFile: imagePath.path))
            }else {
                //Download file
                ImageDownloadManager.shared.downloadImageFile(urlString: urlString) { (data,error) in
                    if error == nil, let _data = data {
                        if var downloadedImage = UIImage(data: _data) {
                            //-- Resize (max width 'resizeLimit') --//
                            if (resizeLimit > 0) {
                                if (downloadedImage.size.width > resizeLimit) {
                                    if let resizedImage = downloadedImage.resize(toWidth: resizeLimit) {
                                        downloadedImage = resizedImage
                                    }
                                }
                            }
                            //----------------------------//
                            self.cacheImageToDirectory(imageName: imageName, image: downloadedImage)
                            completion(downloadedImage)
                        }else {
                            completion(nil)
                        }
                    }else {
                        completion(nil)
                    }
                }
            }
        }else {
            //No file name from URL
            completion(nil)
        }
    }
    
    fileprivate func cacheImageToDirectory(imageName:String,image:UIImage) {
        let cacheFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageCacheFolder)
        let imagePath = cacheFolder.appendingPathComponent(imageName).path
        if let imageData = image.pngData() {
            if FileManager.default.fileExists(atPath: imagePath) {
                do {
                    try FileManager.default.removeItem(atPath: imagePath)
                } catch {
                    print("Not able to remove old cached image")
                }
             }
            FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
        }else {
            print("Invalid image data downloaded")
        }
    }
}

class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    fileprivate func downloadImageFile(urlString: String, completion: @escaping (_ data: Data?, _ error:Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString) {
                do {
                    let data = try Data(contentsOf: url)
                    completion(data,nil)
                } catch let parsingError {
                    completion(nil,parsingError)
                }
            }else {
                let error = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "Invalid image URL"])
                completion(nil,error)
            }
        }
    }
}

extension UIImage {
    public func resize(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension String {
    func urlEncoded() ->String {
        return self.replacingOccurrences(of: " ", with: ConstantStrings.PERCENTAGE_20)
    }
}
