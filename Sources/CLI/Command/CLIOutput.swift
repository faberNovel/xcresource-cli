//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 30/03/2021.
//

import Foundation
import XCTemplate

struct CLIOutput: CommandOutput {

    func print(_ items: Any...) {
        Swift.print(items)
    }
}
