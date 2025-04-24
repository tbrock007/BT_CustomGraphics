//
//  ViewController.swift
//  BT_CustomGraphics
//
//  Created by Brock Terry on 12/2/24.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    let mapView = MapView() // Custom MapView instance
    var playerPosition = (row: 5, col: 5) // Initial position of the player on the map
    let worldMap: [[String]] = [ // 2D array representing the world map
        ["M", "M", "M", ".", ".", "~", "~"],
        ["M", "M", "f", "f", ".", "~", "~"],
        ["M", "f", "f", ".", ".", "~", "~"],
        ["f", "f", ".", ".", ".", ".", "~"],
        [".", ".", ".", "~", "~", "~", "~"],
        [".", ".", ".", "~", "~", "~", "~"],
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Calculate centered frame for the map
        let tileSize = mapView.tileSize
        let mapWidth = tileSize.width * CGFloat(worldMap[0].count)
        let mapHeight = tileSize.height * CGFloat(worldMap.count)

        // Center the map view based on the map size
        mapView.frame = CGRect(
            x: (view.bounds.width - mapWidth) / 2,
            y: (view.bounds.height - mapHeight) / 2,
            width: mapWidth,
            height: mapHeight
        )
        mapView.worldMap = worldMap
        mapView.playerPosition = playerPosition
        mapView.backgroundColor = UIColor.black // Space-like background
        view.addSubview(mapView)

        // Enable user interaction for touch events
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Touch Handling
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // Get tap location
        let location = gesture.location(in: mapView)
        let tileSize = mapView.tileSize
        let tappedRow = Int(location.y / tileSize.height)
        let tappedCol = Int(location.x / tileSize.width)
        
        // Calculate direction based on tap location
        let direction = getDirection(from: (tappedRow, tappedCol))
        movePlayer(direction: direction)
    }

    func getDirection(from tapped: (row: Int, col: Int)) -> (rowOffset: Int, colOffset: Int) {
        if tapped.row < playerPosition.row { return (-1, 0) } // Move up
        if tapped.row > playerPosition.row { return (1, 0) }  // Move down
        if tapped.col < playerPosition.col { return (0, -1) } // Move left
        if tapped.col > playerPosition.col { return (0, 1) }  // Move right
        return (0, 0) // No movement
    }

    func movePlayer(direction: (rowOffset: Int, colOffset: Int)) {
        let newRow = playerPosition.row + direction.rowOffset
        let newCol = playerPosition.col + direction.colOffset
        
        // Check map boundaries
        guard newRow >= 0, newRow < worldMap.count,
              newCol >= 0, newCol < worldMap[0].count else {
            print("Player cannot move off the map!")
            return
        }
        
        // Update player position
        playerPosition = (newRow, newCol)
        mapView.playerPosition = playerPosition
        mapView.setNeedsDisplay() // Redraw the mapView with updated position
    }
}
