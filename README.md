# tonyfettes/memory

A MoonBit module providing **relatively** safe FFI memory management with consistent behavior across all backends.

```moonbit
fn process(ptr : Int) -> Unit = "ffi" "process"

fn main {
  let data = [1, 2, 3, 4, 5]
  let memory = @memory.Memory::of_array(data)
  let ptr = memory.to_int()
  process(ptr)
  @memory.free(ptr)
}
```

## Installation

Add to your project:

```bash
moon add tonyfettes/memory
```

Include in `moon.pkg.json`:

```json
{
  "import": ["tonyfettes/memory"]
}
```

## Safety

- Make sure all `Memory[T]` are allocated on the MoonBit side, or converted from `FixedArray[T]`.
- Never use `Memory[T]` to represent externally allocated memory.
- Never use `Memory[T]` to represent a slice/view of ANY KIND of memory, even
  the memory allocated on the MoonBit side.
- Remember to free every pointer.

On Wasm and Native backends, the memory allocator in MoonBit will reserve extra
space before the allocated memory to do some bookeeping. This means
almost all the time, you should pass `Memory[T]` to FFIs, instead of getting
`Memory[T]` from them. For example, given the following C function:

```c
float *randn(int size);
```

This C function allocates a piece of memory to store `size` number of `float`,
then initializes it with random values. You should NEVER bind to it
like this:

```moonbit
extern "c" fn randn() -> @memory.Memory[Float] = "randn"
```

Because the returned `float *` is allocated outside MoonBit, it is highly
probable that the memory does not come with a valid header that can be parsed by
MoonBit. It is basically not possible to detect if the header is valid without
bloating the header size, so we always _think_ there is a valid header. It is OK
if you just play around with `Memory[T]`, but when you start to dereference it
into a `Float` or convert it back to a `FixedArray[Float]`, MoonBit will perform
several out-of-bound memory operations to update RC counters, etc., leading to a
corrupted memory and undefined behaviors.

A more correct way to bind this C API is to wrap the `randn` function so that it
copies the allocated float array to a `Memory[T]` that is allocated on the
MoonBit side:

```c
void randn_wrap(int size, float *memory) {
  float *array = randn(size);
  memcpy(memory, array, size * sizeof(float));
}
```

```moonbit
extern "c" fn randn_wrap(size : Int, memory : @memory.Memory[Float]) -> Unit = "randn_wrap"

fn randn(size : Int) -> @memory.Memory[Float] {
  let memory = @memory.allocate(size)
  randn_wrap(size, memory)
  memory
}
```
