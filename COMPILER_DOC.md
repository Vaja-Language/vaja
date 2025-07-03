# Vaja Assembler Documentation

**(Target: GCC, GAS AT\&T syntax, Windows, Native AOT Standard Library)**

---

## Overview

The Vaja assembler project generates assembly code in **GAS/AT\&T syntax** (`.s` files), which is then compiled and linked with GCC for Windows targets.
Vaja programs use a standard library written in C# and compiled to a static library using **.NET NativeAOT**, allowing seamless function calls from assembly to high-level C# code.

---

**Example build command:**

```sh
gcc -vaja.s -o main.exe -L. -lVajaStandardLib -lkernel32
```

---

## 1. Assembly Generation

* **Format:** GAS (GNU Assembler) in AT\&T syntax
* **Source extension:** `.s`
* **Example:**

  ```asm
  .section .text
  .globl main
  main:
      # ... assembly instructions ...
      call    Vaja_PrintString  # Calls a function from VajaStandardLib
      ret
  ```

---

## 2. Variable Declaration and Naming

* **Vaja variable declaration syntax:**
  Always explicit, e.g.:

  ```vaja
  int x = 5;
  int y;
  ```

* **Assembly mapping:**

  * If **assigned at declaration** (`int x = 5;`):
    Symbol in `.data`, initialized.
  * If **declared only** (`int y;`):
    Symbol in `.bss`, uninitialized.

* **Naming convention:**

  * Variable names are always prefixed by the function scope:
    `{FunctionName}_{VariableName}`
  * **No global variables** are supported at this time.

* **Function labeling:**
  Each function is a global label in `.text`, named after the function.

---

## 3. Sections Layout

* **.data**:
  Stores all initialized variables.
* **.bss**:
  Stores all uninitialized variables.
* **.text**:
  Contains function code (each function has a unique label).

---

## 4. Example

**Vaja Source:**

```vaja
int x = 10;
int y;
```

Declared inside a function named `foo`:

```vaja
function foo() {
    int x = 10;
    int y;
    // ...
}
```

**Generated Assembly:**

```asm
.data
foo_x: .quad 10

.bss
foo_y: .zero 8

.text
.global foo
foo:
    # function body uses foo_x and foo_y
    ret
```

---

## 5. Standard Library Integration

* Link to the standard library compiled in native AOT (`VajaStandardLib`).
* Use the GCC linker options:
  `-L. -lVajaStandardLib -lkernel32`

* **Library code:** C# (using NativeAOT for ahead-of-time compilation)
* **Compile to:** Dynamic library (`.dll`), compatible with GCC
* **Exports:** Functions using `[UnmanagedCallersOnly]` and appropriate P/Invoke-compatible signatures (e.g., `Cdecl` or `Stdcall`)
* **Naming:** Output as `VajaStandardLib.dll`
* **Location:** Placed in the same directory as the assembly output and provided to GCC via `-L/path/to/lib`

---
## 6. Building and Linking

**Command pattern:**

```sh
gcc yourfile.s -o yourprog.exe -L. -lVajaStandardLib -lkernel32
```

* `yourfile.s` — GAS/AT\&T assembly source
* `-L.` — look for libraries in current directory
* `-lVajaStandardLib` — links against `VajaStandardLib.dll`
* `-lkernel32` — links with Windows system library

---

## 7. Calling Conventions and Interop

* **Use compatible calling conventions:**

  * Typically `Cdecl` for easiest interop with GCC.
  * Decorate C# exported methods with `[UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvCdecl) })]`.
* **Exporting C# functions:**

  ```csharp
  [UnmanagedCallersOnly(EntryPoint = "Vaja_PrintString", CallConvs = new[] { typeof(CallConvCdecl) })]
  public static void PrintString(byte* str) { ... }
  ```

---

## 8. Assembly-to-C# Calls

* To call a function in the standard library, use the global label defined by the export (e.g., `Vaja_PrintString`).
* Pass parameters according to x64 Windows calling convention (RCX, RDX, R8, R9 for the first four integer/pointer args).
* **String encoding:**

  * If calling from assembly and passing strings, use UTF-8 or ASCII-encoded null-terminated buffers (as C# can convert via `new string((byte*)ptr)` or `Marshal.PtrToStringAnsi`).
  * Confirm the encoding/decoding scheme in your Vaja runtime.

---

## 9. Example Build Workflow

**1. Generate assembly (`main.s`)**
**2. Build executable:**

```sh
gcc main.s -o main.exe -L. -lVajaStandardLib -lkernel32
```

---

## 10. Windows System Calls

* You can invoke Windows APIs directly from assembly or via the Vaja standard lib.
* `-lkernel32` is required for basic Win32 APIs.
* Add more system libs as needed:
  `-luser32`, `-lgdi32`, etc.

---

## 11. Calling Conventions

* **Each function** receives control at its global label.
* **Variables** are accessed via their fully-scoped symbol names.
* **No stack-allocated locals** for now; all variables are statically allocated per function.

---

## 12. Notes & Limitations

* All variable storage is static, per-function (no dynamic or stack locals).
* If two functions declare `int x;`, the symbols are `foo_x` and `bar_x` respectively.
* No global variables supported (yet).
* Arrays, structs, or pointers: see future documentation.

---

## 13. System Interop

* Use standard library for I/O, HTTP, and Windows syscalls as exposed by the native AOT library.

---

## 14. Compilation Workflow

1. **Vaja source** → **GAS assembly** (`.s`, AT\&T syntax)
2. **Standard library**: C#, compiled NativeAOT DLL/lib
3. **Link** all with GCC (with `-lkernel32` for Windows system)
4. **Output:** Windows native executable

---

## 15. Example Full Vaja Function

**Vaja:**

```vaja
function add() {
    int a = 1;
    int b = 2;
    int c;
    c = a + b;
}
```

**Assembly:**

```asm
.data
add_a: .quad 1
add_b: .quad 2

.bss
add_c: .zero 8

.text
.global add
add:
    # Function body: use add_a, add_b, add_c
    ret
```
