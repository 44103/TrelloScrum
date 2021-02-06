import requests
import json

def print_json(text):
  print(json.dumps(json.loads(text), sort_keys=True, indent=4, separators=(",", ": ")))


headers = {
  "Accept": "application/json"
}

url = "https://api.trello.com/1/webhooks/"

def create(auth, config, description):
  query = {
    'key': auth['api_key'],
    'token': auth['token'],
    'callbackURL': config['callback_url'],
    'idModel': config['board_id'],
    'description': description
  }

  response = requests.request(
    "POST",
    url,
    headers=headers,
    params=query
  )

  print_json(response.text)


def update(auth, config, description):
  query = {
    'key': auth['api_key'],
    'token': auth['token'],
    'callbackURL': config['callback_url'],
    'description': description
  }

  response = requests.request(
    "PUT",
    url + config['webhook_id'],
    headers=headers,
    params=query
  )

  print_json(response.text)


def delete(auth, config, description):
  query = {
    'key': auth['api_key'],
    'token': auth['token']
  }

  response = requests.request(
    "DELETE",
    url + config['webhook_id'],
    params=query
  )

  print_json(response.text)
