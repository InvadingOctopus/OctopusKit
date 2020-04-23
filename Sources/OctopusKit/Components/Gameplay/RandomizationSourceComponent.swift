//
//  RandomizationSourceComponent.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2018/03/09.
//  Copyright © 2020 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

import GameplayKit

/// Encapsulates a `GKRandom` object.
open class RandomizationSourceComponent: OKComponent {
    
    open var randomizationSource: GKRandom
    
    public init(randomizationSource: GKRandom) {
        self.randomizationSource = randomizationSource
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

