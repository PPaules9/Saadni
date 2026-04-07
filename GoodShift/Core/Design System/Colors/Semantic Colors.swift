//
//  SemanticColor.swift
//  GoodShift
//
//  Created by Pavly Paules on 22/02/2026.
//
import Foundation

/// Semantic color rules used throughout the app.
/// These are the ONLY colors that UI/feature code should reference.


public enum SemanticColor {
 // Text colors
 case textPrimary
 case textSecondary
 case textMain

 // Background colors
 case appBackground
 case cardBackground
 case buttonBackground
 case surfaceWhite

 // Border colors
 case borderPrimary
 case borderError
 case borderWarning

 // Brand colors
 case primary
 case primaryDark

 // Interaction colors
 case selectionHighlight   // tinted bg for selected option rows
 case successGreen         // accept/positive indicators (tinder swipe, checkmarks)

}
