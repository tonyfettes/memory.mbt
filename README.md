# tonyfettes/memory

Consistent memory representation across all current MoonBit backend.

- JavaScript backend: WebAssembly.Memory with custom memory allocator
- WasmGC: Linear memory with memory allocator
- Wasm: Linear memory (shared with heap)
- Native: Linear memory (shared with heap)
