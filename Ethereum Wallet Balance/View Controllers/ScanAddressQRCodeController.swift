//
//  ScanAddressQRCodeController.swift
//  Ethereum Wallet Balance
//
//  Created by Daniel Valencia on 8/13/21.
//

import UIKit
import AVFoundation

class ScanAddressQRCodeController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Properties
    
    weak var delegate: AddressQRCodeScanDelegate?
    
    private let captureSession = AVCaptureSession()
    
    private lazy var videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgroundColor
        setupNavigationBar()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestAuthorizationForCamera()
        setupVideoPreviewLayer()
    }
    
    private func requestAuthorizationForCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                
                print("Permission stauts: \(granted)")
                
                if granted {
                    self.setupCaptureSession()
                } else {
                    DispatchQueue.main.async {
                        self.presentAlertViewController(with: "Error", message: "Access to the device's camera is required to scan an Ethereum address QR Code.") {
                            self.dismissThisViewController()
                        }
                    }
                }
            }
        } else if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            setupCaptureSession()
        }
    }
    
    private func setupCaptureSession() {
        captureSession.beginConfiguration()
        guard let cameraInput = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: cameraInput)
            
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            }
        } catch let error {
            presentAlertViewController(with: "Error", message: error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]
        }
        
        captureSession.commitConfiguration()
        
        captureSession.startRunning()
    }
    
    private func setupVideoPreviewLayer() {
        videoPreviewLayer.frame = view.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.backward"), style: .plain, target: self, action: #selector(dismissThisViewController))
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()
        
        if let metadataObjects = metadataObjects.first {
            if let readableObject = metadataObjects as? AVMetadataMachineReadableCodeObject {
                if let address = readableObject.stringValue {
                    delegate?.didScanQRCode(value: address)
                    dismissThisViewController()
                }
            }
        }
        
    }
    
    // MARK: - Selectors
    
    @objc private func dismissThisViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}
