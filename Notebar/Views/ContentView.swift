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
        NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Applications/Notes.app"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                let result = scriptObject.executeAndReturnError(&error)
                print("Result: \(result)")
                if let err = error {
                    print("AppleScript error: \(err)")
                }
            }
        }
    }

    func clearText() {
        textManager.text = ""
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HeaderView(themeManager: themeManager, onSaveToNotes: saveToAppleNotes, onClear: clearText)
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $textManager.text)
                        .firstResponder(id: FirstResponders.textEditor, firstResponder: $firstResponder)
                        .font(Font.system(.body, design: .default))
                        .padding(.leading, -5)
                        .foregroundColor(themeManager.textColor)
                    if (textManager.text == "") {
                        Text(placeholder)
                            .font(Font.system(.body, design: .default))
                            .foregroundColor(themeManager.textColor)
                            .opacity(0.4)
                    }
                }.accentColor(.yellow)
                .padding(12)
                .background(themeManager.bgColor)
            }
            ZStack {
                Color(.shadowColor)
                    .opacity(themeManager.isThemeEditor ? 0.3 : 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        themeManager.hideThemeEditor()
                        firstResponder = FirstResponders.textEditor
                    }
                    .animation(.easeOut(duration: 0.15), value: themeManager.isThemeEditor)
                ThemeEditorView(themeManager: themeManager)
                    .offset(y: themeManager.isThemeEditor ? 0 : 60)
                    .opacity(themeManager.isThemeEditor ? 1 : 0)
                    .animation(.easeOut(duration: 0.15), value: themeManager.isThemeEditor)
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
