#if canImport(SwiftUI)
  import SwiftUI

  extension State {
    /// A dynamic property that holds a shared property in view state.
    ///
    /// This property is a more ergonomic shorthand for holding a ``Shared`` in SwiftUI's `@State`
    /// property wrapper, and can be initialized in all the same ways `@Shared` can be initialized.
    ///
    /// Instead of explicitly going through extra layers of `$state.wrappedValue` to get to the
    /// shared property wrapper, you can project directly to it:
    ///
    /// ```diff
    ///  struct BooksView: View {
    /// -  @State @Shared var books: [Book]
    /// +  @State.Shared var books: [Book]
    ///
    ///    init(
    /// -    _books = State(wrappedValue: Shared(.books(searchText)))
    /// +    _books = State.Shared(.books(searchText))
    ///    )
    ///
    ///    var body: some View {
    ///      List {
    ///        // ...
    ///      }
    ///      .refreshable {
    /// -      try? await $books.wrappedValue.load(.books(searchText))
    /// +      try? await $books.load(.books(searchText))
    ///      }
    ///      .searchable(text: $searchText)
    ///      .onChange(of: searchText) {
    /// -      $books.wrappedValue = Shared(.books(searchText))
    /// +      $books = Shared(.books(searchText))
    ///      }
    ///    }
    ///  }
    /// ```
    @propertyWrapper
    public struct Shared: DynamicProperty {
      @SwiftUI.State private var shared: SwiftSharing.Shared<Value>

      @_documentation(visibility: private)
      public var wrappedValue: Value {
        shared.wrappedValue
      }

      @_documentation(visibility: private)
      public var projectedValue: SwiftSharing.Shared<Value> {
        get { shared }
        nonmutating set { shared.projectedValue = newValue }
      }

      #if compiler(>=6)
        @_documentation(visibility: private)
        public init(value: sending Value) {
          shared = SwiftSharing.Shared(value: value)
        }
      #else
        @_documentation(visibility: private)
        public init(value: Value) {
          shared = SwiftSharing.Shared(value: value)
        }
      #endif

      @_documentation(visibility: private)
      public init(projectedValue: SwiftSharing.Shared<Value>) {
        shared = projectedValue
      }

      @_documentation(visibility: private)
      public init(
        wrappedValue: @autoclosure () -> Value,
        _ key: some SharedKey<Value>
      ) {
        shared = SwiftSharing.Shared(wrappedValue: wrappedValue(), key)
      }

      @_disfavoredOverload
      @_documentation(visibility: private)
      public init<Wrapped>(_ key: some SharedKey<Value>) where Value == Wrapped? {
        shared = SwiftSharing.Shared(key)
      }

      @_documentation(visibility: private)
      public init(_ key: (some SharedKey<Value>).Default) {
        shared = SwiftSharing.Shared(wrappedValue: key.initialValue, key)
      }

      @_disfavoredOverload
      @_documentation(visibility: private)
      public init(
        wrappedValue: @autoclosure () -> Value,
        _ key: (some SharedKey<Value>).Default
      ) {
        shared = SwiftSharing.Shared(wrappedValue: wrappedValue(), key)
      }

      @_documentation(visibility: private)
      public init(require key: some SharedKey<Value>) async throws {
        shared = try await SwiftSharing.Shared(require: key)
      }

      @_documentation(visibility: private)
      @available(*, unavailable, message: "Assign a default value")
      public init(_ key: some SharedKey<Value>) {
        fatalError()
      }
    }

    /// A dynamic property that holds a shared reader in view state.
    ///
    /// This property is a more ergonomic shorthand for holding a ``SharedReader`` in SwiftUI's
    /// `@State` property wrapper, and can be initialized in all the same ways `@SharedReader` can
    /// be initialized.
    ///
    /// Instead of explicitly going through extra layers of `$state.wrappedValue` to get to the
    /// shared property wrapper, you can project directly to it:
    ///
    /// ```diff
    ///  struct BooksView: View {
    /// -  @State @SharedReader var books: [Book]
    /// +  @State.SharedReader var books: [Book]
    ///
    ///    init(
    /// -    _books = State(wrappedValue: SharedReader(.books(searchText)))
    /// +    _books = State.SharedReader(.books(searchText))
    ///    )
    ///
    ///    var body: some View {
    ///      List {
    ///        // ...
    ///      }
    ///      .refreshable {
    /// -      try? await $books.wrappedValue.load(.books(searchText))
    /// +      try? await $books.load(.books(searchText))
    ///      }
    ///      .searchable(text: $searchText)
    ///      .onChange(of: searchText) {
    /// -      $books.wrappedValue = SharedReader(.books(searchText))
    /// +      $books = SharedReader(.books(searchText))
    ///      }
    ///    }
    ///  }
    /// ```
    @propertyWrapper
    public struct SharedReader: DynamicProperty {
      @SwiftUI.State private var shared: SwiftSharing.SharedReader<Value>

      @_documentation(visibility: private)
      public var wrappedValue: Value {
        shared.wrappedValue
      }

      @_documentation(visibility: private)
      public var projectedValue: SwiftSharing.SharedReader<Value> {
        get { shared }
        nonmutating set { shared.projectedValue = newValue }
      }

      #if compiler(>=6)
        @_documentation(visibility: private)
        public init(value: sending Value) {
          shared = SwiftSharing.SharedReader(value: value)
        }
      #else
        @_documentation(visibility: private)
        public init(value: Value) {
          shared = SwiftSharing.SharedReader(value: value)
        }
      #endif

      @_documentation(visibility: private)
      public init(projectedValue: SwiftSharing.SharedReader<Value>) {
        shared = projectedValue
      }

      @_documentation(visibility: private)
      public init(
        wrappedValue: @autoclosure () -> Value,
        _ key: some SharedReaderKey<Value>
      ) {
        shared = SwiftSharing.SharedReader(wrappedValue: wrappedValue(), key)
      }

      @_disfavoredOverload
      @_documentation(visibility: private)
      public init(
        wrappedValue: @autoclosure () -> Value,
        _ key: some SharedKey<Value>
      ) {
        shared = SwiftSharing.SharedReader(wrappedValue: wrappedValue(), key)
      }

      @_disfavoredOverload
      public init<Wrapped>(_ key: some SharedReaderKey<Value>) where Value == Wrapped? {
        shared = SwiftSharing.SharedReader(key)
      }

      @_disfavoredOverload
      @_documentation(visibility: private)
      public init<Wrapped>(_ key: some SharedKey<Value>) where Value == Wrapped? {
        shared = SwiftSharing.SharedReader(key)
      }

      @_documentation(visibility: private)
      public init(_ key: (some SharedReaderKey<Value>).Default) {
        shared = SwiftSharing.SharedReader(key)
      }

      @_disfavoredOverload
      @_documentation(visibility: private)
      public init(_ key: (some SharedKey<Value>).Default) {
        shared = SwiftSharing.SharedReader(key)
      }

      @_disfavoredOverload
      public init(
        wrappedValue: @autoclosure () -> Value,
        _ key: (some SharedReaderKey<Value>).Default
      ) {
        shared = SwiftSharing.SharedReader(wrappedValue: wrappedValue(), key)
      }

      @_disfavoredOverload
      @_documentation(visibility: private)
      public init(
        wrappedValue: @autoclosure () -> Value,
        _ key: (some SharedKey<Value>).Default
      ) {
        shared = SwiftSharing.SharedReader(wrappedValue: wrappedValue(), key)
      }

      @_documentation(visibility: private)
      public init(require key: some SharedReaderKey<Value>) async throws {
        shared = try await SwiftSharing.SharedReader(require: key)
      }

      @_disfavoredOverload
      @_documentation(visibility: private)
      public init(require key: some SharedKey<Value>) async throws {
        shared = try await SwiftSharing.SharedReader(require: key)
      }

      @_documentation(visibility: private)
      @available(*, unavailable, message: "Assign a default value")
      public init(_ key: some SharedReaderKey<Value>) {
        fatalError()
      }

      @_disfavoredOverload
      @_documentation(visibility: private)
      @available(*, unavailable, message: "Assign a default value")
      public init(_ key: some SharedKey<Value>) {
        fatalError()
      }
    }
  }

  #if compiler(>=6)
    extension State.Shared: Sendable where Value: Sendable {}

    extension State.SharedReader: Sendable where Value: Sendable {}
  #endif
#endif
