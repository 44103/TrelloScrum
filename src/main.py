from trello import TrelloClient
import json

with open('../cert/key.json') as f:
  cert_keys = json.load(f)

client = TrelloClient(
  api_key=cert_keys["api_key"],
  api_secret=cert_keys["token"]
)

board = client.get_board(cert_keys["board_id"])
cards = board.get_cards()

for card in cards:
  print(card.name)
  print(card.desc)