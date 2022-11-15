//
//  Coordinator.swift
//  TMDBTableView
//
//  Created by qbuser on 10/11/22.
//

import UIKit

// MARK: - Coordinator
protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// Each coordinator has one navigation controller assigned to it.
    var navigationController: UINavigationController { get }
    
    /// Array to keep tracking of all child coordinators. Most of the time this array will contain only one child coordinator.
    var childCoordinators: [Coordinator] { get set }
    
    /// Defined flow type.
    var type: CoordinatorType { get }
    
    /// A place to put logic to start the flow.
    func start()
    
    /// A place to put logic to finish the flow, to clean all children coordinators, and to notify the parent that this coordinator is ready to be deallocated
    func finish()
    
    init(navigationController: UINavigationController)
    
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(from: self)
    }
}

/// Default implementation for adding and removing child coordinators
extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

// MARK: - CoordinatorOutput
/// Delegate protocol helping parent Coordinator know when its child is ready to be finished.
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(from coordinator: Coordinator)
}

// MARK: - CoordinatorType
/// Using this structure we can define what type of flow we can use in-app.
enum CoordinatorType {
    case app, login, tab
}
