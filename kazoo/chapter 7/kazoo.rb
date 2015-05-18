#!/usr/bin/ruby

# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Compiler Examples
# Date:        2011/05/09
# Description: This file is the driver for the Kazoo tutorial.

# Tutorial Files
require File.join(File.dirname(__FILE__), 'klexer')
require File.join(File.dirname(__FILE__), 'kparser')
require File.join(File.dirname(__FILE__), 'kcontractor')
#require File.join(File.dirname(__FILE__), 'kjit')

# Load the Kazoo C library.
RCGTK::Support.load_library('./libkazoo.so')

# Create our JIT compiler.
jit = Kazoo7::Contractor.new
#jit = Kazoo7::JIT.new

loop do
	print('Kazoo > ')
	line = ''

	begin
		line += ' ' if not line.empty?
		line += $stdin.gets.chomp
	end while line[-1,1] != ';'

	if line == 'quit;' or line == 'exit;'
		jit.module.verify
		jit.module.dump

		break
	end

	begin
		ast = Kazoo7::Parser.parse(Kazoo7::Lexer.lex(line))
		ir  = jit.add(ast)

		jit.optimize(ir).dump

		if ast.is_a?(Kazoo7::Expression)
			puts "=> #{jit.execute(ir).to_f(RCGTK::DoubleType)}"
		end

	rescue Exception => e
		puts e.message
		puts

	rescue RLTK::LexingError, RLTK::NotInLanguage
		puts 'Line was not in language.'
	end
end
