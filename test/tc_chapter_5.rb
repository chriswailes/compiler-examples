# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Compiler Examples
# Date:        2015/05/15
# Description: This file contains unit tests for chapter 5 of the Kazoo
#              tutorial.

############
# Requires #
############

# Gems
require 'minitest/autorun'

# Chapter files
require File.join(File.dirname(__FILE__), '../kazoo/chapter 5/kast')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 5/kcontractor')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 5/klexer')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 5/kparser')

class Chapter5Tester < Minitest::Test

	AST0_IR = %q(
define double @test(double %x) {
entry:
  %addtmp = fadd double 3.000000e+00, %x
  %addtmp1 = fadd double %x, 3.000000e+00
  %multmp = fmul double %addtmp, %addtmp1
  ret double %multmp
}
)

	AST0_IR_OP = %q(
define double @test(double %x) {
entry:
  %addtmp = fadd double 3.000000e+00, %x
  %multmp = fmul double %addtmp, %addtmp
  ret double %multmp
}
)

	AST1_IR = %q(
define double @testfunc(double %x, double %y) {
entry:
  %multmp = fmul double %y, 2.000000e+00
  %addtmp = fadd double %x, %multmp
  ret double %addtmp
}
)

	AST2_IR = %q(
define double @0() {
entry:
  %calltmp = call double @testfunc(double 4.000000e+00, double 1.000000e+01)
  ret double %calltmp
}
)

	def assert_evaluates_to(expr, expected, *defs)
		jit = Kazoo5::Contractor.new

		defs.each do |d|
			ast = Kazoo5::Parser::parse(Kazoo5::Lexer::lex(d))
			jit.add(ast)
		end

		ast = Kazoo5::Parser::parse(Kazoo5::Lexer::lex(expr))

		assert_kind_of(Kazoo5::Expression, ast)

		ir = jit.add(ast)

		assert_equal(expected, jit.execute(ir).to_f(RCGTK::DoubleType))
	end

	def setup
	end

	def test_execution
		assert_evaluates_to('4 + 5;', 9.0)
		assert_evaluates_to('testfunc(4, 10);', 24, 'def testfunc(x,y) x + y*2;')
		assert_evaluates_to('sin(1.0);', 0.8414709848078965, 'extern sin(x);')
		assert_evaluates_to('foo(4.0);', 1.0, 'extern sin(x);',
		                                      'extern cos(x);',
		                                      'def foo(x) sin(x)*sin(x) + cos(x)*cos(x);')
	end

	def test_ir_gen
		jit = Kazoo5::Contractor.new

		ast0 = Kazoo5::Parser::parse(Kazoo5::Lexer::lex('def test(x) (1+2+x)*(x+(1+2));'))
		ir0  = jit.add(ast0)
		assert_equal(AST0_IR, ir0.print)
		assert_equal(AST0_IR_OP, jit.optimize(ir0).print)

		ast1 = Kazoo5::Parser::parse(Kazoo5::Lexer::lex('def testfunc(x,y) x + y*2;'))
		assert_equal(AST1_IR, jit.add(ast1).print)

		ast2 = Kazoo5::Parser::parse(Kazoo5::Lexer::lex('testfunc(4, 10);'))
		assert_equal(AST2_IR, jit.add(ast2).print)

	end

	def test_parser
		assert_kind_of(Kazoo5::Expression, Kazoo5::Parser::parse(Kazoo5::Lexer::lex('40 + 2;')))
		assert_kind_of(Kazoo5::Prototype,  Kazoo5::Parser::parse(Kazoo5::Lexer::lex('def foo();')))
		assert_kind_of(Kazoo5::Function,   Kazoo5::Parser::parse(Kazoo5::Lexer::lex('def foo(x) x + 42;')))
	end
end
