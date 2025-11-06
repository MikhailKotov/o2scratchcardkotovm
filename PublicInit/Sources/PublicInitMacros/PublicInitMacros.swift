import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftSyntaxMacros

enum PublicInitDiagnostic: String, DiagnosticMessage {
  case unsafeStoredProperties = "unsafe_stored_properties"

  var diagnosticID: MessageID { .init(domain: "PublicInit", id: rawValue) }
  var severity: DiagnosticSeverity { .warning }
  var message: String {
    "Cannot synthesize `public init()` because there are stored properties without default values."
  }
}

struct AddPublicInitMacro: MemberMacro {
  static func expansion(
    of node: AttributeSyntax,
    providingMembersOf decl: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {

    // 1) работает только для struct/class
    guard decl.is(StructDeclSyntax.self) || decl.is(ClassDeclSyntax.self) else {
      return []
    }

    // 2) если уже есть init — выходим
    let hasInit = decl.memberBlock.members.contains { member in
      member.decl.is(InitializerDeclSyntax.self)
    }
    if hasInit { return [] }

    // 3) проверяем хранимые свойства
    var unsafe = false

    for member in decl.memberBlock.members {
      guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }

      // пропускаем let/var с computed body
      let isStored = varDecl.bindings.allSatisfy { binding in
        binding.accessorBlock == nil
      }
      guard isStored else { continue }

      for binding in varDecl.bindings {
        // Имеет ли инициализатор?
        let hasInitializer = (binding.initializer != nil)

        // Является ли Optional (T?) — у классов допустимо без значения (nil по умолчанию)
        let isOptional: Bool = {
          guard let type = binding.typeAnnotation?.type.trimmedDescription else { return false }
          return type.hasSuffix("?")
        }()

        if !(hasInitializer || isOptional) {
          unsafe = true
          break
        }
      }
      if unsafe { break }
    }

    if unsafe {
      context.diagnose(Diagnostic(node: Syntax(decl), message: PublicInitDiagnostic.unsafeStoredProperties))
      return []
    }

    // 4) генерируем пустой public init
    let initDecl: DeclSyntax =
      """
      public init() {}
      """

    return [initDecl]
  }
}
