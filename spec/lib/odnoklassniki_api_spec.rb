# encoding: utf-8
require 'spec_helper'

describe OdnoklassnikiAPI do

  let(:application_key) { 'application_key' }
  let(:secret_key) { 'secret_key' }
  let(:access_token) { 'csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx' }
  let(:url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&method=friends.get&application_key=application_key&sig=92cd12074a5d377e1e71fa2ff12f5f43" }
  let(:error_url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&method=frien.get&application_key=application_key&sig=5627bfd402b647ca4843468eb69691eb" }
  let(:photo_url) {"http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&aid=1946947353&application_key=application_key&method=photos.getUserAlbumPhotos&sig=2cae57a1da7b212ca20f78428f20b357"}
  let(:auth_touch_url) {"http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&application_key=application_key&method=auth.touchSession&sig=2ef489a1c88398b88f1dab0d9d7dd883"}
  let(:next_data_url){"http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&aid=1946947353&application_key=application_key&method=photos.getUserAlbumPhotos&pagingAnchor=LTMyMTY3NzExMzotNzk5MDk5NDU=&sig=0860d4a85ca615e55158ab8105e1a917"}


  describe "#test client initialization" do

    it "should return API Client with symbol initial params" do
      client = OdnoklassnikiAPI.new({:application_key => application_key, :secret_key => secret_key, :access_token => access_token})
      client.application_key.should == application_key
    end

    it "should return API Client with string initial params" do
      client = OdnoklassnikiAPI.new({"application_key" => application_key, "secret_key" =>secret_key, "access_token" =>access_token})
      client::application_key.should == application_key
    end
  end

  describe "#test sending get request" do
    before do
      @client = OdnoklassnikiAPI.new({"application_key" => application_key, "secret_key" =>secret_key, "access_token" =>access_token})
    end

    let(:normal_response) { '["CAAAAAAAAAAAAAAA","GGAAAAAAAAAAAAAA"]' }
    let(:boolean_response) { "true" }
    let(:app_error_response) { '{"error_code":101,"error_msg":"PARAM_API_KEY : Application not exist"}' }
    let(:no_method_response) { '3:METHOD : Method frien.get not found' }
    let(:has_more_response) {'{"photos": [ {  "fid":"1675836441",      "caption":"XXXXXXXXXXx...",      "location":null,      "standard_url":"http://devserv.odnoklassniki.ru:8000/getImage?photoId=1675836441&photoType=0",      "preview_url":"http://odnoklassniki.ru?photoId=1675836441&photoType=2",      "mark_count":29,      "mark_bonus_count":4,      "mark_avg":"5+"     }, { "fid":"1946947353",      "caption":"Yyyyyyyyyyyyy",      "location":null,      "standard_url":"http://devserv.odnoklassniki.ru:8000/getImage?photoId=1946947353&photoType=0",      "preview_url":"http://odnoklassniki.ru?photoId=1946947353&photoType=2",      "mark_count":1,      "mark_bonus_count":0,      "mark_avg":"5.00"     }], "hasMore":true, "pagingAnchor":"LTMyMTY3NzExMzotNzk5MDk5NDU=", "totalCount" : 5}'}
    let(:photo_response) {'{"photos":[{  "fid":"1675836441",      "caption":"XXXXXXXXXXx...",      "location":null,      "standard_url":"http://devserv.odnoklassniki.ru:8000/getImage?photoId=1675836441&photoType=0",      "preview_url":"http://odnoklassniki.ru?photoId=1675836441&photoType=2",      "mark_count":29,      "mark_bonus_count":4,      "mark_avg":"5+"     }, { "fid":"1946947353",      "caption":"Yyyyyyyyyyyyy",      "location":null,      "standard_url":"http://devserv.odnoklassniki.ru:8000/getImage?photoId=1946947353&photoType=0",      "preview_url":"http://odnoklassniki.ru?photoId=1946947353&photoType=2",      "mark_count":1,      "mark_bonus_count":0,      "mark_avg":"5.00"     }], "totalCount" : 5}'}

    it "should return users friends ids from get request" do
      stub_get_request(url, normal_response, 'application/json')
      result = @client.get 'friends.get'

      result.should == JSON.parse(normal_response)
    end

    it "should return json if friends get request is invalid" do
      stub_get_request(url, app_error_response, 'application/json')
      result = @client.get 'friends.get'

      result.should == OdnoklassnikiAPI::Error::ParamApiKeyError
    end

    it "should return parsing error if response is not json" do
      stub_get_request(error_url, no_method_response, 'text/html')

      expect {@client.get 'frien.get'}.to raise_error(OdnoklassnikiAPI::Error::ParsingError)
    end

    it "should return nil when calling next_page on error response" do
      stub_get_request(url, app_error_response, 'application/json')
      result = @client.get 'friends.get'

      @client.get_next_page(result).should == nil
    end

    it "should return nil when calling next_page on response with no hasMore" do
      stub_get_request(url, normal_response, 'application/json')
      result = @client.get 'friends.get'

      @client.get_next_page(result).should == nil
    end

    it "should not return nil when calling next_page on response with hasMore" do
      stub_get_request(photo_url, has_more_response, 'application/json')
      stub_get_request(next_data_url, photo_response, 'application/json')

      result = @client.get 'photos.getUserAlbumPhotos', {:aid => 1946947353}
      @client.get_next_page(result).should_not == nil
    end

    it "should return boolean if response" do
      stub_get_request(auth_touch_url, boolean_response, 'application/json')

      result = @client.get 'auth.touchSession'
      result.should == true
    end

  end

end