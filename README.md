
# 📦 Marie Integration Guide

O `Marie` é um package para apresentação global de um modal customizado em qualquer ponto da aplicação, com suporte tanto a UIKit quanto SwiftUI. Ele permite a interceptação de requisições de rede via `MarieCustomURLProtocol` para melhor análise em aplicativos de release.

---

## ✅ Requisitos

- UIKit - iOS 12.0+
- SwiftUI - iOS 12.0+
- Swift 5+

---

## ⚙️ Instalação

Adicione o package ao seu projeto via Swift Package Manager.

```swift
https://github.com/seu-usuario/marie.git
```

---

## 🧩 Como usar

### 1. Substituir a janela principal pela `MarieWindow`

---

### UIKit (SceneDelegate)

```swift
import UIKit
import Marie

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = MarieWindow(windowScene: windowScene)
        window.rootViewController = YourRootViewController() // Seu view controller principal
        self.window = window
        window.makeKeyAndVisible()
    }
}
```

---

### UIKit (AppDelegate - iOS 12 ou sem SceneDelegate)

```swift
import UIKit
import Marie

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = MarieWindow(frame: UIScreen.main.bounds)
        window.rootViewController = YourRootViewController()
        self.window = window
        window.makeKeyAndVisible()

        return true
    }
}
```

---

### SwiftUI (`@main`)

```swift
import SwiftUI
import Marie

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            EmptyView() // A view será injetada via MarieWindow
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = MarieWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: ContentView()) // SwiftUI
            self.window = window
            window.makeKeyAndVisible()
        }

        return true
    }
}
```

---

### 2. Abertura global do modal

De três toques, sendo o terceiro mais longo, deverá abrir o `RequestSheetViewController` automaticamente, sem precisar chamar manualmente.

---

### 3. Interceptar requisições de rede com `MarieCustomURLProtocol`

Para capturar/interceptar as requisições feitas com `URLSession`, substitua a `URLSessionConfiguration` usada no app:

```swift
import Marie

let config = MarieSessionConfiguration.defaultUsing(.default)
let session = URLSession(configuration: config)
```

Se você usa uma `NetworkManager`, configure lá:

```swift
class NetworkManager {
    private let session = URLSession(configuration: MarieSessionConfiguration.defaultUsing(.default))

    // continue usando o session normalmente...
}
```

## 💬 Dicas

- O gesto pode ser customizado no seu `MarieWindow`.
- A `MarieWindow` pode ser estendida com mais funções além do modal.
- O `MarieCustomURLProtocol` pode ser usado para debugging, proxy, ou rastreamento de analytics.

---

## 📱 Suporte

Compatível com UIKit a partir do iOS 12 e SwiftUI a partir do iOS 13.

---

