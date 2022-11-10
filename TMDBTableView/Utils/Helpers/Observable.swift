//
//  ObservableObject.swift
//  TMDBTableView
//
//  Created by qbuser on 02/10/22.

import Foundation

class Observable<T> {
    
    // Since this is a stored closure everything that this closure
    // captures will be retained during the lifetime of an instance of this class.
    typealias Listener = ((T) -> Void)
    private var listener: Listener?
    
    var value: T {
        didSet{ fireListenerOnMainThread() }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        fireListenerOnMainThread()
    }
    
    deinit{
        print("Observable object is deinitialized")
    }
    
    private func fireListenerOnMainThread() {
        /*
         This closure is an escaping closure which means we we do not know when this
         closure will be called. In this case it is escaping because it gets captured (retained)
         by the task which means this closure will be called at any time in the near future. If self is strongl
         referenced from inside of this closure we have
         a strong strong reference cycle or retain cycle and we don't want that to happen.
         So a capture list is used for the closure to capture self and make it a weak reference.
         
         Since we will use this object to update UI stuff in the View/ViewController,
         it is always safe to dispatch the action on the main thread to avoid crashes.
         */
        
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self, let strongListener = strongSelf.listener else { return }
            strongListener(strongSelf.value)
        }
    }
    
}
