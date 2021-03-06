# This code sample uses the 'requests' library:
# http://docs.python-requests.org
import requests
import json

with open('./cert/key.json') as f:
  cert_keys = json.load(f)

url = "https://api.trello.com/1/webhooks/" + cert_keys["api_id"]

headers = {
   "Accept": "application/json"
}

query = {
   'key': cert_keys["api_key"],
   'token': cert_keys["token"],
   # 'callbackURL': cert_keys["callback_url"],
   'description': '自動依頼'
}

response = requests.request(
   "PUT",
   url,
   headers=headers,
   params=query
)

print(json.dumps(json.loads(response.text), sort_keys=True, indent=4, separators=(",", ": ")))