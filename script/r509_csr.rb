#!/usr/bin/ruby

require 'rubygems'
require 'r509'
require 'openssl'

csr = R509::Csr.new
subject = OpenSSL::X509::Name.new
if ARGV[0].nil? then
	puts "Interactive CSR generation using r509. Assuming 2048-bit key"
	puts "You can also call with 1 or 2 args (string subject, int bit_strength)"
	subject = []
	print "C (US): "
	c = gets.chomp
	if c.empty? then
		c = 'US'
	end
	subject.push ['C',c]

	print "ST (Illinois): "
	st = gets.chomp
	if st.empty? then
		st = 'Illinois'
	end
	subject.push ['ST',st]

	print "L (Chicago): "
	l = gets.chomp
	if l.empty? then
		l = 'Chicago'
	end
	subject.push ['L',l]
	
	print "O (r509 LLC): "
	o = gets.chomp
	if o.empty? then
		o = 'r509 LLC'
	end
	subject.push ['O',o]

	print "CN: "
	subject.push ['CN',gets.chomp]
	print "SAN Domains (comma separated):"
	san_domains = []
	san_domains = gets.chomp.split(',').collect { |domain| domain.strip }
	csr.create_with_subject subject,2048,san_domains
	puts csr.key
	puts csr
	puts csr.subject
else
	ARGV[0].split('/').each { |item|
		if item != '' then
			value = item.split('=')
			subject.add_entry(value[0],value[1])
		end
	}
	bit_strength = nil
	if ARGV.size > 1 then
		bit_strength = ARGV[1].to_i
	else
		bit_strength = 2048
	end
	csr.create_with_subject subject,bit_strength
	puts csr.key
	puts csr
	puts csr.subject
end
