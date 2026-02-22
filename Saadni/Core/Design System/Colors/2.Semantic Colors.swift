//
//  ColorTheme.swift
//  Saadni
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
 case textTertiary
 
 // Buttons
 case buttonTextWhite
 case buttonTextBlack
 case buttonColors
 
 // Background colors
 case backgroundLight
 
 // Border colors
 case borderPrimary
 case borderError
 case borderSuccess
 
 // Status colors
 case textSuccess
 case textError
 case textWarning
 
 // TextFields
 case textFieldText
 case placeholderColor
 case textFieldHeadline
 case textFieldBorderInActive
 case textFieldBorderError
 case textFieldBorderSelected
 
 // for Custom Components
 case lineDark
 case lineLight
 case black
}
