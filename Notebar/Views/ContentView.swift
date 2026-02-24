//
//  ContentView.swift
//  Notebar
//
//  Created by Jay Stakelon on 1/1/21.
//
import SwiftUI
import MbSwiftUIFirstResponder

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}

enum FirstResponders: Int {
    case textEditor
}

struct ContentView: View {
    private var placeholder: String = "hello there"
    @State var firstResponder: FirstResponders? = FirstResponders.textEditor
    @ObservedObject var themeManager = ThemeManager()
    @ObservedObject var textManager = TextManager()
    
    func saveToAppleNotes() {
        let escaped = textManager.text
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        
        let script = """
        tell application "Notes"
            make new note with properties {body:"\(escaped)"}
        end tell
        """
        
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HeaderView(themeManager: themeManager)
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $textManager.text)
                        .firstResponder(id: FirstResponders.textEditor, firstResponder: $firstResponder)
                        .font(Font.system(.body, design: .monospaced))
                        .padding(.leading, -5)
                        .foregroundColor(themeManager.textColor)
                    if (textManager.text == "") {
                        Text(placeholder)
                            .font(Font.system(.body, design: .monospaced))
                            .foregroundColor(themeManager.textColor)
                            .opacity(0.4)
                    }
                }.accentColor(.yellow)
                .padding(12)
                .background(themeManager.bgColor)
                
                // Save to Notes button
                HStack {
                    Spacer()
                    Button(action: saveToAppleNotes) {
                        Label("Save to Notes", systemImage: "square.and.arrow.up")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(themeManager.textColor)
                    .opacity(textManager.text.isEmpty ? 0.3 : 0.8)
                    .disabled(textManager.text.isEmpty)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                }
                .background(themeManager.bgColor)
            }
            ZStack {
                Color(.shadowColor)
                    .opacity(themeManager.isThemeEditor ? 0.5 : 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        themeManager.hideThemeEditor()
                        firstResponder = FirstResponders.textEditor
                    }
                    .animation(.easeOut(duration: 0.25))
                ThemeEditorView(themeManager: themeManager)
                    .frame(width: 240, height: 240)
                    .offset(y: themeManager.isThemeEditor ? 0 : 400)
                    .animation(.easeOut(duration: 0.25))
            }
        }
        .background(Color(.windowBackgroundColor))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
