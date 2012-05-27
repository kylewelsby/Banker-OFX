require "spec_helper"

describe OFX::Parser::OFX211 do
  let(:file) { "spec/fixtures/v211.ofx" }
  let(:ofx) { OFX::Parser::Base.new(file) }
  let(:parser) { ofx.parser }
  let(:accounts) { parser.bank_accounts }
  let(:account) { accounts.first }

  it "have a version" do
    OFX::Parser::OFX211::VERSION.should eql("2.1.1")
  end

  it "set headers" do
    parser.headers.should eql(ofx.headers)
  end

  it "set body" do
    parser.body.should eql(ofx.body)
  end

  it "set account" do
    account.should be_an_instance_of(OFX::Account)
  end

  context "transactions" do
    let(:transactions) { account.transactions }

    context "first" do
      let(:transaction) { transactions[0] }

      it "contain the correct values" do
        transaction.amount.should eql(-80)
        transaction.fit_id.should eql("219378")
        transaction.memo.should be_empty
        transaction.posted_at.should eql(Time.parse("2005-08-24 08:00:00"))
        transaction.name.should eql("FrogKick Scuba Gear")
      end
    end
  end
end

