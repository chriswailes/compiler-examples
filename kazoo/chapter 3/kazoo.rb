#!/usr/bin/ruby

# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Compiler Examples
# Date:        2011/05/09
# Description: This file is the driver for the Kazoo tutorial.

# Tutorial Files
require File.join(File.dirname(__FILE__), 'klexer')
require File.join(File.dirname(__FILE__), 'kparser')

#require './klexer'
#require './kparser'

loop do
	print('Kazoo > ')
	line = ''

	begin
		line += ' ' if not line.empty?
		line += $stdin.gets.chomp
	end while line[-1,1] != ';'

	break if line == 'quit;' or line == 'exit;'

	begin
		ast = Kazoo3::Parser.parse(Kazoo3::Lexer.lex(line))

		case ast
		when Kazoo3::Expression	then puts 'Parsed an expression.'
		when Kazoo3::Function	then puts 'Parsed a function definition.'
		when Kazoo3::Prototype	then puts 'Parsed a prototype or extern definition.'
		end

	rescue RLTK::LexingError, RLTK::NotInLanguage
		puts 'Line was not in language.'
	end
end
