require "spec_helper"

describe OFX::Account do
  describe "accounts" do
    let(:file) { "spec/fixtures/sample.ofx" }
    let(:ofx) { OFX::Parser::Base.new(file) }
    let(:parser) { ofx.parser }
    let(:accounts) { parser.bank_accounts }

    context 'multiple accounts' do
      let(:file) { "spec/fixtures/many_debit_accounts.ofx" }

      it { accounts.should be_an_instance_of(Array) }
      it { accounts.size.should eql(3) }
    end

    context 'debit' do
      subject { accounts.first }

      context 'keys' do
        it { subject.should respond_to(:bank_id) }
        it { subject.should respond_to(:id) }
        it { subject.should respond_to(:type) }
        it { subject.should respond_to(:transactions) }
        it { subject.should respond_to(:balance) }
        it { subject.should respond_to(:currency) }
      end

      context 'values' do
        it { subject.currency.should eql("BRL") }
        it { subject.bank_id.should eql("0356") }
        it { subject.id.should eql("03227113109") }
        it { subject.type.should eql(:checking) }
        it { subject.transactions.should be_an_instance_of(Array) }
        it { subject.transactions.size.should eql(36) }
        it { subject.balance.amount.should eql(598.44) }
        it { subject.balance.amount_in_pennies.should eql(59844) }
        it { subject.balance.posted_at.should eql(Time.parse("2009-11-01")) }
      end
    end

    context 'credit' do
      let(:file) { "spec/fixtures/v211.ofx" }
      let(:accounts) { parser.credit_cards }
      subject { accounts.first }

      context 'keys' do
        it { subject.should respond_to(:id) }
        it { subject.should respond_to(:transactions) }
        it { subject.should respond_to(:balance) }
        it { subject.should respond_to(:currency) }
      end

      context 'values' do
        it { subject.currency.should eql("USD") }
        it { subject.id.should eql("123412341234") }
        it { subject.transactions.should be_an_instance_of(Array) }
        it { subject.transactions.size.should eql(2) }
        it { subject.balance.amount.should eql(-562.0) }
        it { subject.balance.amount_in_pennies.should eql(-56200) }
      end
    end


  end
end
