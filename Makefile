
lint:
	rubocop -A

gen_app_private_key:
	openssl genpkey -algorithm RSA -out private_key.pem

gen_app_public_key:
	 openssl rsa -pubout -in private_key.pem -out public_key.pem