# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Compiler Examples
# Date:        2015/05/15
# Description: This file contains unit tests for chapter 4 of the Kazoo
#              tutorial.

############
# Requires #
############

# Gems
require 'minitest/autorun'

# Chapter files
require File.join(File.dirname(__FILE__), '../kazoo/chapter 4/kast')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 4/kcontractor')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 4/klexer')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 4/kparser')

class Chapter4Tester < Minitest::Test
	AST0_IR = %q(
define double @0() {
entry:
  ret double 9.000000e+00
}
)

	AST1_IR = %q(
define double @foo(double %a, double %b) {
entry:
  %multmp = fmul double %a, %a
  %multmp1 = fmul double 2.000000e+00, %a
  %multmp2 = fmul double %multmp1, %b
  %addtmp = fadd double %multmp, %multmp2
  %multmp3 = fmul double %b, %b
  %addtmp4 = fadd double %addtmp, %multmp3
  ret double %addtmp4
}
)

	AST2_IR = %q(
define double @bar(double %a) {
entry:
  %calltmp = call double @foo(double %a, double 4.000000e+00)
  %calltmp1 = call double @bar(double 3.133700e+04)
  %addtmp = fadd double %calltmp, %calltmp1
  ret double %addtmp
}
)

	AST3_IR = %q(
declare double @cos(double)
)

	AST4_IR = %q(
define double @1() {
entry:
  %calltmp = call double @cos(double 1.234000e+00)
  ret double %calltmp
}
)

	def setup
	end

	def test_ir_gen
		jit = Kazoo4::Contractor.new

		ast0 = Kazoo4::Parser::parse(Kazoo4::Lexer::lex('4 + 5;'))
		assert_equal(AST0_IR, jit.add(ast0).print)

		ast1 = Kazoo4::Parser::parse(Kazoo4::Lexer::lex('def foo(a,b) a*a + 2*a*b + b*b;'))
		assert_equal(AST1_IR, jit.add(ast1).print)

		ast2 = Kazoo4::Parser::parse(Kazoo4::Lexer::lex('def bar(a) foo(a, 4.0) + bar(31337);'))
		assert_equal(AST2_IR, jit.add(ast2).print)

		ast3 = Kazoo4::Parser::parse(Kazoo4::Lexer::lex('extern cos(x);'))
		assert_equal(AST3_IR, jit.add(ast3).print)

		ast4 = Kazoo4::Parser::parse(Kazoo4::Lexer::lex('cos(1.234);'))
		assert_equal(AST4_IR, jit.add(ast4).print)

	end

	def test_parser
		assert_kind_of(Kazoo4::Expression, Kazoo4::Parser::parse(Kazoo4::Lexer::lex('40 + 2;')))
		assert_kind_of(Kazoo4::Prototype,  Kazoo4::Parser::parse(Kazoo4::Lexer::lex('def foo();')))
		assert_kind_of(Kazoo4::Function,   Kazoo4::Parser::parse(Kazoo4::Lexer::lex('def foo(x) x + 42;')))
	end
end
