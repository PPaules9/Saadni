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
 //TODO: - To be changed to DesignSystemColors
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
   return .bold
  }
 }
}

// MARK: - Basic TextField Component
struct MovieTextField: View {
 var title: String
 var placeholder: String
 @Binding var text: String
 @FocusState private var isFocused: Bool
 
 private var state: InputState {
  if isFocused { return .active }
  if !text.isEmpty { return .filled }
  return .inactive
 }
 
 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   Text(title)
    .font(.custom("Mulish-Regular", size: 10))
    .fontWeight(.regular)
    .tracking(0.05)
    .frame(height: 18)
   //TODO: - To be changed to DesignSystemColors
    .foregroundStyle(.black)
   
   TextField(isFocused ? "" : placeholder , text: $text)
    .focused($isFocused)
    .font(.custom("Mulish-Regular", size: 12))
    .fontWeight(state.textWeight)
    .tracking(0.05)
    .frame(height: 18)
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
struct MoviePasswordField: View {
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
   Text(title)
    .font(.custom("Mulish-Regular", size: 10))
    .fontWeight(.regular)
    .tracking(0.05)
    .frame(height: 18)
   //TODO: - To be changed to DesignSystemColors
    .foregroundStyle(.black)
   
   HStack{
    Group {
     if !showPassword {
      SecureField(isFocused ? "" : placeholder, text: $text)
     } else {
      TextField(isFocused ? "" : placeholder, text: $text)
     }
    }
    .focused($isFocused)
    .font(.custom("Mulish-Regular", size: 12))
    .fontWeight(state.textWeight)
    .tracking(0.05)
    .frame(height: 20)
    .padding(16)
    .onSubmit {
     isFocused = false
    }
    
    Spacer()
    
    Button{
     showPassword.toggle()
    } label: {
     Image("eye-slash")
      .resizable()
      .frame(width: 18, height: 18)
      .padding(.trailing, 17)
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
struct MovieSearchField: View {
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
   Image("search-normal")
    .resizable()
    .frame(width: 18, height: 18)
   
   TextField(placeholder, text: $text)
    .focused($isFocused)
    .font(.custom("Mulish-Regular", size: 12))
    .fontWeight(state.textWeight)
    .tracking(0.05)
    .frame(height: 20)
    .padding(.leading, 8)
    .onSubmit {
     isFocused = false
    }
   
   Spacer()
   
   Button{
    onSettings?()
   } label: {
    Image("setting-5")
     .resizable()
     .frame(width: 18, height: 18)
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
struct MovieNumericalField: View {
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
    .font(.custom("Mulish-Regular", size: 20))
    .fontWeight(state.textWeight)
   
  }
  .frame(width: 51, height: 52)
  .padding(.horizontal, 20)
  .padding(.vertical, 12)
 }
}

// MARK: - TextEditor Field
struct MovieTextEditorField: View {
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
   Text(title)
    .font(.custom("Mulish-Regular", size: 10))
    .fontWeight(.regular)
    .tracking(0.05)
    .frame(height: 18)
    .foregroundStyle(.black) //To BE Changed To DesignSystemColors
   
   ZStack(alignment: .topLeading) {
    if text.isEmpty {
     Text(placeholder)
      .font(.custom("Mulish-Regular", size: 12))
      .fontWeight(.regular)
      .tracking(0.05)
      .foregroundStyle(Color.gray)
      .padding(.top, 8)
      .padding(.leading, 5)
    }
    
    TextEditor(text: $text)
     .focused($isFocused)
     .scrollContentBackground(.hidden)
     .font(.custom("Mulish-Regular", size: 12))
     .fontWeight(state.textWeight)
     .tracking(0.05)
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
  MovieTextField(
   title: "Basic TextField",
   placeholder: "Example",
   text: .constant("")
  )
  
  MovieTextField(
   title: "TextField with content",
   placeholder: "",
   text: .constant("Content")
  )
  
  MoviePasswordField(
   title: "Basic Password Field",
   placeholder: "Password",
   text: .constant("")
  )
  
  MoviePasswordField(
   title: "Dummy Password Input",
   placeholder: "Empty",
   text: .constant("dummyPassword")
  )
  
  MovieSearchField(placeholder: "Search....", text: .constant(""))
  MovieSearchField(placeholder: "Search....", text: .constant("Deadpool"))
  
  HStack(alignment: .center, spacing: 52){
   MovieNumericalField(number: .constant(0))
   MovieNumericalField(number: .constant(19))
   MovieNumericalField(number: .constant(4))
  }
  
  MovieTextEditorField(title: "Basic TextEditor", placeholder: "Type here..." , text: .constant(""))
  MovieTextEditorField(title: "TextEditor With Content", placeholder: "Type here...", text: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))
 }
}
