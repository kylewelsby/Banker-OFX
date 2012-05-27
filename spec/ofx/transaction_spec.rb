require "spec_helper"

describe OFX::Transaction do
  let(:file) { "spec/fixtures/sample.ofx" }
  let(:ofx) { OFX::Parser::Base.new(file) }
  let(:parser) { ofx.parser }
  let(:accounts) { parser.bank_accounts }
  let(:account) { accounts.first }

  context "debit" do
    let(:transaction) { account.transactions[0] }

    it "set amount" do
      transaction.amount.should eql(-35.34)
    end

    it "cast amount to BigDecimal" do
      transaction.amount.class.should eql(BigDecimal)
    end

    it "set amount in pennies" do
      transaction.amount_in_pennies.should eql(-3534)
    end

    it "set fit id" do
      transaction.fit_id.should eql("200910091")
    end

    it "set memo" do
      transaction.memo.should eql("COMPRA VISA ELECTRON")
    end

    it "set check number" do
      transaction.check_number.should eql("0001223")
    end

    it "have date" do
      transaction.posted_at.should eql(Time.parse("2009-10-09 08:00:00"))
    end

    it "have type" do
      transaction.type.should eql(:debit)
    end
  end

  context "credit" do
    let(:transaction) { account.transactions[1] }

    it "set amount" do
      transaction.amount.should eql(60.39)
    end

    it "set amount in pennies" do
      transaction.amount_in_pennies.should eql(6039)
    end

    it "set fit id" do
      transaction.fit_id.should eql("200910162")
    end

    it "set memo" do
      transaction.memo.should eql("DEPOSITO POUP.CORRENTE")
    end

    it "set check number" do
      transaction.check_number.should eql("0880136")
    end

    it "have date" do
      transaction.posted_at.should eql(Time.parse("2009-10-16 08:00:00"))
    end

    it "have type" do
      transaction.type.should eql(:credit)
    end
  end

  context "with more info" do
    let(:transaction) { account.transactions[2] }

    it "set payee" do
      transaction.payee.should eql("Pagto conta telefone")
    end

    it "set check number" do
      transaction.check_number.should eql("000000101901")
    end

    it "have date" do
      transaction.posted_at.should eql(Time.parse("2009-10-19 12:00:00"))
    end

    it "have type" do
      transaction.type.should eql(:other)
    end

    it "have reference number" do
      transaction.ref_number.should eql("101.901")
    end
  end

  context "with name" do
    let(:transaction) { account.transactions[3] }

    it "set name" do
      transaction.name.should eql("Pagto conta telefone")
    end
  end

  context "with other types" do
    let(:file) { "spec/fixtures/bb.ofx" }

    context 'dep' do
      let(:transaction) { account.transactions[9] }

      it { transaction.type.should eql(:dep) }
    end

    context 'xfer' do
      let(:transaction) { account.transactions[18] }

      it { transaction.type.should eql(:xfer) }
    end

    context 'cash' do
      let(:transaction) { account.transactions[45] }

      it { transaction.type.should eql(:cash) }
    end

    context 'check' do
      let(:transaction) { account.transactions[0] }

      it { transaction.type.should eql(:check) }
    end
  end
end
