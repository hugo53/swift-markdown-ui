import SwiftUI

struct CodeBlockView: View {
  @Environment(\.theme.codeBlock) private var codeBlock
  @Environment(\.codeSyntaxHighlighter) private var codeSyntaxHighlighter

  private let fenceInfo: String?
  private let content: String
  @State private var onHover = false
  @State var isCopied = false

  init(fenceInfo: String?, content: String) {
    self.fenceInfo = fenceInfo
    self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
  }

  var body: some View {
      ZStack(alignment: .top) {
        self.codeBlock.makeBody(
            configuration: .init(
              language: self.fenceInfo,
              content: self.content,
              label: .init(self.label)
            )
        )
        
        HStack {
            Spacer()
            Button {
                withAnimation(.linear(duration: 0.1)) {
                    isCopied = true
                }
                #if os(macOS)
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(content, forType: .string)
                #else
                UIPasteboard.general.string = content
                #endif
                
                Task {
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    withAnimation(.linear(duration: 0.1)) {
                        isCopied = false
                    }
                }
            } label: {
                Image(systemName: isCopied ? "checkmark" : "doc.on.clipboard")
                    .font(.caption)
                    .frame(width: 14, height: 14)
            }
            .foregroundColor(Color.accentColor)
        }
        .padding([.top, .trailing], 8)
        .opacity(onHover == true ? 1 : 0)
    }
    .onHover { over in
        onHover = over
    }
  }

  private var label: some View {
    self.codeSyntaxHighlighter.highlightCode(self.content, language: self.fenceInfo)
      .textStyleFont()
      .textStyleForegroundColor()
  }
}
