//
//  Entity.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2019/11/15.
//  Copyright © 2020 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

import SwiftUI
import GameplayKit

/// Adds an entity to the current scene, if any.
///
/// Chain `Entity()` with `.component(_:)` or `.components(_:)` to add components.
///
/// - IMPORTANT: PROTOTYPE - NOT FULLY IMPLEMENTED!
public struct Entity: View {
    
    private var entity: OKEntity? {
        OctopusKit.shared.gameCoordinator.currentScene?.entities(withName: "\(entityID)")?.first
    }
    
    @State private var entityID = UUID()
    
    public init() {
        guard
            let gameCoordinator = OctopusKit.shared.gameCoordinator,
            let currentScene = gameCoordinator.currentScene
            else { return }
        
        currentScene.createEntity(withUUID: entityID)
    }
    
    public var body: some View {
        EmptyView()
    }
    
    public func component(_ component: GKComponent?) -> Entity {
        guard
            let entity = self.entity,
            let component = component
            else { return self }
        
        entity.addComponent(component)
        return self
    }
    
    public func components(_ components: [GKComponent?]) -> Entity {
        guard
            let entity = self.entity,
            !components.isEmpty
        else { return self }
        
        entity.addComponents(components)
        return self
    }
}

public extension OKEntityContainer {

    @discardableResult func createEntity(withUUID id: UUID) -> OKEntity {
        
        if  let existingEntity = self.entities(withName: "\(id)")?.first {
            return existingEntity
        
        } else {
            
            let newEntity = OKEntity(name: "\(id)")
            self.addEntity(newEntity)
            return newEntity
        }
    }
    
}
