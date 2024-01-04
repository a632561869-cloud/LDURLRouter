//
//  LDURLRouter.swift
//  LDURLRouter
//
//  Created by dong Li on 2023/12/27.
//

import UIKit
import Foundation


public final class LDURLRouter : NSObject{
    
    static let shared = LDURLRouter()
    private var configDict : Dictionary<String, Any> = [:]
    private override init() {
        super.init()
        
    }
    
    public static func loadConfigDict(fromPlist : String){
        if fromPlist.hasSuffix(".plist") {
            if let url = Bundle.main.url(forResource: fromPlist, withExtension: nil) {
                do {
                    let data = try Data(contentsOf: url)
                    let swiftDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                    LDURLRouter.shared.configDict = swiftDictionary
                } catch {
                    NSLog("请按照说明添加对应的plist文件")
                }
            }
        }else if let url = Bundle.main.url(forResource: fromPlist, withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                let swiftDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                LDURLRouter.shared.configDict = swiftDictionary
            } catch {
                NSLog("请按照说明添加对应的plist文件")
            }
        }
    }
    
    /// 通用路由路径跳转
    /// - Parameters:
    ///   - urlString: 路由字符串
    ///   - query: 传递参数
    ///   - animated: 跳转动画
    ///   - replace: 是否替代当前界面，默认flase
    ///   - reverseBlock: 自定义回调
    public static func pushURLString(_ urlString : String, query : Dictionary<String, Any> = [:], animated : Bool = true ,replace : Bool = false ,_ reverseBlock : ((_ reserveValue : Any)->Void)? = { reserveValue in}){
        
        let vc = UIViewController.initFromString(urlString,query: query, configDict: LDURLRouter.shared.configDict)
        vc.reserveValue = {value in
            reverseBlock?(value)
        }
        LDURLRouter.pushViewController(vc,animated: animated, replace)
        
    }
    
    /// 通用模态视图路由路径跳转
    /// - Parameters:
    ///   - urlString: 路由字符串
    ///   - query: 传递参数
    ///   - animated: 跳转动画
    ///   - completion: 跳转完成后的回调
    ///   - reverseBlock: 自定义回调
    public static func presentURLString(_ urlString : String, query : Dictionary<String, Any>? = [:], animated : Bool = true ,completion : (()->Void)? = {} ,_ reverseBlock : ((_ reserveValue : Any)->Void)? = { reserveValue in}){
        
        let vc = UIViewController.initFromString(urlString, configDict: LDURLRouter.shared.configDict)
        vc.reserveValue = {value in
            reverseBlock?(value)
        }
        LDURLRouter.presentViewController(vc, query: query,animated: animated, completion: completion)
        
    }
    
    
    /// 跳转到新页面【概述】
    ///
    /// - Parameter viewController: 要跳转的控制器
    /// - Parameter animated: 是否需要跳转动画
    /// - Parameter replace:如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.
    ///
    public static func pushViewController(_ viewController: UIViewController?, animated: Bool, _ replace: Bool) {
        guard let vc = viewController else {
            NSLog("请添加与url相匹配的控制器到plist文件中,或者协议头可能写错了!")
            return
        }
        if vc.isKind(of: UINavigationController.self) {
            setRootViewController(vc)
        } else {
            guard let navigationController = currentNavigationViewController else {
                setRootViewController(UINavigationController(rootViewController: vc))
                return
            }
            if replace {
                var viewControllers = navigationController.viewControllers
                viewControllers.removeLast()
                viewControllers.append(vc)
                navigationController.setViewControllers(viewControllers, animated: animated)
            } else {
                navigationController.pushViewController(vc, animated: animated)
            }
        }
    }
    
    /// 跳转到新页面【概述】
    ///
    /// - Parameter viewController: 要跳转的控制器
    /// - Parameter animated: 是否需要跳转动画
    /// - Parameter completion:跳转完成后需要的操作
    ///
    public static func presentViewController(_ viewController: UIViewController?,query : Dictionary<String, Any>? = [:], animated: Bool, completion: (() -> Void)? = nil) {
        guard let vc = viewController else {
            NSLog("请添加与url相匹配的控制器到plist文件中,或者协议头可能写错了!")
            return
        }
        guard let currentVC = currentViewController else {
            setRootViewController(vc)
            return
        }
        vc.params = query ?? [:]
        currentVC.present(vc, animated: animated, completion: completion)
    }
    
    /// 返回前控制器n次【概述】
    ///
    /// - Parameter times: 需要返回的次数
    /// - Parameter animated: 是否需要跳转动画
    ///
    public static func popViewController(times: Int = 1, animated: Bool) {
        guard let count:Int = currentNavigationViewController?.viewControllers.count else { return }
        guard let navigationC = currentNavigationViewController else { return }
        if count > times {
            navigationC.popToViewController(navigationC.viewControllers[count - 1 - times], animated: animated)
        }else {
            NSLog("确定可以pop掉那么多控制器?")
        }
    }
    
    /// 返回前控制器2次【概述】
    ///
    /// - Parameter animated: 是否需要跳转动画
    ///
    public static func popTwiceViewController(animated: Bool) {
        popViewController(times: 2, animated: animated)
    }
    
    /// 返回到根控制器【概述】
    ///
    /// - Parameter animated: 是否需要跳转动画
    ///
    public static func popToRootViewController(animated: Bool) {
        guard let count:Int = currentNavigationViewController?.viewControllers.count else { return }
        popViewController(times: count - 1, animated: animated)
    }
    
    /// 返回前控制器n次【概述】
    ///
    /// - Parameter times: 需要返回的次数
    /// - Parameter animated: 是否需要跳转动画
    /// - Parameter completion:跳转完成后需要的操作
    ///
    public static func dismissViewController(times: Int = 1, animated: Bool, completion: (() -> Void)? = nil) {
        guard var currentVC = currentViewController else { return }
        if times == 0 { return }
        for _ in 1...times {
            guard let currentVC_1 = currentVC.presentingViewController else {
                NSLog("确定能dismiss掉这么多控制器?")
                return
            }
            currentVC = currentVC_1
        }
        currentVC.dismiss(animated: animated, completion: completion)
    }
    
    /// 返回前控制器2次【概述】
    ///
    /// - Parameter animated: 是否需要跳转动画
    /// - Parameter completion:跳转完成后需要的操作
    ///
    public static func dismissTwiceViewController(animated: Bool, completion: (() -> Void)? = nil) {
        dismissViewController(times: 2, animated: animated, completion: completion)
    }
    
    /// 返回根控制器【概述】
    ///
    /// - Parameter animated: 是否需要跳转动画
    /// - Parameter completion:跳转完成后需要的操作
    ///
    public static func dismissToRootViewController(animated: Bool, completion: (() -> Void)? = nil) {
        guard var currentVC = currentViewController else { return }
        while let currentVC_1 = currentVC.presentingViewController {
            currentVC = currentVC_1
        }
        currentVC.dismiss(animated: animated, completion: completion)
    }
    
    // Mark: -取出当前手机屏幕显示的界面
    public static var currentViewController: UIViewController? {
        var resultVC: UIViewController? = LDURLRouter.topVC(UIApplication.shared.keyWindow?.rootViewController)
        while resultVC?.presentedViewController != nil {
            resultVC = LDURLRouter.topVC(resultVC?.presentedViewController)
        }
        return resultVC ?? UIViewController()
    }
    static private func topVC(_ vc: UIViewController?) -> UIViewController? {
        if vc is UINavigationController {
            return topVC((vc as? UINavigationController)?.topViewController)
        }
        else if vc is UITabBarController {
            return topVC((vc as? UITabBarController)?.selectedViewController)
        }
        else {
            return vc
        }
    }
    // Mark: - 取出当前手机屏幕显示的界面的导航控制器
    static var currentNavigationViewController: UINavigationController? {
        currentViewController?.navigationController
    }
    
    
    // Mark: - 返回当前控制器的前一个控制器
    static var lastViewController: UIViewController? {
        guard let count: Int = currentNavigationViewController?.childViewControllers.count else { return nil }
        if count<2 {
            return nil
        } else {
            return currentNavigationViewController?.childViewControllers[count - 2]
        }
    }
    
    /// 设置为根控制器【概述】
    ///
    /// - Parameter viewController: 跟控制器
    ///
    static func setRootViewController(_ viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    
    
    
}
