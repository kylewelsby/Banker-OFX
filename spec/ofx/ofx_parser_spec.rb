require "spec_helper"

describe OFX::Parser do
  let(:file) { "spec/fixtures/sample.ofx" }
  let(:ofx) { OFX::Parser::Base.new(file) }

  it { ofx.should respond_to(:headers) }
  it { ofx.should respond_to(:body) }
  it { ofx.should respond_to(:content) }
  it { ofx.should respond_to(:parser) }

  context 'file path' do
    it { ofx.content.should_not be_nil }
  end

  context 'file handler' do
    let(:file) { open("spec/fixtures/sample.ofx") }

    subject { ofx.content }

    it { subject.should_not be_nil }
  end

  context 'file context' do
    let(:file) { open("spec/fixtures/sample.ofx").read }

    subject { ofx.content }

    it { subject.should_not be_nil }
  end

  context 'content' do
    subject { ofx.content }

    it "set content" do
      subject.should eql(open("spec/fixtures/sample.ofx").read)
    end
  end

  context 'body' do
    subject { ofx.body }

    it "set body" do
      subject.should_not be_nil
    end
  end

  context 'encoding' do
    let(:file) { "spec/fixtures/utf8.ofx" }

    subject { ofx.content }

    it "work with UTF8 and Latin1 encodings" do
      subject.should eql(open("spec/fixtures/utf8.ofx", "r:iso-8859-1:utf-8").read)
    end
  end

  context 'error handing' do
    context 'invalid ofx' do
      let(:file) { "spec/fixtures/invalid_version.ofx" }

      it "raise exception when trying to parse an unsupported OFX version" do
        lambda { ofx }.should raise_error(OFX::UnsupportedFileError)
      end
    end

    context 'invalid file type' do
      let(:file) { "spec/fixtures/avatar.gif" }

      it "raise exception when trying to parse an unsupported OFX version" do
        lambda { ofx }.should raise_error(OFX::UnsupportedFileError)
      end
    end
  end

  describe "headers" do

    subject { ofx.headers }

    context 'should have' do
      it { subject["OFXHEADER"].should eql("100") }
      it { subject["DATA"].should eql("OFXSGML") }
      it { subject["VERSION"].should eql("102") }
      it { subject.should have_key("SECURITY") }
      it { subject["SECURITY"].should be_nil }
      it { subject["ENCODING"].should eql("USASCII") }
      it { subject["CHARSET"].should eql("1252") }
      it { subject.should have_key("COMPRESSION") }
      it { subject["COMPRESSION"].should be_nil }
      it { subject.should have_key("OLDFILEUID") }
      it { subject["OLDFILEUID"].should be_nil }
      it { subject.should have_key("NEWFILEUID") }
      it { subject["NEWFILEUID"].should be_nil }
    end

    context 'CR LF Headers' do
      let(:file) { ofx_with_carriage_return }

      it "should parse headers with CR and without LF" do
        subject.size.should eql(9)
      end

      def ofx_with_carriage_return
        header = %{OFXHEADER:100\rDATA:OFXSGML\rVERSION:102\rSECURITY:NONE\rENCODING:USASCII\rCHARSET:1252\rCOMPRESSION:NONE\rOLDFILEUID:NONE\rNEWFILEUID:NONE\r}
        body   = open("spec/fixtures/sample.ofx").read.split(/<OFX>/, 2)[1]
        header + "<OFX>" + body
      end
    end
  end
end
