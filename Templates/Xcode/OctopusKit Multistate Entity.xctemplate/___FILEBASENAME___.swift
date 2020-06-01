//___FILEHEADER___

import SpriteKit
import GameplayKit
import OctopusKit

final class ___FILEBASENAMEASIDENTIFIER___: OKEntity {
    
    init(parentNode: SKNode) {
        
        super.init(name: "___FILEBASENAME___")
        
        /// For more granular control of states, modify the `___FILEBASENAMEASIDENTIFIER___InactiveState` and `___FILEBASENAMEASIDENTIFIER___ActiveState` code.
        
        // MARK: Inactive State
        
        let inactiveState = ___FILEBASENAMEASIDENTIFIER___InactiveState(entity: self)
        
        inactiveState.componentsToAddOnEntry = [] // Customize
        
        inactiveState.syncComponentArrays()
        
        // MARK: Active State
        
        let activeState = ___FILEBASENAMEASIDENTIFIER___ActiveState(entity: self)
        
        activeState.componentsToAddOnEntry = [] // Customize
        
        activeState.syncComponentArrays()
        
        // MARK: State Machine
        
        let stateMachine = GKStateMachine(states: [
            inactiveState,
            activeState
            ])
        
        // MARK: Components common to every state
        
        // Add components in the order of dependency; e.g., the states of the `StateMachineComponent` may depend on other components, so add it last.
        
        self.addComponents([
            StateMachineComponent(stateMachine: stateMachine,
                                  stateOnAddingToEntity: ___FILEBASENAMEASIDENTIFIER___InactiveState.self),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
}

// MARK: - ___FILEBASENAMEASIDENTIFIER___InactiveState

// This class may be moved out to a separate file and customized.

final class ___FILEBASENAMEASIDENTIFIER___InactiveState: OKEntityState {
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        switch previousState {
            
        case is ___FILEBASENAMEASIDENTIFIER___ActiveState:
            // entity.removeComponents([])
            // entity.addComponents([])
            break
            
        default:
            break
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ___FILEBASENAMEASIDENTIFIER___ActiveState.Type
    }
}

// MARK: - ___FILEBASENAMEASIDENTIFIER___ActiveState

// This class may be moved out to a separate file and customized.

final class ___FILEBASENAMEASIDENTIFIER___ActiveState: OKEntityState {
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        switch previousState {
            
        case is ___FILEBASENAMEASIDENTIFIER___InactiveState:
            // entity.removeComponents([])
            // entity.addComponents([])
            break
            
        default:
            break
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ___FILEBASENAMEASIDENTIFIER___InactiveState.Type
    }
}
