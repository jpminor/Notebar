//
//  ThemeEditorView.swift
//  Notebar
//
//  Created by Jay Stakelon on 1/30/21.
//
import SwiftUI
struct ThemeEditorView: View {
    @ObservedObject var themeManager: ThemeManager
    var body: some View {
        HStack(spacing: 15) {
            Button(action: { themeManager.setTheme(.system) }) {
                Image(systemName: "laptopcomputer")
                    .font(.title2)
                    .foregroundColor((themeManager.currentTheme == .system) ? .accentColor : .primary)
                    .frame(width: 40, height: 40)
                    .background((themeManager.currentTheme == .system) ? Color.white : Color(.controlColor))
                    .clipShape(Circle())
                    .help("System default")
            }.buttonStyle(PlainButtonStyle())

            Button(action: { themeManager.setTheme(.light) }) {
                Image(systemName: "sun.max")
                    .font(.title2)
                    .foregroundColor((themeManager.currentTheme == .light) ? .accentColor : .primary)
                    .frame(width: 40, height: 40)
                    .background((themeManager.currentTheme == .light) ? Color.white : Color(.controlColor))
                    .clipShape(Circle())
                    .help("Light mode")
            }.buttonStyle(PlainButtonStyle())

            Button(action: { themeManager.setTheme(.dark) }) {
                Image(systemName: "moon")
                    .font(.title2)
                    .foregroundColor((themeManager.currentTheme == .dark) ? .accentColor : .primary)
                    .frame(width: 40, height: 40)
                    .background((themeManager.currentTheme == .dark) ? Color.white : Color(.controlColor))
                    .clipShape(Circle())
                    .help("Dark mode")
            }.buttonStyle(PlainButtonStyle())
        }
        .padding(20)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(8)
    }
}
struct ThemeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditorView(themeManager: ThemeManager())
    }
}
