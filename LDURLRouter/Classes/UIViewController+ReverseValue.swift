//
//  UIViewController+ReverseValue.swift
//  LDURLRouter
//
//  Created by dong Li on 2023/12/27.
//

import UIKit


private var reserveValueKey : Void?
private var originUrlKey : Void?
private var pathKey : Void?
private var paramsKey : Void?

public extension UIViewController{
    typealias reverseBlock = (_ reserveValue : Any)->Void
    
    
     var reserveValue : reverseBlock?{
        set{
            objc_setAssociatedObject(self, &reserveValueKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return  objc_getAssociatedObject(self, &reserveValueKey) as? UIViewController.reverseBlock
        }
    }
    /** 跳转后控制器能拿到的url */
    var originUrl : URL?{
       set{
           objc_setAssociatedObject(self, &originUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
       }
       get{
           return  objc_getAssociatedObject(self, &originUrlKey) as? URL
       }
   }
    /** url路径  */
    var path : String?{
       set{
           objc_setAssociatedObject(self, &pathKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
       }
       get{
           return  objc_getAssociatedObject(self, &pathKey) as? String
       }
   }
    /** 跳转后控制器能拿到的参数 */
    var params : Dictionary<String, Any> {
       set{
           objc_setAssociatedObject(self, &paramsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
       }
       get{
           return  objc_getAssociatedObject(self, &paramsKey) as? Dictionary ?? [:]
       }
   }

}

extension UIViewController{
    static func initFromString(_ urlString: String,  query: Dictionary<String, Any> = [:],  configDict: Dictionary<String, Any>) -> UIViewController {

        return UIViewController.initFromURL(URL(string: urlString) ?? URL(fileURLWithPath: ""), query: query, configDict: configDict) ?? UIViewController()
    }
    @objc func open(_ url: URL, withQuery query: Dictionary<String, Any>?) {
        self.path = url.path
        self.originUrl = url
        
        self.params = query ?? [:]
    }
 
    func paramsURL(_ url: URL) -> Dictionary<String, Any> {
        
        
        return [:]
    }
    
    static func initFromURL(_ url: URL, query: Dictionary<String, Any>, configDict: Dictionary<String, Any>) -> UIViewController? {
        var home:String = ""
        guard let urlScheme = url.scheme else { return nil }
        guard let urlHost = url.host else { return nil }
        if url.path.isEmpty {
            home = urlScheme + "://" + urlHost
        }else {
            home = urlScheme + "://" + urlHost + url.path
        }
        var anyClass: AnyClass?
        if configDict.keys.contains(urlScheme) {
            guard let config = configDict[urlScheme] else { return nil }
            if let configStr:String = config as? String {
                anyClass = NSClassFromString(configStr)
                if let _ = anyClass {
                }else {
                    guard let spaceName = Bundle.main.infoDictionary?["CFBundleExecutable"] else { return nil }
                    guard let spaceNameStr = spaceName as? String else { return nil }
                    let spaceNameStr1 = spaceNameStr.replacingOccurrences(of: "-", with: "_")
                    anyClass = NSClassFromString(spaceNameStr1 + "." + configStr)
                }
            }else if let dict: Dictionary<String, String> = config as? Dictionary<String, String> {
                if dict.keys.contains(home) {
                    guard let homeValue = dict[home] else { return nil }
                    anyClass = NSClassFromString(homeValue)
                    if let _ = anyClass {
                    }else {
                        guard let spaceName = Bundle.main.infoDictionary?["CFBundleExecutable"] else { return nil }
                        guard let spaceNameStr = spaceName as? String else { return nil }
                        let spaceNameStr1 = spaceNameStr.replacingOccurrences(of: "-", with: "_")
                        anyClass = NSClassFromString(spaceNameStr1 + "." + homeValue)
                    }
                }
            }
        }
        guard let vcClass = anyClass as? UIViewController.Type else {
            NSLog("确定" + NSStringFromClass(anyClass ?? UIViewController.self) + "是UIViewController？")
            return nil
        }
        let vc = vcClass.init()
        vc.params = query
        vc.originUrl = url
        vc.path = url.path
        
        return vc
    }
        

}

