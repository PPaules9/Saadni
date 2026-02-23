//
//  DesignSystemTextFields.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//

import SwiftUI

// MARK: - InputState
enum InputState {
 case inactive
 case active
 case filled
}
extension InputState {
 var borderColor: Color {
  switch self {
  case .inactive:
   return .gray.opacity(0.3)
  case .active:
   return .accent
  case .filled:
   return .gray.opacity(0.3)
  }
 }
}

extension InputState{
 var textWeight: Font.Weight{
  switch self {
  case .inactive:
   return .regular
  case .active:
   return .bold
  case .filled:
   return .regular
  }
 }
}

// MARK: - Basic TextField Component
struct BrandTextField: View {
 let hasTitle: Bool
 let title: String
 let placeholder: String
 @Binding var text: String
 @FocusState private var isFocused: Bool
 
 private var state: InputState {
  if isFocused { return .active }
  if !text.isEmpty { return .filled }
  return .inactive
 }
 
 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   if hasTitle{
    Text(title)
     .font(Font.caption2)
     .fontDesign(.rounded)
     .foregroundStyle(Colors.swiftUIColor(.textMain))
   }
   
   TextField(isFocused ? "" : placeholder , text: $text)
    .focused($isFocused)
    .font(Font.caption)
    .fontDesign(.rounded)
    .fontWeight(state.textWeight)
    .padding(16)
    .overlay(
     RoundedRectangle(cornerRadius: 100)
      .stroke(state.borderColor, lineWidth: 1)
    )
    .onSubmit {
     isFocused = false
    }
  }
  .padding(16)
 }
}


// MARK: - Password Input Component
struct BrandPasswordField: View {
 let hasTitle: Bool
 let title: String
 let placeholder: String
 @Binding var text: String
 @FocusState private var isFocused: Bool
 @State private var showPassword: Bool = false
 
 private var state: InputState {
  if isFocused { return .active }
  if !text.isEmpty { return .filled }
  return .inactive
 }
 
 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   if hasTitle{
    Text(title)
     .font(.caption2)
     .fontDesign(.rounded)
     .foregroundStyle(Colors.swiftUIColor(.textMain))
   }
   
   HStack{
    Group {
     if !showPassword {
      SecureField(isFocused ? "" : placeholder, text: $text)
     } else {
      TextField(isFocused ? "" : placeholder, text: $text)
     }
    }
    .focused($isFocused)
    .font(Font.caption)
    .fontDesign(.rounded)
    .fontWeight(state.textWeight)
    .frame(height: 18)
    .padding(16)
    .onSubmit {
     isFocused = false
    }
    
    Spacer()
    
    Button{
     showPassword.toggle()
    } label: {
     if showPassword{
      Image(systemName: "eye.slash")
       .resizable()
       .frame(width: 18, height: 12)
       .padding(.trailing, 17)
       .foregroundStyle(Colors.swiftUIColor(.textMain))
     } else {
      Image(systemName: "eye")
       .resizable()
       .frame(width: 18, height: 12)
       .padding(.trailing, 17)
       .foregroundStyle(Colors.swiftUIColor(.textMain))
     }
    }
   }
   .overlay(
    RoundedRectangle(cornerRadius: 100)
     .stroke(state.borderColor, lineWidth: 1)
   )
  }
  .padding(16)
 }
}

// MARK: - Search Input Field
struct BrandSearchField: View {
 let placeholder: String
 @Binding var text: String
 @FocusState private var isFocused: Bool
 var onSettings: (() -> Void)? = nil
 
 private var state: InputState {
  if isFocused { return .active }
  if !text.isEmpty { return .filled }
  return .inactive
 }
 
 var body: some View {
  HStack{
   Image(systemName: "magnifyingglass")
    .resizable()
    .frame(width: 18, height: 18)
    .foregroundStyle(Colors.swiftUIColor(.textMain))

   TextField(placeholder, text: $text)
    .focused($isFocused)
    .font(.caption2)
    .fontDesign(.rounded)
    .fontWeight(state.textWeight)
    .frame(height: 20)
    .padding(.leading, 8)
    .onSubmit {
     isFocused = false
    }
   
   Spacer()
   
   Button{
    onSettings?()
   } label: {
    Image(systemName: "slider.horizontal.3")
     .resizable()
     .frame(width: 18, height: 18)
     .foregroundStyle(Colors.swiftUIColor(.textMain))

   }
  }
  .padding(16)
  .overlay(
   RoundedRectangle(cornerRadius: 100)
    .stroke(state.borderColor, lineWidth: 1)
  )
  .padding(.top, 16)
  .padding(.horizontal, 16)
 }
}

// MARK: - Numerical Input Field
struct BrandNumericalField: View {
 let placeholder: String = "-"
 @Binding var number: Int
 @FocusState private var isFocused: Bool
 
 private var state: InputState {
  if isFocused { return .active }
  if number != 0 { return .filled }
  return .inactive
 }
 
 private var numberFormatter: NumberFormatter {
  let formatter = NumberFormatter()
  formatter.numberStyle = .none
  formatter.zeroSymbol = ""
  return formatter
 }
 
 var body: some View {
  ZStack {
   Circle()
    .fill(.clear)
    .overlay(
     Circle()
      .stroke(state.borderColor, lineWidth: 1)
    )
   
   TextField(placeholder, value: $number, formatter: numberFormatter)
    .keyboardType(.numberPad)
    .focused($isFocused)
    .multilineTextAlignment(.center)
    .fontDesign(.rounded)
    .font(.system(size: 20))
    .fontWeight(state.textWeight)
   
  }
  .frame(width: 51, height: 52)
  .padding(.horizontal, 20)
  .padding(.vertical, 12)
 }
}

// MARK: - TextEditor Field
struct BrandTextEditor: View {
 let hasTitle: Bool
 let title: String
 let placeholder: String
 @Binding var text: String
 @FocusState private var isFocused: Bool
 
 private var state: InputState {
  if isFocused { return .active }
  if !text.isEmpty { return .filled }
  return .inactive
 }
 
 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   if hasTitle {
    Text(title)
     .font(.caption2)
     .fontDesign(.rounded)
     .fontWeight(.regular)
     .foregroundStyle(Colors.swiftUIColor(.textMain))
   }
   
   ZStack(alignment: .topLeading) {
    if text.isEmpty {
     Text(placeholder)
      .font(.caption2)
      .fontDesign(.rounded)
      .fontWeight(.regular)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      .padding(.top, 8)
      .padding(.leading, 5)
    }
    
    TextEditor(text: $text)
     .focused($isFocused)
     .scrollContentBackground(.hidden)
     .font(.caption2)
     .fontDesign(.rounded)
     .fontWeight(state.textWeight)
     .frame(minHeight: 132, alignment: .top)
   }
   .padding(16)
   .overlay(
    RoundedRectangle(cornerRadius: 24)
     .stroke(state.borderColor, lineWidth: 1)
   )
  }
  .padding(16)
 }
}


// MARK: - Preview All Inbut Components
#Preview {
 ScrollView{
  BrandTextField( hasTitle: false, title: "Basic TextField", placeholder: "Example", text: .constant("") )
  BrandTextField( hasTitle: true, title: "TextField with content", placeholder: "", text: .constant("Content") )
  
  BrandPasswordField(hasTitle: true, title: "Basic Password Field", placeholder: "Password", text: .constant("") )
  BrandPasswordField(hasTitle: false, title: "Dummy Password Input", placeholder: "Empty", text: .constant("dummyPassword") )
  
  BrandSearchField(placeholder: "Search....", text: .constant(""))
  BrandSearchField(placeholder: "Search....", text: .constant("Deadpool"))
  
  HStack(alignment: .center, spacing: 52){
   BrandNumericalField(number: .constant(0))
   BrandNumericalField(number: .constant(19))
   BrandNumericalField(number: .constant(4))
  }
  
  BrandTextEditor(hasTitle: true, title: "Basic TextEditor", placeholder: "Type here..." , text: .constant(""))
  BrandTextEditor(hasTitle: true, title: "TextEditor With Content", placeholder: "Type here...", text: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))
 }
}
