import SwiftUI

struct CodeBlockView: View {
  @Environment(\.theme.codeBlock) private var codeBlock
  @Environment(\.codeSyntaxHighlighter) private var codeSyntaxHighlighter

  private let fenceInfo: String?
  private let content: String
  @State private var onHover = false

  init(fenceInfo: String?, content: String) {
    self.fenceInfo = fenceInfo
    self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
  }

  var body: some View {
    self.codeBlock.makeBody(
      configuration: .init(
        language: self.fenceInfo,
        content: self.content,
        label: .init(self.label)
      )
    )
    .onHover { over in
        onHover = over
    }
  }

  private var label: some View {
    self.codeSyntaxHighlighter.highlightCode(self.content, language: self.fenceInfo)
      .textStyleFont()
      .textStyleForegroundColor()
      .overlay(
         Button {
            #if os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(content, forType: .string)
            #else
            UIPasteboard.general.string = content
            #endif
         } label: {
           Image(systemName: "doc.on.doc")
             .font(.caption)
         }
         .foregroundColor(Color.accentColor)
         .offset(x: -14, y: 0)
         .opacity(onHover == true ? 1 : 0)
         ,alignment: .topTrailing
       )
  }
}
