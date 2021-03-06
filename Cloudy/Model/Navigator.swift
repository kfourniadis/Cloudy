// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import GameController

/// Model class to map navigation based on url
class Navigator {

    /// Some global constants
    struct Config {
        /// Mapping from a alias to a full url
        static let aliasMapping: [String: String] = [
            "stadia": Url.googleStadia.absoluteString,
            "gfn": Url.geforceNowOld.absoluteString,
        ]

        struct Url {
            static let googleStadia   = URL(string: "https://stadia.google.com")!
            static let googleAccounts = URL(string: "https://accounts.google.com")!
            static let geforceNowOld  = URL(string: "https://play.geforcenow.com")!
            static let geforceNowBeta = URL(string: "https://beta.play.geforcenow.com")!
            static let boosteroid     = URL(string: "https://cloud.boosteroid.com")!
            static let nvidiaRoot     = URL(string: "https://www.nvidia.com")!
            static let amazonLuna     = URL(string: "https://amazon.com/luna")!
            static let gamepadTester  = URL(string: "https://gamepad-tester.com")!
            static let patreon        = URL(string: "https://www.patreon.com/cloudyApp")!
            static let paypal         = URL(string: "https://paypal.me/pools/c/8tPw2veZIm")!
        }

        struct UserAgent {
            static let chromeDesktop = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"
            static let chromeOS      = "Mozilla/5.0 (X11; CrOS aarch64 13099.85.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.110 Safari/537.36"
            static let iPhone        = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15"
            static let safariIOS     = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Safari/605.1.15"
        }
    }

    /// The navigation that shall be executed
    struct Navigation {
        let userAgent:    String?
        let forwardToUrl: URL?
        let bridgeType:   CloudyController.JsonType
    }

    /// Map navigation address
    func getNavigation(for address: String?) -> Navigation {
        // early exit
        guard let requestedUrl = address else {
            return Navigation(userAgent: nil, forwardToUrl: nil, bridgeType: .regular)
        }
        // no automatic navigation
        if UserDefaults.standard.useManualUserAgent {
            return Navigation(userAgent: UserDefaults.standard.manualUserAgent, forwardToUrl: nil, bridgeType: .regular)
        }
        // map alias
        let navigationUrl = Config.aliasMapping[requestedUrl] ?? requestedUrl
        // old regular geforce now
        if navigationUrl.starts(with: Config.Url.geforceNowOld.absoluteString) {
            return Navigation(userAgent: Config.UserAgent.chromeOS, forwardToUrl: nil, bridgeType: .regular)
        }
        return Navigation(userAgent: nil, forwardToUrl: nil, bridgeType: .regular)
    }

    /// Handle popup
    func shouldOpenPopup(for url: String?) -> Bool {
        // early exit
        guard let url = url else {
            return false
        }
        if url.starts(with: Config.Url.boosteroid.absoluteString) {
            return false
        }
        return true
    }
}
