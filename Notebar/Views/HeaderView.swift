//
//  HeaderView.swift
//  Notebar
//
//  Created by Jay Stakelon on 1/30/21.
//
import SwiftUI
struct HeaderView: View {
    @ObservedObject var themeManager: ThemeManager
    var onSaveToNotes: () -> Void
    var onClear: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Notebar").font(Font.system(size: 12, weight: .bold, design: .rounded))
                Spacer()
                Button(action: onClear) {
                    Label("Clear", systemImage: "trash")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .focusable(false)
                .keyboardShortcut("k", modifiers: .command)
                Button(action: onSaveToNotes) {
                    Label("Save to Notes", systemImage: "square.and.arrow.up")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .focusable(false)
                .keyboardShortcut("s", modifiers: .command)
                DropdownMenuView(themeManager: themeManager, onSaveToNotes: onSaveToNotes, onClear: onClear).frame(width: 24, height: 24)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            Divider().background(Color.gray.opacity(0.1))
        }.background(Color(.windowBackgroundColor))
    }
}
