# Vaja Assembler Documentation – **Updated for GCC/NativeAOT Workflow (Windows)**

## Overview

The Vaja assembler project generates assembly code in **GAS/AT\&T syntax** (`.s` files), which is then compiled and linked with GCC for Windows targets.
Vaja programs use a standard library written in C# and compiled to a static library using **.NET NativeAOT**, allowing seamless function calls from assembly to high-level C# code.

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

## 2. Standard Library Integration

* **Library code:** C# (using NativeAOT for ahead-of-time compilation)
* **Compile to:** Dynamic library (`.dll`), compatible with GCC
* **Exports:** Functions using `[UnmanagedCallersOnly]` and appropriate P/Invoke-compatible signatures (e.g., `Cdecl` or `Stdcall`)
* **Naming:** Output as `VajaStandardLib.dll`
* **Location:** Placed in the same directory as the assembly output and provided to GCC via `-L/path/to/lib`

---

## 3. Building and Linking

**Command pattern:**

```sh
gcc yourfile.s -o yourprog.exe -L. -lVajaStandardLib -lkernel32
```

* `yourfile.s` — GAS/AT\&T assembly source
* `-L.` — look for libraries in current directory
* `-lVajaStandardLib` — links against `VajaStandardLib.dll`
* `-lkernel32` — links with Windows system library

---

## 4. Calling Conventions and Interop

* **Use compatible calling conventions:**

  * Typically `Cdecl` for easiest interop with GCC.
  * Decorate C# exported methods with `[UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvCdecl) })]`.
* **Exporting C# functions:**

  ```csharp
  [UnmanagedCallersOnly(EntryPoint = "Vaja_PrintString", CallConvs = new[] { typeof(CallConvCdecl) })]
  public static void PrintString(byte* str) { ... }
  ```

---

## 5. Assembly-to-C# Calls

* To call a function in the standard library, use the global label defined by the export (e.g., `Vaja_PrintString`).
* Pass parameters according to x64 Windows calling convention (RCX, RDX, R8, R9 for the first four integer/pointer args).
* **String encoding:**

  * If calling from assembly and passing strings, use UTF-8 or ASCII-encoded null-terminated buffers (as C# can convert via `new string((sbyte*)ptr)` or `Marshal.PtrToStringAnsi`).
  * Confirm the encoding/decoding scheme in your Vaja runtime.

---

## 6. Example Build Workflow

**1. Generate assembly (`main.s`)**
**2. Build executable:**

```sh
gcc main.s -o main.exe -L. -lVajaStandardLib -lkernel32
```

---

## 7. Windows System Calls

* You can invoke Windows APIs directly from assembly or via the Vaja standard lib.
* `-lkernel32` is required for basic Win32 APIs.
* Add more system libs as needed:
  `-luser32`, `-lgdi32`, etc.

---

## 8. Known Limitations

* Reflection, dynamic code generation, and most .NET runtime features are unavailable in NativeAOT.
* Only exports decorated with `[UnmanagedCallersOnly]` and compatible signatures are visible to GCC/assembler.
* Ensure correct calling conventions and argument types.
* Trimming/AOT may remove unused code—verify exports remain!

---

## 9. Troubleshooting

* **Undefined references:** Make sure all required symbols are exported and declared global in your assembly.
* **ABI mismatches:** Double-check calling conventions and argument orders.
* **Encoding:** Strings passed from assembly should match the expected encoding in your C# side.

---

## 10. References

* [NativeAOT documentation](https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/)
* [GAS/AT\&T syntax reference](https://sourceware.org/binutils/docs/as/)
* [GCC manual](https://gcc.gnu.org/onlinedocs/)

---

## 11. Example End-to-End

**main.s**

```asm
.extern Readline # Import from VajaStandard library
.extern Print # Import from VajaStandard library

.section .data
msg: .asciz "Hello"

.section .text
.global main
main:
    # Allocate shadow space (32 bytes) + stack alignment (Windows ABI)
    subq $40, %rsp

    call Readline      # return: rax = sbyte* (char*)
    movq %rax, %rcx    # 1st argument for Print (char* in RCX)

    call Print         # Print(sbyte* str)
    
    leaq msg(%rip), %rcx # recommended way to put string as parameter in register   
    call Print
    addq $40, %rsp

    xor %eax, %eax     # return 0
    ret
```
- https://forum.osdev.org/viewtopic.php?t=28775
- https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf

**VajaStandardLib C#:**

```csharp
[UnmanagedCallersOnly(EntryPoint = "Print", CallConvs = new[] { typeof(CallConvCdecl) })]
public static void Print(sbyte* str)
{
    Console.WriteLine(Marshal.PtrToStringAnsi((IntPtr)str));
}
```

**Build:**

```sh
gcc main.s -o main.exe -L. -lVajaStandardLib -lkernel32
```

---
