import requests
import json
import webhook


with open('./cert/key.json') as f:
  cert_keys = json.load(f)

webhook.delete(cert_keys['auth'], cert_keys['task'], "自動打刻<Task>")