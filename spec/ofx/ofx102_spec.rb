require "spec_helper"

describe OFX::Parser::OFX102 do
  let(:file) { "spec/fixtures/sample.ofx" }
  let(:ofx) { OFX::Parser::Base.new(file) }
  let(:parser) { ofx.parser }
  let(:accounts) { parser.bank_accounts }
  let(:account) { accounts.first }

  it "have a version" do
    OFX::Parser::OFX102::VERSION.should eql("1.0.2")
  end

  it "set headers" do
    parser.headers.should eql(ofx.headers)
  end

  it "trim trailing whitespace from headers" do
    headers = OFX::Parser::OFX102.parse_headers("VERSION:102   ")
    headers["VERSION"].should eql("102")
  end

  it "set body" do
    parser.body.should eql(ofx.body)
  end

  it "set account" do
    account.should be_an_instance_of(OFX::Account)
  end

  it "know about all transaction types" do
    valid_types = [
      'CREDIT', 'DEBIT', 'INT', 'DIV', 'FEE', 'SRVCHG', 'DEP', 'ATM', 'POS', 'XFER',
      'CHECK', 'PAYMENT', 'CASH', 'DIRECTDEP', 'DIRECTDEBIT', 'REPEATPMT', 'OTHER'
    ]

    valid_types.sort.should eql(OFX::Parser::OFX102::TRANSACTION_TYPES.keys.sort)

    valid_types.each do |transaction_type|
      transaction_type.downcase.to_sym.should eql(OFX::Parser::OFX102::TRANSACTION_TYPES[transaction_type])
    end
  end

end
