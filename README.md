# Banker-OFX [![CI Build Status](https://travis-ci.org/kylewelsby/Banker-OFX.svg?branch=master)][travis] [![Dependency Status](https://gemnasium.com/badges/github.com/kylewelsby/Banker-OFX.svg)][gemnasium] [![Coverage Status](https://coveralls.io/repos/github/kylewelsby/Banker-OFX/badge.svg?branch=master)][coveralls]

[travis]:https://travis-ci.org/kylewelsby/Banker-OFX
[gemnasium]:https://gemnasium.com/github.com/kylewelsby/Banker-OFX
[coveralls]:https://coveralls.io/github/kylewelsby/Banker-OFX?branch=master

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
* 1.9
* 2.0
* 2.1
* 2.2
* 2.3

#### OFX
* 1.0.2
* 2.1.1

### ToDo
1. Support other OFX Versions

### Original Fork

* Nando Vieira - https://github.com/fnando/ofx

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
