//
//  VideoImporter.swift
//  CameraCore
//
//  Created by hideyuki machida on 2018/08/08.
//  Copyright © 2018 町田 秀行. All rights reserved.
//

import Foundation
import Photos
import AVFoundation
import ProcessLogger_Swift

public final class CameraRollImporter: NSObject {
    public var onProgress: ((_ progress: Double)->Void)?
    public var onComplete: ((_ status: Bool)->Void)?
    
    public func start(data: CameraRollItem, importPath: URL, exportPreset: String, outputFileType: AVFileType) {
        switch data.mediaType {
        case .video:
            self.video(importPath: importPath, data: data, exportPreset: exportPreset, outputFileType: outputFileType)
        case .image: break
        case .audio: break
        case .unknown: break
        @unknown default: break
        }
    }

    public func start(mediaType: CameraRollAssetType, asset: AVURLAsset, importPath: URL, exportPreset: String, outputFileType: AVFileType) {
        switch mediaType {
        case .video:
            self.video(asset: asset, importPath: importPath, exportPreset: exportPreset, outputFileType: outputFileType)
        case .image: break
        case .audio: break
        case .unknown: break
        }
    }
    
    private func video(importPath: URL, data: CameraRollItem, exportPreset: String, outputFileType: AVFileType) {
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.deliveryMode = PHVideoRequestOptionsDeliveryMode.highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = {  (progress, error, stop, info) in
            DispatchQueue.main.async { [weak self] in
                self?.onProgress?(progress)
            }
        }

        PHImageManager.default().requestExportSession(forVideo: data.asset, options: options, exportPreset: exportPreset, resultHandler: { [weak self] (session: AVAssetExportSession?, info: [AnyHashable : Any]?) in
            
            guard let exportSession: AVAssetExportSession = session else { return }
            exportSession.outputFileType = outputFileType
            exportSession.outputURL = importPath
            exportSession.exportAsynchronously(completionHandler: { [weak self] in
                switch exportSession.status {
                case .completed:
                    ProcessLogger.successLog("importPHAsset: completed")
                    self?.onComplete?(true)
                case .waiting:
                    ProcessLogger.errorLog("importPHAsset: waiting")
                case .unknown:
                    ProcessLogger.errorLog("importPHAsset: unknown")
                case .exporting:
                    ProcessLogger.errorLog("importPHAsset: exporting")
                case .cancelled:
                    ProcessLogger.errorLog("importPHAsset: cancelled")
                    self?.onComplete?(false)
                case .failed:
                    ProcessLogger.errorLog("importPHAsset: failed")
                    self?.onComplete?(false)
                @unknown default:
                    self?.onComplete?(false)
                }
            })
            
        })
    }
    
    private func video(asset: AVURLAsset, importPath: URL, exportPreset: String, outputFileType: AVFileType) {
        guard let exportSession: AVAssetExportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetPassthrough) else { self.onComplete?(true); return }
        exportSession.outputFileType = outputFileType
        exportSession.outputURL = importPath
        exportSession.exportAsynchronously(completionHandler: { [weak self] in
            switch exportSession.status {
            case .completed:
                ProcessLogger.successLog("importPHAsset: completed")
                self?.onComplete?(true)
            case .waiting:
                ProcessLogger.errorLog("importPHAsset: waiting")
            case .unknown:
                ProcessLogger.errorLog("importPHAsset: unknown")
            case .exporting:
                ProcessLogger.errorLog("importPHAsset: exporting")
            case .cancelled:
                ProcessLogger.errorLog("importPHAsset: cancelled")
                self?.onComplete?(false)
            case .failed:
                ProcessLogger.errorLog("importPHAsset: failed")
                self?.onComplete?(false)
            @unknown default:
                self?.onComplete?(false)
            }
        })
    }

}
