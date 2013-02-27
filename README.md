# odnoklassniki_api

Гем помогает работать с REST API сервиса odnoklassniki.ru


```ruby
options = {
	application_key: 'YOUR_PUBLIC_KEY',		# Публичный ключ приложения, не путать с ID преложения.
	secret_key: 'YOUR_SECRET_KEY', 			# Секретный ключ приложения, нужен для подписи параметров.
	access_token: 'USERS_ACCESS_TOKEN'      # Ключь доступа к данным конкретного пользователя. Обычно временный.
}


client = OdnoklassnikiAPI.new options
client.get 'users.getInfo', someParam: true   # Запрос к API.

```