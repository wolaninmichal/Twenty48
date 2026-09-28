//
//  File.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

public struct Grid<Element> {

    /// The number of cells along each edge.
    public let size: Int

    /// The elements, row by row.
    private var storage: [Element]

    /// Creates a grid with every cell holding the same element.
    ///
    /// - Parameters:
    ///   - size: The number of cells along each edge. Must be greater than zero.
    ///   - element: The element every cell starts with.
    public init(size: Int, repeating element: Element) {
        precondition(size > 0, "A grid must have at least one cell")
        self.size = size
        self.storage = Array(repeating: element, count: size * size)
    }

    /// The element at a position, which must lie on the grid.
    public subscript(position: Position) -> Element {
        get { storage[index(of: position)] }
        set { storage[index(of: position)] = newValue }
    }

    /// Every position of the grid, row by row.
    public var positions: [Position] {
        (0..<size).flatMap { row in
            (0..<size).map { column in Position(row: row, column: column) }
        }
    }

    /// Returns whether a position lies on the grid.
    public func contains(_ position: Position) -> Bool {
        (0..<size).contains(position.row) && (0..<size).contains(position.column)
    }

    private func index(of position: Position) -> Int {
        precondition(contains(position), "\(position) lies outside a grid of size \(size)")
        return position.row * size + position.column
    }
}

extension Grid: Equatable where Element: Equatable {}
extension Grid: Hashable where Element: Hashable {}
extension Grid: Sendable where Element: Sendable {}
