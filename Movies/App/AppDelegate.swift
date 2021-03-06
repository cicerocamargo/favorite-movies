//
//  AppDelegate.swift
//  Movies
//
//  Created by Cícero Camargo on 13/05/18.
//  Copyright © 2018 Camargo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let state = ListMoviesState(favoritesManager: DefaultFavoriteMoviesManager(), movieProvider: OMDBMovieProvider())
        let moviesViewController = ListMoviesViewController(state: state)
        window?.rootViewController = UINavigationController(rootViewController: moviesViewController)
        window?.makeKeyAndVisible()
        return true
    }
}

