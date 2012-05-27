module OFX
  module Parser
    class Base
      attr_reader :headers
      attr_reader :body
      attr_reader :content
      attr_reader :parser

      def initialize(resource)
        @content = open_resource(resource).read
        prepare(content)
      end

    private

      def open_resource(document)
        return document if document.respond_to?(:read)
        open(document, "r:iso-8859-1:utf-8")
      rescue
        StringIO.new(utf8_converter(document))
      end

      def prepare(content)
        header, body = content.dup.split(/<OFX>/, 2)
        raise OFX::UnsupportedFileError unless body

        begin
          @headers = condition_headers(header)
          @body = condition_body(body)
        rescue Exception
          raise OFX::UnsupportedFileError
        end

        instantiate_parser
      end

      def instantiate_parser
        case headers["VERSION"]
        when /102/ then
          @parser = OFX102.new(:headers => headers, :body => body)
        when /200|211/ then
          @parser = OFX211.new(:headers => headers, :body => body)
        else
          raise OFX::UnsupportedFileError
        end
      end

      def condition_headers(header)
        headers = nil

        OFX::Parser.constants.grep(/OFX/).each do |name|
          headers = OFX::Parser.const_get(name).parse_headers(header)
          break if headers
        end

        headers
      end

      def condition_body(body)
        body.gsub!(/>\s+</m, "><")
        body.gsub!(/\s+</m, "<")
        body.gsub!(/>\s+/m, ">")
        body.gsub!(/<(\w+?)>([^<]+)/m, '<\1>\2</\1>')
      end

      def utf8_converter(string)
        return string if Kconv.isutf8(string)
        Iconv.conv("UTF-8", "LATIN1//IGNORE", string)
      end
    end
  end
end
