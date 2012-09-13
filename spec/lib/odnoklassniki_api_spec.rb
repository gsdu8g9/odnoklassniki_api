# encoding: utf-8
require 'spec_helper'

describe OdnoklassnikiAPI do

  let(:application_key) {'application_key'}
  let(:secret_key) {'secret_key'}
  let(:access_token) {'csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx'}
  let(:url) {"http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&method=friends.get&application_key=application_key&sig=92cd12074a5d377e1e71fa2ff12f5f43"}
  let(:error_url) {"http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&method=frien.get&application_key=application_key&sig=5627bfd402b647ca4843468eb69691eb"}

  before do
    @client = OdnoklassnikiAPI.new({:application_key => application_key, :secret_key =>secret_key, :access_token =>access_token})
  end

  describe "#test sending get request" do

    let(:normal_response) {'["CAAAAAAAAAAAAAAA","GGAAAAAAAAAAAAAA"]'}
    let(:app_error_response) {'{"error_code":101,"error_msg":"PARAM_API_KEY : Application not exist"}'}
    let(:no_method_response) {'3:METHOD : Method frien.get not found'}

    it "should return users friends ids from get request" do
      stub_get_request(url, normal_response, 'application/json')
      result = @client.get 'friends.get'

      result.should == JSON.parse(normal_response)
    end

    it "should return json if friends get request is invalid" do
      stub_get_request(url, app_error_response, 'application/json')
      result = @client.get 'friends.get'

      result.should == JSON.parse(app_error_response)
    end

    it "should return parsing error if response is not json" do
      stub_get_request(error_url, no_method_response, 'text/html')
      result = @client.get 'frien.get'

      result.should == OdnoklassnikiAPI::Error::ParsingError
    end

  end
end