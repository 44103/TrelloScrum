import requests
import json
import webhook


with open('./cert/key.json') as f:
  cert_keys = json.load(f)

webhook.update(cert_keys['auth'], cert_keys['story'], "自動打刻<Story>")