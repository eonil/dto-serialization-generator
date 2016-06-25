DTOSerializationGenerator
=========================
2016 Hoon H.




Design Choices
--------------
This tool read Swift source files and generates pair of serializer/deserializer.

- Explicit Schema based. Generator input is a schema.
- Strictly DTO only. Does not target onmipotent serializer.

Which derives these rules.

- Only tuples, `struct`s and `enum`s only.
- All of tuples, `struct`s and `enum`s are in same namespace. Cannot be duplicated.
- All of tuples, `struct`s and `enum`s must be in top namespace. Cannot be nested.
- Enum parameter also must be struct and enums only.
- All `struct` fields must be internal or public. `private` and `fileprivate` become errors.
- All `struct` fields must have equal access level with the `stuct` itself.
- Default initializer must be provided. (an initializer which accepts all fields in order as they defined)
- Any Computed Property definition becomes an error. Define them in a separate file.
- Any method definition becomes an error. Define them in a separate file.
- Any interface conformance becomes an error. Define them in a separate file.
- Leaf values must be fixed sized primitive type. No platform dependent size are supported.
- Uses system default JSON implementation unless there's a huge win with another library.
    For Cocoa, this is `NSJSONSerialization` with `NSDictionary`, `NSArray`, `NSString` and `NSNumber`.
    These OBJC classes will be used until Swift implementation arrives.

Supported primitive types are listed here.

- `Int8`, `Int16`, `Int32`, `Int64`.
- `UInt8`, `UInt16`, `UInt32`, `UInt64`.
- `Float32`, `Float64`.
- `String` (support only UTF-8)

* Note that numbers defined in JSON standard will be supported, and anything else won't be supported.

Only these containers are supported.

- `Optional<Wrapped>`
- `Array<Element>`

No dictionary or set support. They are useless in DTO domain.
You can represent a dictionary with array of tuples.

These types can be supported in future if Swift 3 support them.

- `Data`, `Date`.



Serialization Rule
------------------
Basically, follows typical JSON conventions.

For a given struct;

    struct Foo {
        var bar: Int32
        var baz: String
    }

    let foo = Foo(bar: 42, baz: "Here be dragons.")

This JSON will be created.

    {
        "bar": 42,
        "baz": "Here be dragons."
    }

Type name will be stripped away, but field name will remain.

Tuple elements are treated like an array of values. JSON is
a schema-less container, so we can put different type values
in an array.

Enum parameters are treated as a tuple.

























