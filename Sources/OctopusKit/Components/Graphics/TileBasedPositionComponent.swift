//
//  TileBasedPositionComponent.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2020/04/28.
//  Copyright © 2020 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

import SpriteKit

/// Updates the entity's `SpriteKitComponent` node's position in every frame to align with the center of a tile in a `TileMapComponent`.
public final class TileBasedPositionComponent: OKComponent, OKUpdatableComponent {
    
    // TODO: Warp-around option.
    
    /// Specifies a `TileMapComponent` or its subclass which may be in another entity, e.g. a map entity. If `nil` then this component's entity's `TileMapComponent` (but not a subclass) is used, if any.
    ///
    /// A `RelayComponent` in this component's entity may also be used to connect to a `TileMapComponent` in another entity by leaving this property `nil`.
    public var tileMapComponentOverride: TileMapComponent? = nil
    
    /// The index of the `TileMapComponent` layer to use, i.e. the `SKTileMapNode` to query for the tile coordinates.
    public var tileMapLayer: Int = 0
    
    /// Applies an offset to the entity's node position from the center of a map tile.
    public var offsetFromTileCenter: CGPoint = .zero
    
    /// The coordinates of a tile in the `TileMapComponent`'s `SKTileMapNode`. The entity's `SpriteKitComponent` node's position is set to this tile's center in every frame, adding the `offsetFromTileCenter`.
    public var coordinates: CGPoint = .zero {
        didSet {
            if  coordinates != oldValue {
                shouldAlignNodePositionOnUpdate = true
            }
        }
    }
    
    /// If `true`, `alignNodePositionToTile()` is called when this component is updated, after which this flag is reset. Automatically set when `coordinates` are modified.
    ///
    /// If the entity's `SpriteKitComponent` node's position is modified by other components, then this flag must be set to `true` or `alignNodePositionToTile()` must be called manually to re-align the node with its map tile.
    public var shouldAlignNodePositionOnUpdate: Bool = false
    
    /// - Parameters:
    ///   - tileMapComponentOverride: Specify `nil` to use this component's entity's `TileMapComponent`, or specify a `TileMapComponent` (or its subclass) in another entity, e.g. a map entity.
    ///
    ///     A `RelayComponent` in this component's entity may also be used to connect to a `TileMapComponent` in another entity by leaving this property `nil`.
    ///
    ///   - coordinates: The coordinates of the initial tile in the `TileMapComponent`'s `SKTileMapNode`. The entity's `SpriteKitComponent` node's position is set to this tile's center in every frame.
    ///   - tileMapLayer: The index of the `TileMapComponent` layer to use, i.e. the `SKTileMapNode` to query for the tile coordinates.
    ///   - offsetFromTileCenter: The additional offset to apply to the entity's `SpriteKitComponent` node.
    public init(tileMapComponentOverride:   TileMapComponent? = nil,
                tileMapLayer:               Int = 0,
                coordinates:                CGPoint = .zero,
                offsetFromTileCenter:       CGPoint = .zero)
    {
        self.tileMapComponentOverride   = tileMapComponentOverride
        self.tileMapLayer               = tileMapLayer
        self.coordinates                = coordinates
        self.offsetFromTileCenter       = offsetFromTileCenter
        super.init()
        self.shouldAlignNodePositionOnUpdate = true // To align with the initial coordinates.
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @inlinable
    public override func didAddToEntity(withNode node: SKNode) {
        alignNodePositionToTile()
    }
    
    @inlinable
    public override func update(deltaTime seconds: TimeInterval) {
        if  shouldAlignNodePositionOnUpdate { // PERFORMANCE: No unnecessary updates.
            alignNodePositionToTile()
            shouldAlignNodePositionOnUpdate = false
        }
    }
    
    /// Sets the position of this entity's `SpriteKitComponent` node to the center of the tile in the `tileMapComponent`'s `SKTileMapNode`.
    @inlinable
    public func alignNodePositionToTile() {
        guard
            let node = self.entityNode,
            let tileMapComponent = self.tileMapComponentOverride ?? coComponent(TileMapComponent.self)
            else { return }
        
        guard tileMapComponent.layers.isValidIndex(self.tileMapLayer) else {
            OctopusKit.logForWarnings("\(tileMapLayer) out of bounds for the \(tileMapComponent.layers.count) layers in \(tileMapComponent)")
            return
        }
        
        let tileMapNode = tileMapComponent.layers[tileMapLayer]
        let column      = Int(self.coordinates.x)
        let row         = Int(self.coordinates.y)
        
        guard // SKTileMapNode is 0-indexed
            column  >= 0,
            column  < tileMapNode.numberOfColumns,
            row     >= 0,
            row     < tileMapNode.numberOfRows
        else {
            // CHECK: PERFORMANCE: Is this check necessary? or would it be handled by the SKTileMapNode?
            // TODO: Warp-around option.
            OctopusKit.logForWarnings("\(self.coordinates) out of bounds for the \(tileMapNode.numberOfColumns) x \(tileMapNode.numberOfRows) tiles in \(tileMapComponent)")
            return
        }
        
        let tiledPosition = tileMapNode.centerOfTile(atColumn: column, row: row) + offsetFromTileCenter
        
        if  let nodeParent = node.parent { // CHECK & VERIFY & TEST: Is this the expected behavior?
            node.position = tileMapNode.convert(tiledPosition, to: nodeParent)
        } else if let tileMapParent = tileMapNode.parent {
            node.position = tileMapNode.convert(tiledPosition, to: tileMapParent)
        } else {
            node.position = tiledPosition
        }
    }
    
    /// Clamps the `coordinates` to within `0` and the number of columns and rows in the `TileMapComponent`'s `SKTileMapNode` `layer`.
    @inlinable
    public func clampCoordinates() {
        guard let tileMapComponent = self.tileMapComponentOverride ?? coComponent(TileMapComponent.self) else {
            OctopusKit.logForWarnings("\(self) missing TileMapComponent — Cannot clamp, indexes may go out of bounds.")
            return
        }
        
        guard tileMapComponent.layers.isValidIndex(self.tileMapLayer) else {
            OctopusKit.logForWarnings("\(tileMapLayer) out of bounds for the \(tileMapComponent.layers.count) layers in \(tileMapComponent)")
            return
        }
        
        let tileMapNode = tileMapComponent.layers[tileMapLayer]
        
        // CHECK: PERFORMANCE: Impact from range allocations?
        
        let column      = Int(coordinates.x).clamped(to: 0..<tileMapNode.numberOfColumns)
        let row         = Int(coordinates.y).clamped(to: 0..<tileMapNode.numberOfRows)
        
        coordinates     = CGPoint(x: column, y: row)
    }
}
