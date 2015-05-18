# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Compiler Examples
# Date:        2015/05/18
# Description: This file contains unit tests for chapter 6 of the Kazoo
#              tutorial.

############
# Requires #
############

# Gems
require 'minitest/autorun'

# Chapter files
require File.join(File.dirname(__FILE__), '../kazoo/chapter 6/kast')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 6/kcontractor')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 6/klexer')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 6/kparser')

class Chapter6Tester < Minitest::Test

	AST0_IR = %q(
define double @baz(double %x) {
entry:
  %ifcond = fcmp one double %x, 0.000000e+00
  br i1 %ifcond, label %then, label %else

then:                                             ; preds = %entry
  %calltmp = call double @foo()
  br label %merge

else:                                             ; preds = %entry
  %calltmp1 = call double @bar()
  br label %merge

merge:                                            ; preds = %else, %then
  %iftmp = phi double [ %calltmp, %then ], [ %calltmp1, %else ]
  ret double %iftmp
}
)

	AST1_IR = %q(
define double @printstar(double %n) {
entry:
  br label %loop_cond

loop_cond:                                        ; preds = %loop, %entry
  %i = phi double [ 0.000000e+00, %entry ], [ %nextvar, %loop ]
  %cmptmp = fcmp ult double %i, %n
  br i1 %cmptmp, label %loop, label %afterloop

loop:                                             ; preds = %loop_cond
  %calltmp = call double @putchard(double 4.200000e+01)
  %nextvar = fadd double 1.000000e+00, %i
  br label %loop_cond

afterloop:                                        ; preds = %loop_cond
  ret double 0.000000e+00
}
)

	def setup
	end

	def test_ir_gen
		jit = Kazoo6::Contractor.new

		ast0 = Kazoo6::Parser::parse(Kazoo6::Lexer::lex('extern foo();'))
		jit.add(ast0)

		ast1 = Kazoo6::Parser::parse(Kazoo6::Lexer::lex('extern bar();'))
		jit.add(ast1)

		ast2 = Kazoo6::Parser::parse(Kazoo6::Lexer::lex('def baz(x) if x then foo() else bar();'))
		ir2  = jit.add(ast2)
		assert_equal(AST0_IR, ir2.print)

		ast3 = Kazoo6::Parser::parse(Kazoo6::Lexer::lex('extern putchard(char);'))
		jit.add(ast3)

		ast4 = Kazoo6::Parser::parse(Kazoo6::Lexer::lex("def printstar(n)\nfor i = 0, i < n, 1.0 in\nputchard(42);"))
		ir4 = jit.add(ast4)
		jit.optimize(ir4)
		assert_equal(AST1_IR, ir4.print)
	end

	def test_parser
		assert_kind_of(Kazoo6::Expression, Kazoo6::Parser::parse(Kazoo6::Lexer::lex('40 + 2;')))
		assert_kind_of(Kazoo6::Prototype,  Kazoo6::Parser::parse(Kazoo6::Lexer::lex('def foo();')))
		assert_kind_of(Kazoo6::Function,   Kazoo6::Parser::parse(Kazoo6::Lexer::lex('def foo(x) x + 42;')))

		assert_kind_of(Kazoo6::If, Kazoo6::Parser::parse(Kazoo6::Lexer.lex('if 1 then 2 else 3;')))
	end
end
