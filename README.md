# tonyfettes/memory

Consistent memory representation across all current MoonBit backends.

- JavaScript backend: WebAssembly.Memory with custom memory allocator
- WasmGC: Linear memory with custom memory allocator
- Wasm: Linear memory (shared with heap)
- Native: Linear memory (shared with heap)

For all the backend, especially the WASM (linear) and Native backend, the user should ensure all the `Memory[T]` is allocated/ converted from array by this library, not by any other third party allocator.

This also means you shall never use `Memory[T]` to represent slice/view of a piece of memory.

For example, for the following C function:

```c
struct a *make_a();
```

DO NOT creat a binding like this:

```moonbit
extern "c" fn make_a() -> Memory[A]
```

This package will perform RC operations and bounds check when using `Memory[T]`, and will possibly read/write th memory head that lies out of bound of allocated region and leads to undefined behavior.

Instead, you shall allocate the piece of memory on your side, i.e. bind the C function as:

```moonbit
extern "c" fn make_a_(memory : Memory[A]) -> Unit

fn main {
  let mem : Memory[T] = ...
  make_a_(mem)
  // use mem
}
```
