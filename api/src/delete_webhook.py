# This code sample uses the 'requests' library:
# http://docs.python-requests.org
import requests
import json

with open('./cert/key.json') as f:
  cert_keys = json.load(f)


url = "https://api.trello.com/1/webhooks/" + cert_keys["api_id"]

query = {
   'key': cert_keys["api_key"],
   'token': cert_keys["token"]
}

response = requests.request(
   "DELETE",
   url,
   params=query
)

print(response.text)