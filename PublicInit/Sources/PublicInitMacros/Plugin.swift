import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PublicInitPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    AddPublicInitMacro.self
  ]
}
