//
//  DKCameraResource.swift
//  DKCameraDemo
//
//  Created by Michal Tomaszewski on 15.03.2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion
import ImageIO

public protocol DKCameraResource {
   
     func cameraCancelImage() -> UIImage
     func cameraFlashOnImage() -> UIImage
     func cameraFlashAutoImage() -> UIImage
     func cameraFlashOffImage() -> UIImage
     func cameraSwitchImage() -> UIImage
}

extension AVMetadataFaceObject {
    
    open func realBounds(inCamera camera: DKCamera) -> CGRect {
        var bounds = CGRect()
        let previewSize = camera.previewLayer.bounds.size
        let isFront = camera.currentDevice == camera.captureDeviceFront
        
        if isFront {
            bounds.origin = CGPoint(x: previewSize.width - previewSize.width * (1 - self.bounds.origin.y - self.bounds.size.height / 2),
                                    y: previewSize.height * (self.bounds.origin.x + self.bounds.size.width / 2))
        } else {
            bounds.origin = CGPoint(x: previewSize.width * (1 - self.bounds.origin.y - self.bounds.size.height / 2),
                                    y: previewSize.height * (self.bounds.origin.x + self.bounds.size.width / 2))
        }
        bounds.size = CGSize(width: self.bounds.width * previewSize.height,
                             height: self.bounds.height * previewSize.width)
        return bounds
    }
}

@available(iOS, introduced: 10.0)
class DKCameraPhotoCapturer: NSObject, AVCapturePhotoCaptureDelegate {
    
    @available(iOS 12.0, *)
    class DKFileDataRepresentationCustomizer: NSObject, AVCapturePhotoFileDataRepresentationCustomizer {
        
        let metadata: [String: Any]
        
        init(metadata: [String: Any]) {
            self.metadata = metadata
            
            super.init()
        }
        
        public func replacementMetadata(for photo: AVCapturePhoto) -> [String: Any]? {
            return metadata
        }
    }
    
    var didCaptureWithImageData: ((_ imageData: Data) -> Void)?
    
    var gpsMetadata: [String: Any]?
    
    private var imageData: Data?
    
    #if swift(>=4.0)
    @available(iOS, deprecated: 11.0)
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        guard let photoSampleBuffer = photoSampleBuffer else {
            print("DKCameraError: \(error!)")
            return
        }
        
        self.imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
    }
    
    @available(iOS, introduced: 11.0)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        var metadata = photo.metadata
        
        if let gpsMetadata = self.gpsMetadata {
            metadata[kCGImagePropertyGPSDictionary as String] = gpsMetadata
            
            if #available(iOS 12.0, *) {
                self.imageData = photo.fileDataRepresentation(with: DKFileDataRepresentationCustomizer(metadata: metadata))
            } else {
                self.imageData = photo.fileDataRepresentation(withReplacementMetadata: metadata,
                                                              replacementEmbeddedThumbnailPhotoFormat: photo.embeddedThumbnailPhotoFormat,
                                                              replacementEmbeddedThumbnailPixelBuffer: nil,
                                                              replacementDepthData: photo.depthData)
            }
        } else {
            self.imageData = photo.fileDataRepresentation()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            print("DKCameraError: \(error)")
        } else if let didCaptureWithImageData = self.didCaptureWithImageData {
            didCaptureWithImageData(self.imageData!)
        }
    }
    #else
    func capture(_ output: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        guard let photoSampleBuffer = photoSampleBuffer else {
            print("DKCameraError: \(error!)")
            return
        }
        
        self.imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
    }
    
    func capture(_ output: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            print("DKCameraError: \(error)")
        } else if let didCaptureWithImageData = self.didCaptureWithImageData {
            didCaptureWithImageData(self.imageData!)
        }
    }
    
    #endif
}

// MARK: - Utilities
public extension UIInterfaceOrientation {
    
    func toDeviceOrientation() -> UIDeviceOrientation {
        switch self {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeRight:
            return .landscapeLeft
        case .landscapeLeft:
            return .landscapeRight
        default:
            return .portrait
        }
    }
}

public extension UIDeviceOrientation {
    
    func toAVCaptureVideoOrientation() -> AVCaptureVideoOrientation {
        switch self {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeRight:
            return .landscapeLeft
        case .landscapeLeft:
            return .landscapeRight
        default:
            return .portrait
        }
    }
    
    func toInterfaceOrientationMask() -> UIInterfaceOrientationMask {
        switch self {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeRight:
            return .landscapeLeft
        case .landscapeLeft:
            return .landscapeRight
        default:
            return .portrait
        }
    }
    
    func toAngleRelativeToPortrait() -> CGFloat {
        switch self {
        case .portrait:
            return 0
        case .portraitUpsideDown:
            return CGFloat.pi
        case .landscapeRight:
            return -CGFloat.pi / 2.0
        case .landscapeLeft:
            return CGFloat.pi / 2.0
        default:
            return 0.0
        }
    }
    
}

public extension CMAcceleration {
    func toDeviceOrientation() -> UIDeviceOrientation? {
        if self.x >= 0.75 {
            return .landscapeRight
        } else if self.x <= -0.75 {
            return .landscapeLeft
        } else if self.y <= -0.75 {
            return .portrait
        } else if self.y >= 0.75 {
            return .portraitUpsideDown
        } else {
            return nil
        }
    }
}

open class DKDefaultCameraResource: DKCameraResource {
    
    open func imageForResource(_ name: String) -> UIImage {
        return UIImage(named: name)!
    }
    
    public func cameraCancelImage() -> UIImage {
        return imageForResource("camera_close")
    }
    
    public func cameraFlashOnImage() -> UIImage {
        return imageForResource("camera_flash_on")
    }
    
    public func cameraFlashAutoImage() -> UIImage {
        return imageForResource("camera_flash_auto")
    }
    
    public func cameraFlashOffImage() -> UIImage {
        return imageForResource("camera_flash_off")
    }
    
    public func cameraSwitchImage() -> UIImage {
        return imageForResource("camera_switch")
    }
}
