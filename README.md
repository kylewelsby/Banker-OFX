# Banker-OFX [![CI Build Status](https://secure.travis-ci.org/BritRuby/Banker-OFX.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/BritRuby/Banker-OFX.png?travis)][gemnasium]

[travis]:http://travis-ci.org/BritRuby/Banker-OFX
[gemnasium]:https://gemnasium.com/BritRuby/Banker-OFX

A simple OFX (Open Financial Exchange) parser originally forked from Nando Vieira. Now supports Bank Accounts and Credit Cards as well as Multiple Accounts.

### Usage

	require 'ofx'

	ofx = OFX("statement.ofx")

	ofx.bank_accounts.each do |bank_account|
	  puts bank_account.id # => "492108"
	  puts bank_account.bank_id # => "1837"
	  puts bank_account.currency # => "GBP"
	  puts bank_account.type # => :checking
	  puts bank_account.balance.amount # => "100.00"
	  puts bank_account.balance.amount_in_pennies # => "10000"
	  puts bank_account.transactions # => [#<OFX::Transaction:0x007ff3bb8cf418>]
	end

	ofx.credit_cards.each do |credit_card|
	  puts credit_card.id # => "81728918309730"
	  puts credit_card.currency # => "GBP"
	  puts bank_account.balance.amount # => "-100.00"
	  puts bank_account.balance.amount_in_pennies # => "-10000"
	  puts credit_card.transactions # => [#<OFX::Transaction:0x007ff3bb8cf418>]
	end

### Supports
#### Ruby
* 1.9.2
* 1.9.3

#### OFX
* 1.0.2
* 2.1.1

### ToDo
1. Support other OFX Versions

### Original Fork

* Nando Vieira - https://github.com/fnando/ofx
