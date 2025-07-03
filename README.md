<img width="64" alt="ReadmeIcon_Vaja" src="https://github.com/user-attachments/assets/f9482278-c98f-4ab1-9e80-07d0a1cc7f76" />
# Vaja Programming Language

> *A minimal, statically-typed, educational language that compiles to FASM — for fun, learning, and hacking!*

---

## What is Vaja?

**Vaja** is an experimental, statically-typed, C-inspired language designed to be simple, readable, and fun to implement.
Vaja is not intended for production use, but rather as a playground for learning language implementation, parsing, and code generation.

* **Statically typed:** All variables and functions require explicit types.
* **Curly-brace syntax:** Familiar block structure like C/C++/Java.
* **Compiles to assembly:** Vaja source code is transpiled to FASM (Flat Assembler).
* **First-class console:** Built-in `print` and `readline` for I/O.
* **CamelCase keywords:** All keywords are written in lowerCamelCase (e.g., `func`, `ret`).

> **Note:** Vaja is intentionally minimal and may be missing many features found in other languages!

---

## Current Capabilities

* Variable declarations: `int`, `long`, `bool`, `string`, `void`
* Functions (single return type)
* Expressions (arithmetic, comparison, logical)
* Conditionals: `if`/`else`
* Loops: `while` (no for right now)
* Print and Readline built-in

### Limitations

* **No floating-point numbers** (for now; only `int` and `long`)
* **No arrays, structs, or user-defined types**
* **No import/module system**
* **No error handling/exception support**
* **No pointers or direct memory access** => Prioritary on the roadmap
* **Minimal standard library:** Only `print` and `readline`
* **No operator overloading or generics**
* **Only console applications (no GUI, no files)**
* **Simple string support** (no interpolation, only double-quoted literals)

---

## Language Syntax

The following section gives a detailed overview of Vaja syntax, inspired by classic language documentation.

---

### **1. Keywords**

| Keyword         | Description             |
| --------------- | ----------------------- |
| `func`          | Function declaration    |
| `int`           | 32-bit integer          |
| `long`          | 64-bit integer          |
| `bool`          | Boolean (true/false)    |
| `string`        | UTF-8 string            |
| `void`          | No return type          |
| `if`, `else`    | Conditionals            |
| `while`         | While loop              |
| `for`           | For loop                |
| `print`         | Print to console        |
| `readline`      | Read input from console |
| `ret`           | Return from function    |
| `true`, `false` | Boolean literals        |

---

### **2. Comments**

* **Single-line:**
  `// This is a comment`

* **Multi-line:**

  ```
  /* This is
     a multiline
     comment */
  ```

---

### **3. Variables**

#### Declaration

```vaja
int x = 5;
long big = 1234567890;
string name = "Vaja";
bool ok = true;
```

* All variables must have a type and an initial value.
* Use `=` for assignment at declaration.

#### Assignment

```vaja
x = 10;
name = "newName";
```

---

### **4. Functions**

#### Declaration

```vaja
func int sum(a: int, b: int) {
    int result = a + b;
    ret result;
}

func void greet(name: string) {
    print("Hello, " + name);
}
```

* Use `func` keyword, specify return type and parameter list.
* Parameters: `name: type`
* Functions may return a value with `ret`.

#### Main Entry Point

```vaja
func void main() {
    // Entry point
}
```

---

### **5. Expressions & Operators**

#### Arithmetic

| Operator | Meaning        | Example |
| -------- | -------------- | ------- |
| `+`      | Addition       | `a + b` |
| `-`      | Subtraction    | `a - b` |
| `*`      | Multiplication | `a * b` |
| `/`      | Division       | `a / b` |

#### Comparison

| Operator | Meaning          |
| -------- | ---------------- |
| `==`     | Equal            |
| `!=`     | Not equal        |
| `<`      | Less than        |
| `>`      | Greater than     |
| `<=`     | Less or equal    |
| `>=`     | Greater or equal |

#### Logical

| Operator  | Meaning     |
| --------  | ----------- |
| `and`     | Logical AND |
| `or`      | Logical OR  |
| `!` `not` | Logical NOT |

---

### **6. Conditionals**

```vaja
if (ok) {
    print("Yes!");
} else {
    print("No!");
}
```

---

### **7. Loops**

#### While Loop

```vaja
int i = 0;
while (i < 10) {
    print(i);
    i = i + 1;
}
```

---

### **8. Built-in Functions**

#### Print

```vaja
print("Hello, world!");
```

#### Read Input

```vaja
string user = readline();
```

---

### **9. Strings**

* String literals are double-quoted: `"hello"`
* Concatenate with `+`: `"hello, " + name`

---

### **10. Example Program**

```vaja
func void greet(name: string) {
    print("Hello, " + name);
}

func int sum(a: int, b: int) {
    int result = a + b;
    ret result;
}

func void main() {
    string user = readline();
    greet(user);

    int s = sum(4, 5);
    print("Sum: " + s);
}
```

---

## Limitations and Roadmap

Vaja is under active development. Planned future features include:

* Arrays and collection types
* Pointers
* Floating-point (`float`) support
* File I/O and basic standard library extensions
* Improved compiler error messages
* Structure
* Debugging tools

Contributions and feature requests are welcome! See [RFP.md](./RFP.md) for details.
---

## Compiler documentation
[Compiler.md](./COMPILER_DOC.md)

---

## License

Vaja is licensed under the GNU GPL v3.0. See [LICENSE](./LICENSE) for details.

---

## Contributing

Pull requests, issues, and creative ideas are encouraged!
See [RFP.md](./RFP.md) to get started.
See https://github.com/Vaja-Language/vaja/discussions

---

## Author

[GitHub](https://github.com/pierre.feytout)

---
