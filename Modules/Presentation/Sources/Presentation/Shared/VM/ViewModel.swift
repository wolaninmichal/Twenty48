//
//  File.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Foundation

public protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
