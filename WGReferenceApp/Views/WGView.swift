//
//  WGView.swift
//  HelloEarth
//
//  Created by Jess Taylor on 5/19/21.
//

import SwiftUI
import UIKit

struct WGView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> WhirlyGlobeViewController {
        let wgc = WhirlyGlobeViewController()
        wgc.delegate = context.coordinator
        return wgc
    }
    
    func updateUIViewController(_ uiViewController: WhirlyGlobeViewController, context: Context) {
        if uiViewController.delegate is WhirlyGlobeViewCoordinator {
            (uiViewController.delegate as! WhirlyGlobeViewCoordinator).loadTiles(uiViewController)
        }
    }
    
    func makeCoordinator() -> WhirlyGlobeViewCoordinator {
        WhirlyGlobeViewCoordinator()
    }

}

enum MapStyle {
    case Stamen
    case ESRI
}

class WhirlyGlobeViewCoordinator: NSObject, WhirlyGlobeViewControllerDelegate {

    let mapSyle: MapStyle = .Stamen
    var imageLoader : MaplyQuadImageLoader? = nil
    
    func loadTiles(_ uiViewController: WhirlyGlobeViewController) {

        if imageLoader == nil {
            let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            let thisCacheDir: String!
            let minZoom: Int32 = 0
            let maxZoom: Int32!
            let tileInfo: MaplyRemoteTileInfoNew!
            if mapSyle == .Stamen {
                thisCacheDir = "\(cacheDir)/esri/"
                maxZoom = Int32(16)
                tileInfo = MaplyRemoteTileInfoNew(baseURL: "http://tile.stamen.com/watercolor/{z}/{x}/{y}.png",
                                                  minZoom: minZoom,
                                                  maxZoom: maxZoom)
            } else {
                thisCacheDir = "\(cacheDir)/stamentiles/"
                maxZoom = Int32(16)
                tileInfo = MaplyRemoteTileInfoNew(baseURL: "https://services.arcgisonline.com/ArcGIS/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}.png",
                                                  minZoom: minZoom,
                                                  maxZoom: maxZoom)
            }
            tileInfo.cacheDir = thisCacheDir
            
            let sampleParams = MaplySamplingParams()
            sampleParams.coordSys = MaplySphericalMercator(webStandard: ())
            sampleParams.coverPoles = true
            sampleParams.edgeMatching = true
            sampleParams.minZoom = tileInfo.minZoom
            sampleParams.maxZoom = tileInfo.maxZoom
            sampleParams.singleLevel = true
            
            if let il = MaplyQuadImageLoader(params: sampleParams, tileInfo: tileInfo, viewC: uiViewController) {
                il.baseDrawPriority = kMaplyImageLayerDrawPriorityDefault
                self.imageLoader = il
            } else {
                print("Failed to instantiate the MaplyQuadImageLoader")
            }
        }
        
    }
    
}
