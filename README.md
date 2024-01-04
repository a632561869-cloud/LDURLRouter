一个支持swift的路由跳转
==
# 支持push、present、http网页跳转
`<func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        LDURLRouter.loadConfigDict(fromPlist: "URLRouter.plist")
        return true
    }>`
