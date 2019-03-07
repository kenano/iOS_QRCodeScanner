//
//  QRScannerViewController.swift
//  QRCodeScanner
//
//  Created by Kenan Ozdamar on 2/26/19.
//  Copyright © 2019 OKO. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {
    
    // MARK: actions/outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var topbar: UIView!
    
    // M
    @IBAction func closeViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - ivars
    // captureSession will coordinate data from input to output.
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrFrameView: UIView?
    
    
    // MARK: viewcontroller overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the back facing camera
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Error - failed to read camera device.")
            return
        }
        
        do {
            // get a ref to to the captureDevices input and pass that to the captureSession.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            // AVCaptureMetadataOutput is used to capture any metadata found in input
            // a QR code is a type of metadata.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // set the delegate for metadataObjects to self since this class extends AVCaptureMetadataOutputObjectsDelegate
            // set the metadata object type as qr (for QR code)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
        } catch {
            print(error)
            return
        }
        
        // move ui elements to the front so they are not blocked by the cameras view.
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(topbar)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
