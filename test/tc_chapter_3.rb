# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Compiler Examples
# Date:        2015/05/15
# Description: This file contains unit tests for chapter 3 of the Kazoo
#              tutorial.

############
# Requires #
############

# Gems
require 'minitest/autorun'

# Chapter files
require File.join(File.dirname(__FILE__), '../kazoo/chapter 3/kast')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 3/klexer')
require File.join(File.dirname(__FILE__), '../kazoo/chapter 3/kparser')

class Chapter3Tester < Minitest::Test
	def setup
	end

	def test_parser
		assert_kind_of(Kazoo3::Expression, Kazoo3::Parser::parse(Kazoo3::Lexer::lex('40 + 2;')))
		assert_kind_of(Kazoo3::Prototype,  Kazoo3::Parser::parse(Kazoo3::Lexer::lex('def foo();')))
		assert_kind_of(Kazoo3::Function,   Kazoo3::Parser::parse(Kazoo3::Lexer::lex('def foo(x) x + 42;')))
	end
end
