import Flutter
import UIKit
import AVFoundation
import MobileCoreServices

public class SwiftQrUtilsPlugin: NSObject, FlutterPlugin, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
fileprivate var result:FlutterResult?
fileprivate var qrcodeImage: CIImage!
    
  fileprivate  var captureSession = AVCaptureSession()
    
   fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
   fileprivate   var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    var controller: FlutterViewController!

    init(cont: FlutterViewController, messenger: FlutterBinaryMessenger) {
          self.controller = cont;
          super.init();
      }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.aeologic.adhoc.qr_utils", binaryMessenger: registrar.messenger())

    let app =  UIApplication.shared
    let controller : FlutterViewController = app.delegate!.window!!.rootViewController as! 	FlutterViewController;
      
      let instance = SwiftQrUtilsPlugin.init(cont: controller, messenger: registrar.messenger())
      
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    self.result = result
            if (call.method == "scanQR") {
                print("scanQR")
                    if #available(iOS 10.0, *) {
                        self.openQRCamera()
                    }
            }
            else if (call.method == "scanImage") {
                self.openImagePicker()
            }
            else if (call.method == "generateQR") {
                let tempDataDict = call.arguments as? Dictionary<String, Any>
                let content = tempDataDict!["content"] as! String
                self.generateQR(text: content)
            }
  }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        controller!.dismiss(animated: true)
        
        if let features = detectQRCode(image), !features.isEmpty{
            for case let row as CIQRCodeFeature in features{
                print(row.messageString ?? "scan error")
                self.result!(row.messageString ?? "")
                return
            }
        }
        self.result!(nil)
    }
    
    func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image){
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features

        }
        return nil
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension SwiftQrUtilsPlugin {
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    
    func openQRCamera(){
        
        if !captureSession.isRunning {
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
        
                captureSession.addInput(input)
            
            // Set the input device on the capture session.
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = (UIApplication.shared.keyWindow!.rootViewController?.view.layer.bounds)! //QRView.layer.bounds
        UIApplication.shared.keyWindow!.rootViewController?.view.layer.addSublayer(videoPreviewLayer!)
        // Start video capture.
        captureSession.startRunning()

        // Initialize QR Code Frame to highlight the QR code
        
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            UIApplication.shared.keyWindow!.rootViewController?.view.addSubview(qrCodeFrameView)
            UIApplication.shared.keyWindow!.rootViewController?.view.bringSubviewToFront(qrCodeFrameView)
        }
        }
    
    }
    
    func openImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        controller!.present(pickerController, animated: true)
    }

    func generateQR(text:String){
        if qrcodeImage == nil {
            if text == "" {
                return
            }
            let data = text.data(using: .isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
        
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            displayQRCodeImage()
        }
        else {
            qrcodeImage = nil
        }
    }
    func displayQRCodeImage() {
        let scaleX = 263 / qrcodeImage.extent.size.width
        let scaleY = 263 / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        let img:UIImage =  convert(cmage: transformedImage)
        let imageData: Data = img.pngData()!
        self.result!(imageData)
    }
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}

extension SwiftQrUtilsPlugin: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
          //  messageLabel.text = "No QR code is detected"
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            print(metadataObj.stringValue!)
            if metadataObj.stringValue != nil {
               // launchApp(decodedURL: metadataObj.stringValue!)
                self.result!(metadataObj.stringValue!)
                qrCodeFrameView?.frame = CGRect.zero
                videoPreviewLayer?.removeFromSuperlayer()
                captureSession = AVCaptureSession()
                self.captureSession.stopRunning()
            }
        }
    }
}
