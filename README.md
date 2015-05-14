# Example Compilers in Ruby

This repository contains compilers, written in Ruby, for several languages.  They are intended to show people how to use the [RLTK](https://github.com/chriswailes/RLTK) and [RCGTK](https://github.com/chriswailes/RCGTK) projects.

## Brainfuck

The Brainfuck compiler is presented as-is, without any tutorial material.  In the future a README will be added explaining the code and structure of the compiler.

## Kazoo

The Kazoo compiler is organized into an eight-step tutorial that discusses each aspect of the project in detail.  It covers many of the aspects of using both the RLTK and RCGTK projects.  The tutorial will show you how to use RLTK/RCGTK to build a lexer, parser, AST nodes, and compiler for a toy language called Kazoo. The tutorial is based on the LLVM [Kaleidoscope](http://llvm.org/docs/tutorial/) tutorial, but has been modified to:

1. Be in Ruby
2. Use a lexer and parser generator and
3. Use a language that I call Kazoo, which is really just a cleaned up and simplified version of the Kaleidoscope language used in the LLVM tutorial (as opposed to the [Kaleidoscope language](http://en.wikipedia.org/wiki/Kaleidoscope_%28programming_language%29) from the 90′s).

The Kazoo toy language is a procedural language that allows you to define functions, use conditionals, and perform basic mathematical operations.  Over the course of the tutorial we’ll extend Kazoo to support the if/then/else construct, for loops, JIT compilation, and a simple command line interface to the JIT.

Because we want to keep things simple the only datatype in Kazoo is a 64-bit floating point type (a C double or a Ruby float).  As such, all values are implicitly double precision and the language doesn’t require type declarations.  This gives the language a very nice and simple syntax.  For example, the following example computes Fibonacci numbers:

```
def fib(x)
  if x < 3 then
    1
  else
    fib(x-1) + fib(x-2)
```

The tutorial is organized as follows:

  * [Chapter 1: The Lexer](https://github.com/chriswailes/compiler-examples/blob/master/kazoo/chapter%201/Chapter1.md)
  * [Chapter 2: The AST Nodes](https://github.com/chriswailes/compiler-examples/blob/master/kazoo/chapter%202/Chapter2.md)
  * [Chapter 3: The Parser](https://github.com/chriswailes/compiler-examples/blob/master/kazoo/chapter%203/Chapter3.md)
  * [Chapter 4: AST Translation](https://github.com/chriswailes/compiler-examples/blob/master/kazoo/chapter%204/Chapter4.md)
  * [Chapter 5: JIT Compilation](https://github.com/chriswailes/compiler-examples/blob/master/kazoo/chapter%205/Chapter5.md)
  * [Chapter 6: Adding Control Flow](https://github.com/chriswailes/compiler-examples/blob/master/kazoo/chapter%206/Chapter6.md)
  * [Chapter 7: Playtime](https://github.com/chriswailes/compiler-examples/blob/master/kazoo/chapter%207/Chapter7.md)
  * [Chapter 8: Mutable Variables](https://github.com/chriswailes/compiler-examples/blob/master/kazoo/chapter%208/Chapter8.md)

Before starting this tutorial you should know about regular expressions, the basic ideas behind lexing and parsing, and be able to read context-free grammar (CFG) definitions.  By the end of this tutorial we will have written 372 lines of source code and have a JIT compiler for a Turing complete language.

## News

This repository contains the example and tutorial material that used to be included in the RLTK project.  It is now presnted here, independent of the RLTK/RCGTK gems.
