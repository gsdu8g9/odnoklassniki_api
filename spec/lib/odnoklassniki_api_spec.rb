# encoding: utf-8
require 'spec_helper'

describe OdnoklassnikiAPI do

  let(:application_key) {'AAAIMMHGABABABABA'}
  let(:secret_key) {'9999739F2796E9505B8E1BA7'}
  let(:access_token) {'csipa.21-01avr1u8i06g3p4i22222e3k1fbd'}
  let(:url) {"http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-01avr1u8i06g3p4i22222e3k1fbd&method=friends.get&application_key=AAAIMMHGABABABABA&sig=215cd3fff5026220bb8b3db8617e714f"}
  let(:error_url) {"http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-01avr1u8i06g3p4i22222e3k1fbd&method=frien.get&application_key=AAAIMMHGABABABABA&sig=97270099c3a6ee65374e6599add7be21"}

  before do
    @client = OdnoklassnikiAPI.new({:application_key => application_key, :secret_key =>secret_key})
  end

  describe "#test sending get request" do

    let(:normal_response) {'["CAAAAAAAAAAAAAAA","GGAAAAAAAAAAAAAA"]'}
    let(:app_error_response) {'{"error_code":101,"error_msg":"PARAM_API_KEY : Application not exist"}'}
    let(:no_method_response) {'3:METHOD : Method frien.get not found'}

    it "should return users friends ids from get request" do
      stub_get_request(url, normal_response, 'application/json')
      result = @client.get 'friends.get', {:access_token => access_token}

      result.should == JSON.parse(normal_response)
    end

    it "should return json if friends get request is invalid" do
      stub_get_request(url, app_error_response, 'application/json')
      result = @client.get 'friends.get', {:access_token => access_token}

      result.should == JSON.parse(app_error_response)
    end

    it "should return parsing error if response is not json" do
      stub_get_request(error_url, no_method_response, 'text/html')
      result = @client.get 'frien.get', {:access_token => access_token}

      result.should == OdnoklassnikiAPI::Error::ParsingError
    end

  end
end