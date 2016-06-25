

To-Do
-----
- Decoder generator
- Type expression parser tuple support.

Done
----
- Encoder generator
- Schema analyzer



Encoding / Decoding
-------------------

Encoders encode strongly typed value into `JSONObject` which is a common root type of all JSON values.
Encoder functions are chosen by type matching of input values, so type mismatch will become an error
at compile time.
Decoders decode `JSONObject` value into several specific type values. All decoder always performs proper
type checks before returning some value. Any unexpected type or missing value will become an error and 
cancel whole decoding process.

`JSONObject` type must contain JSON type information as a part of it, and the type informations must be
queryable externally for proper decoding.





"No"s
-----
- Reflection based metadata extraction.
    You cannot get metadata only with class.
    You need an instance to get the metadata. 
- Use of Apple Swift compiler source.
    I don't want to build entire LLVM, Clang and `swiftc`.
