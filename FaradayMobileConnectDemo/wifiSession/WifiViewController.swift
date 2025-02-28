import UIKit
import DLProgressHUD
import Network
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import FNMobileConnect

class WifiViewController: UIViewController {
    
    @IBOutlet weak var ssidName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var nationalId: UITextField!
    @IBOutlet weak var passportNumber: UITextField!
    
    @IBOutlet weak var appNameText: UILabel!
    @IBOutlet weak var successResultText: UITextView!
    @IBOutlet weak var connectButton: UIButton!
    
    var deeplinkUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        ssidName.delegate = self
        countryCode.delegate = self
        phoneNumber.delegate = self
        nationalId.delegate = self
        passportNumber.delegate = self

        setUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func getCurrentSSID() -> String? {
        if let interfaces = CNCopySupportedInterfaces() as? [String] {
            for interface in interfaces {
                if let info = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
                    return info[kCNNetworkInfoKeySSID as String] as? String
                }
            }
        }
        return nil
    }
    
    func checkCurrentSSID(ssid: String) -> Bool {
        if let currentSSID = getCurrentSSID() {
            if (currentSSID == ssid) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func joinOpenWifi(ssid: String) {
        let wifiConfig = NEHotspotConfiguration(ssid: ssid)
        wifiConfig.joinOnce = false

        NEHotspotConfigurationManager.shared.apply(wifiConfig) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.successResultText.text = "Bağlantı hatası: \(error.localizedDescription)"
                    self.successResultText.textColor = .red
                }
            }
        }
    }

    private func startToConnect(countryCode: String, msisdn: String, nationalId: String, passport: String){
        
        let baseUrl: String = "http://captive.faraday.net"
        let connectionUrls: [String] = ["https://service-provider-url.com", "https://service-provider-url2.com"]

        let mobileConnect = FNEdgeMobileConnect()
        mobileConnect.setMaxRetryCount(10)
        mobileConnect.setRetryInterval(1)
        mobileConnect.setBaseUrl(baseUrl)
        mobileConnect.setConnectionUrls(connectionUrls)

        let marketingPermission: Bool = true
        let shareDataPermission: Bool = true
        let storeDataPermission: Bool =  false
        
        var deeplinkUrl: String = ""
        if let receivedDeeplink = DeeplinkManager.shared().deeplinkURL {
            deeplinkUrl = receivedDeeplink.absoluteString
        }
        
        mobileConnect.connectWifi(deeplinkUrl:deeplinkUrl, countryCode: countryCode ,msisdn: msisdn, passport: passport, nationalId: nationalId, marketingPermission: marketingPermission,
                                 shareDataPermission: shareDataPermission, storeDataPermission: storeDataPermission, completion: { result in
            print("FaradayEdgeSDKDemo errorCode: ", result.getErrorCode())
            print("FaradayEdgeSDKDemo success: ", result.getSuccess())
            print("FaradayEdgeSDKDemo message: ", result.getMessage())
            print("FaradayEdgeSDKDemo mac: ", result.getMac())
            
            DispatchQueue.main.async {
                self.hideProgressIndicator()
                let outputText = """
                SDK errorCode: \(result.getErrorCode())
                SDK success: \(result.getSuccess())
                SDK message: \(result.getMessage())
                SDK mac: \(result.getMac())
                """
                self.successResultText.text = outputText
                self.successResultText.textColor = .black
            }
        })
    }
                
    @IBAction func actionConnect(_ sender: Any) {
        var ssidNameValue: String = ""
        var countryCodeValue: String = ""
        var phoneNumberValue: String = ""
        var nationalIdValue: String = ""
        var passportNumberValue: String = ""

        if let ssidNameText = ssidName.text, !ssidNameText.isEmpty {
            ssidNameValue = ssidNameText
        }

        if let countryCodeText = countryCode.text, !countryCodeText.isEmpty {
            countryCodeValue = countryCodeText
        }

        if let phoneNumberText = phoneNumber.text, !phoneNumberText.isEmpty {
            phoneNumberValue = phoneNumberText
        }

        if let nationalIdText = nationalId.text, !nationalIdText.isEmpty {
            nationalIdValue = nationalIdText
        }

        if let passportNumberText = passportNumber.text, !passportNumberText.isEmpty {
            passportNumberValue = passportNumberText
        }
      
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            let isWiFiConnected = path.usesInterfaceType(.wifi)
            if isWiFiConnected {
                if (!ssidNameValue.isEmpty) {
                    if (self.checkCurrentSSID(ssid: ssidNameValue)) {
                        self.showProgressIndicator()
                        self.startToConnect(countryCode: countryCodeValue, msisdn: phoneNumberValue,
                                            nationalId: nationalIdValue, passport: passportNumberValue)
                    } else {
                        self.joinOpenWifi(ssid: ssidNameValue)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showProgressIndicator()
                        self.startToConnect(countryCode: countryCodeValue, msisdn: phoneNumberValue,
                                            nationalId: nationalIdValue, passport: passportNumberValue)
                    }
                }
            } else {
                if (!ssidNameValue.isEmpty) {
                    self.joinOpenWifi(ssid: ssidNameValue)
                } else {
                    DispatchQueue.main.async {
                        self.successResultText.text = "The device has no access to WiFi."
                        self.successResultText.textColor = .red
                    }
                }
            }
            monitor.cancel()
        }
    }
    
    @IBAction func closeAppAction(_ sender: Any) {
        exit(0)
    }
    
    private func setUI(){
        successResultText.isHidden = false
        
        connectButton.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "login_background")
        backgroundImage.frame = view.bounds
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        appNameText.textColor = UIColor(red: 20/255, green: 35/255, blue: 71/255, alpha: 1.0)
        
        ssidName.backgroundColor = UIColor.white
        ssidName.textColor = UIColor.black
        
        countryCode.backgroundColor = UIColor.white
        countryCode.textColor = UIColor.black
        
        phoneNumber.backgroundColor = UIColor.white
        phoneNumber.textColor = UIColor.black
        
        nationalId.backgroundColor = UIColor.white
        nationalId.textColor = UIColor.black
        
        passportNumber.backgroundColor = UIColor.white
        passportNumber.textColor = UIColor.black

        ssidName.attributedPlaceholder = NSAttributedString(
            string: "SSID Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)]
        )
        countryCode.attributedPlaceholder = NSAttributedString(
            string: "+1",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)]
        )
        
        phoneNumber.attributedPlaceholder = NSAttributedString(
            string: "Phone number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)]
        )
        
        nationalId.attributedPlaceholder = NSAttributedString(
            string: "National id",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)]
        )
        
        passportNumber.attributedPlaceholder = NSAttributedString(
            string: "Passport number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)]
        )
        
    }
    
    public func getDeeplinkUrl() -> String {
        return deeplinkUrl ?? ""
    }
    
    public func setDeeplinkUrl(_ value: String) {
        self.deeplinkUrl = value
    }

}

extension WifiViewController: UITextFieldDelegate{
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let textFields: [UITextField] = [ssidName, phoneNumber, countryCode, nationalId, passportNumber]
        
        for textField in textFields {
            if !textField.frame.contains(sender.location(in: view)) {
                textField.resignFirstResponder()
            }
        }
    }
        
    // MARK: - MBProgressHUD
    func showProgressIndicator() {
        DLProgressHUD.show(.loadingWithText("Connecting..."))
    }
    
    func hideProgressIndicator() {
        DLProgressHUD.dismiss()
    
    }
         
    // MARK: - UITextFieldDelegate
    // MARK: - Alert
    
    private func showAlert(with msg:String, isError: Bool) {
        let title = isError ? "Error" : ""
        let alertController = UIAlertController(title: title, message:msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
