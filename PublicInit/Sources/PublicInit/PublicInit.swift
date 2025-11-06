@_exported import PublicInitMacros

/// Аннотация для авто-вставки `public init() {}`
/// Работает для `struct` и `class`.
@attached(member)
public macro PublicInit() = #externalMacro(
  module: "PublicInitMacros",
  type: "AddPublicInitMacro"
)
