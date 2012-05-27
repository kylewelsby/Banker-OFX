module OFX
  module Parser
    class OFX102
      VERSION = "1.0.2"

      ACCOUNT_TYPES = {
        "CHECKING" => :checking
      }

      TRANSACTION_TYPES = [
        'ATM', 'CASH', 'CHECK', 'CREDIT', 'DEBIT', 'DEP', 'DIRECTDEBIT', 'DIRECTDEP', 'DIV',
        'FEE', 'INT', 'OTHER', 'PAYMENT', 'POS', 'REPEATPMT', 'SRVCHG', 'XFER'
      ].inject({}) { |hash, tran_type| hash[tran_type] = tran_type.downcase.to_sym; hash }

      attr_reader :headers
      attr_reader :body
      attr_reader :html

      def initialize(options = {})
        @headers = options[:headers]
        @body = options[:body]
        @html = Nokogiri::HTML.parse(body)
      end

      def bank_accounts
        @bank_accounts ||= build_bank_account
      end

      def credit_cards
        @credit_cards ||= build_credit_card
      end

      def self.parse_headers(header_text)
        # Change single CR's to LF's to avoid issues with some banks
        header_text.gsub!(/\r(?!\n)/, "\n")

        # Parse headers. When value is NONE, convert it to nil.
        headers = header_text.to_enum(:each_line).inject({}) do |memo, line|
          _, key, value = *line.match(/^(.*?):(.*?)\s*(\r?\n)*$/)

          unless key.nil?
            memo[key] = value == "NONE" ? nil : value
          end

          memo
        end

        return headers unless headers.empty?
      end

      private

      def build_bank_account
        html.search("stmttrnrs").each_with_object([]) do |account, accounts|
          args = {
            :bank_id      => account.search("bankacctfrom > bankid").inner_text,
            :id           => account.search("bankacctfrom > acctid").inner_text,
            :type         => ACCOUNT_TYPES[account.search("bankacctfrom > accttype").inner_text.to_s.upcase],
            :transactions => build_transactions(account.search("banktranlist > stmttrn")),
            :balance      => build_balance(account),
            :currency     => account.search("stmtrs > curdef").inner_text
          }

          accounts << OFX::Account.new(args)
        end
      end

      def build_credit_card
        html.search("ccstmttrnrs").each_with_object([]) do |account, accounts|
          args = {
            :id           => account.search("ccstmtrs > ccacctfrom > acctid").inner_text,
            :transactions => build_transactions(account.search("banktranlist > stmttrn")),
            :balance      => build_balance(account),
            :currency     => account.search("ccstmtrs > curdef").inner_text
          }

          accounts << OFX::Account.new(args)
        end
      end

      def build_transactions(transactions)
        transactions.each_with_object([]) do |transaction, transactions|
          transactions << build_transaction(transaction)
        end
      end

      def build_transaction(transaction)
        args = {
          :amount            => build_amount(transaction),
          :amount_in_pennies => (build_amount(transaction) * 100).to_i,
          :fit_id            => transaction.search("fitid").inner_text,
          :memo              => transaction.search("memo").inner_text,
          :name              => transaction.search("name").inner_text,
          :payee             => transaction.search("payee").inner_text,
          :check_number      => transaction.search("checknum").inner_text,
          :ref_number        => transaction.search("refnum").inner_text,
          :posted_at         => build_date(transaction.search("dtposted").inner_text),
          :type              => build_type(transaction)
        }

        OFX::Transaction.new(args)
      end

      def build_type(transaction)
        TRANSACTION_TYPES[transaction.search("trntype").inner_text.to_s.upcase]
      end

      def build_amount(transaction)
        BigDecimal.new(transaction.search("trnamt").inner_text)
      end

      def build_date(date)
        _, year, month, day, hour, minutes, seconds = *date.match(/(\d{4})(\d{2})(\d{2})(?:(\d{2})(\d{2})(\d{2}))?/)

        date = "#{year}-#{month}-#{day} "
        date << "#{hour}:#{minutes}:#{seconds}" if hour && minutes && seconds

        Time.parse(date)
      end

      def build_balance(account)
        amount = account.search("ledgerbal > balamt").inner_text.to_f

        args = {
          :amount => amount,
          :amount_in_pennies => (amount * 100).to_i,
          :posted_at => build_date(account.search("ledgerbal > dtasof").inner_text)
        }

        OFX::Balance.new(args)
      end
    end
  end
end
