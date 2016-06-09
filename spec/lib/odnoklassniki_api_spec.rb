# encoding: utf-8
require 'spec_helper'

describe OdnoklassnikiAPI do

  let(:application_key) { 'application_key' }
  let(:secret_key) { 'secret_key' }
  let(:access_token) { 'csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx' }
  let(:url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&method=friends.get&application_key=application_key&sig=92cd12074a5d377e1e71fa2ff12f5f43" }
  let(:error_url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&method=frien.get&application_key=application_key&sig=5627bfd402b647ca4843468eb69691eb" }
  let(:old_photo_url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&aid=1946947353&application_key=application_key&method=photos.getUserAlbumPhotos&sig=2cae57a1da7b212ca20f78428f20b357" }
  let(:new_photo_url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&aid=1946947353&application_key=application_key&method=photos.getPhotos&sig=a035bfab51808e9509c1d0a9b4fdb277" }
  let(:auth_touch_url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&application_key=application_key&method=auth.touchSession&sig=2ef489a1c88398b88f1dab0d9d7dd883" }
  let(:next_old_photo_url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&aid=1946947353&application_key=application_key&method=photos.getUserAlbumPhotos&pagingAnchor=LTMyMTY3NzExMzotNzk5MDk5NDU=&sig=0860d4a85ca615e55158ab8105e1a917" }
  let(:next_new_photo_url) { "http://api.odnoklassniki.ru/fb.do?access_token=csipa.21-xxxxxxxxxxxxxxxxxxxxxxxxxxxx&aid=1946947353&application_key=application_key&method=photos.getPhotos&anchor=LTMyMTY3NzExMzotNzk5MDk5NDU=&sig=6558377511ed8f206e69729e76794c64" }

  context "проверка инициализации клиента" do
    it "должен проинициализировать клиент по symbol-ключам" do
      client = OdnoklassnikiAPI.new({application_key: application_key, secret_key: secret_key, access_token: access_token})
      expect(client::application_key).to eq application_key
    end

    it "должен проинициализировать клиент по string-ключам" do
      client = OdnoklassnikiAPI.new({"application_key" => application_key, "secret_key" => secret_key, "access_token" => access_token})
      expect(client::application_key).to eq application_key
    end
  end

  context "проверка работоспособности get-запросов" do
    let(:normal_response) { '["CAAAAAAAAAAAAAAA","GGAAAAAAAAAAAAAA"]' }
    let(:boolean_response) { true }
    let(:app_error_response) { '{"error_code":101,"error_msg":"PARAM_API_KEY : Application not exist"}' }
    let(:no_method_response) { '3:METHOD : Method frien.get not found' }
    let(:has_more_response_old) { '{"photos": [ {  "fid":"1675836441",      "caption":"XXXXXXXXXXx...",      "location":null,      "standard_url":"http://devserv.odnoklassniki.ru:8000/getImage?photoId=1675836441&photoType=0",      "preview_url":"http://odnoklassniki.ru?photoId=1675836441&photoType=2",      "mark_count":29,      "mark_bonus_count":4,      "mark_avg":"5+"     }, { "fid":"1946947353",      "caption":"Yyyyyyyyyyyyy",      "location":null,      "standard_url":"http://devserv.odnoklassniki.ru:8000/getImage?photoId=1946947353&photoType=0",      "preview_url":"http://odnoklassniki.ru?photoId=1946947353&photoType=2",      "mark_count":1,      "mark_bonus_count":0,      "mark_avg":"5.00"     }], "hasMore":true, "pagingAnchor":"LTMyMTY3NzExMzotNzk5MDk5NDU=", "totalCount" : 5}' }
    let(:has_more_response_new) { '{"photos": [ {  "id":"482208139008", "album_id":"481556811520", "pic50x50":"http://albumava1.odnoklassniki.ru/getImage?photoId=482208139008&photoType=4", "pic128x128":"http://ia100.odnoklassniki.ru/getImage?photoId=482208139008&photoType=2", "pic640x480":"http://ia100.odnoklassniki.ru/getImage?photoId=482208139008&photoType=0", "comments_count":0, "user_id":"558658883072", "mark_count":1, "mark_bonus_count":0, "mark_avg":"5.00" }], "hasMore":true, "anchor":"LTMyMTY3NzExMzotNzk5MDk5NDU=", "totalCount" : 5}' }
    let(:has_more_response_without_anchor) { '{"photos": [ {  "id":"482208139008", "album_id":"481556811520", "pic50x50":"http://albumava1.odnoklassniki.ru/getImage?photoId=482208139008&photoType=4", "pic128x128":"http://ia100.odnoklassniki.ru/getImage?photoId=482208139008&photoType=2", "pic640x480":"http://ia100.odnoklassniki.ru/getImage?photoId=482208139008&photoType=0", "comments_count":0, "user_id":"558658883072", "mark_count":1, "mark_bonus_count":0, "mark_avg":"5.00" }], "hasMore":true, "totalCount" : 5}' }
    let(:old_photo_response) { '{"photos":[{  "fid":"1675836441",      "caption":"XXXXXXXXXXx...",      "location":null,      "standard_url":"http://devserv.odnoklassniki.ru:8000/getImage?photoId=1675836441&photoType=0",      "preview_url":"http://odnoklassniki.ru?photoId=1675836441&photoType=2",      "mark_count":29,      "mark_bonus_count":4,      "mark_avg":"5+"     }, { "fid":"1946947353",      "caption":"Yyyyyyyyyyyyy",      "location":null,      "standard_url":"http://devserv.odnoklassniki.ru:8000/getImage?photoId=1946947353&photoType=0",      "preview_url":"http://odnoklassniki.ru?photoId=1946947353&photoType=2",      "mark_count":1,      "mark_bonus_count":0,      "mark_avg":"5.00"     }], "totalCount" : 5}' }
    let(:new_photo_response) { '{"photos":[{ "id":"482208139008", "album_id":"481556811520", "pic50x50":"http://albumava1.odnoklassniki.ru/getImage?photoId=482208139008&photoType=4", "pic128x128":"http://ia100.odnoklassniki.ru/getImage?photoId=482208139008&photoType=2", "pic640x480":"http://ia100.odnoklassniki.ru/getImage?photoId=482208139008&photoType=0", "comments_count":0, "user_id":"558658883072", "mark_count":1, "mark_bonus_count":0, "mark_avg":"5.00" }], "totalCount" : 5}' }
    let(:client) { OdnoklassnikiAPI.new({"application_key" => application_key, "secret_key" => secret_key, "access_token" => access_token}) }

    it "должен вернуть список id друзей пользователя" do
      stub_get_request(url, normal_response, 'application/json')
      result = client.get 'friends.get'
      expect(result.response).to eq JSON.parse(normal_response)
    end

    it "должен бросить OdnoklassnikiAPI::Error::ParamApiKeyError в случае ошибки со стороны API" do
      stub_get_request(url, app_error_response, 'application/json')
      expect { client.get('friends.get') }.to raise_error(OdnoklassnikiAPI::Error::ParamApiKeyError)
    end

    it "должен бросить OdnoklassnikiAPI::Error::ParsingError в случае ошибки запроса" do
      stub_get_request(error_url, no_method_response, 'text/html')
      expect { client.get('frien.get') }.to raise_error(OdnoklassnikiAPI::Error::ParsingError)
    end

    it "должен бросить TimeoutError" do
      stub_request(:get, url).to_timeout
      expect { client.get('friends.get') }.to raise_error(OdnoklassnikiAPI::Error::TimeoutError)
    end

    it "должен бросить WrongStatusError при ошибке 500" do
      stub_request(:get, url).to_return(status: 500)
      expect { client.get('friends.get') }.to raise_error(OdnoklassnikiAPI::Error::WrongStatusError)
    end

    it "должен бросить ошибку просроченной сессии" do
      stub_get_request(url, {"error_code" => 102}, 'application/json') # 102 = Session Expired
      expect { client.get('friends.get') }.to raise_error(OdnoklassnikiAPI::Error::ParamSessionExpiredError)
    end

    it "должен трижды попытаться выполнить new и бросить TimeoutError" do
      stub_request(:get, url).to_return(status: 200)
      OdnoklassnikiAPI::Response.should_receive(:new).exactly(3).times { raise Errno::ETIMEDOUT }
      expect { client.get('friends.get') }.to raise_error(OdnoklassnikiAPI::Error::TimeoutError)
    end

    it "Должен вернуть true если response существует" do
      stub_get_request(auth_touch_url, boolean_response, 'application/json')
      result = client.get('auth.touchSession')
      expect(result.response).to be_true
    end

    describe '.next_page' do
      context 'старый вариант anchor' do
        it "должен вернуть nil если hasMore в ответе отсутствует" do
          stub_get_request(url, normal_response, 'application/json')
          result = client.get('friends.get')
          expect(result.next_page).to be_nil
        end

        it "должен вернуть следующую 'страницу' пагинации, если в ответе был ключ hasMore" do
          stub_get_request(old_photo_url, has_more_response_old, 'application/json')
          stub_get_request(next_old_photo_url, old_photo_response, 'application/json')

          result = client.get('photos.getUserAlbumPhotos', {aid: 1946947353})
          expect(result.next_page.response).to eq JSON.parse(old_photo_response)
        end
      end
      context 'новый вариант anchor' do
        it "должен вернуть следующую 'страницу' пагинации, если в ответе был ключ hasMore" do
          stub_get_request(new_photo_url, has_more_response_new, 'application/json')
          stub_get_request(next_new_photo_url, new_photo_response, 'application/json')

          result = client.get('photos.getPhotos', {aid: 1946947353})
          expect(result.next_page.response).to eq JSON.parse(new_photo_response)
        end
      end
      context 'когда anchor или pagingAnchor отсутствует, но hasMore есть' do
        it 'должен вернуть nil, если попытаться запросить следующую страницу без валидного anchor или pagingAnchor' do
          stub_get_request(new_photo_url, has_more_response_without_anchor, 'application/json')

          result = client.get('photos.getPhotos', {aid: 1946947353})
          expect(result.next_page).to be_nil
        end
      end
    end

  end
end
