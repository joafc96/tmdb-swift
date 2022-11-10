//
//  Coordinator.swift
//  TMDBTableView
//
//  Created by qbuser on 10/11/22.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {
    func didFinish(from coordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    func start()
    
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}


// MARK: - Default Implementation
extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
