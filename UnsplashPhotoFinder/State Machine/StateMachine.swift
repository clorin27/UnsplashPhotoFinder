//
//  StateMachine.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/8/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation
import UIKit

/// Protocol to which StateMachine delegates must adhere.
protocol StateMachineDelegateProtocol: class {

    /**
     Generic type used to represent different States.
     */
    associatedtype StateType

    /**
     Checks whether or not the State Machine should transition between states.

     - parameter from: State from which the State Machine is transitioning. This is the current
     state of the State Machine

     - parameter to: State to which the State Machine is transitioning.

     - returns: Boolean defining wether or not to transition between the provided states.

     */
    func shouldTransition(from: StateType, to: StateType) -> Bool

    /**
     Notifies the delegate that the state machine has transitioned between states

     - parameter from: State from which the State Machine is transitioning. This is the current
     state of the State Machine

     - parameter to: State to which the State Machine is transitioning.

     */
    func didTransition(from: StateType, to: StateType)
}

/**
 Simple State Machine implimentation. Must be provided a delegate that conforms to
 the StateMachineDelegateProtocol.
 */
class StateMachine<P:StateMachineDelegateProtocol> {
    private unowned let delegate: P
    private var _state: P.StateType {
        didSet { delegate.didTransition(from: oldValue, to: _state) }
    }
    /**
     Current state of the State Machine.
     */
    var state: P.StateType {
        get { return _state }
        set {
            if delegate.shouldTransition(from: _state, to: newValue) {
                _state = newValue
            }
        }
    }

    /**
     Initializes a newly created StateMachine with the provided parameters.

     - parameter initialState: State in which the State Machine will start.

     - parameter delegate: Delegate to the State Machine. Conforms to StateMachineDelegateProtocol.
     */
    init(initialState: P.StateType, delegate: P) {
        _state = initialState
        self.delegate = delegate
    }
}
