from trello import TrelloClient
import json
from datetime import datetime
import os
import base64

def lambda_handler(event, context):
  # trello client
  client = TrelloClient(
    api_key=os.environ["trello_api_key"],
    api_secret=os.environ["trello_token"]
  )

  board = client.get_board(os.environ["trello_board_id"])
  cards = board.get_cards()

  # some_list = board.all_lists()[0]
  # new_card = some_list.add_card("Debug Card")
  # new_card.comment(f"{event}")

  if "httpMethod" in event:
    if "HEAD" == event["httpMethod"]:
      return {
        'statusCode': 200,
        'body': '{"message": "Succeed: Create Trello API"}'
      }
    elif "PUT" == event["httpMethod"]:
      return {
        'statusCode': 200,
        'body': '{"message": "Succeed: Update Trello API"}'
      }

  event_body = json.loads(base64.b64decode(event["body"]).decode())

  exitflag = False
  exitflag = len(cards) > 3
  exitflag = "action_move_card_from_list_to_list" not in event_body["action"]["display"]["translationKey"]
  if exitflag:
    return {
      'isBase64Encoded': False,
      'statusCode': 200,
      'headers': {},
      'body': '{"message": "Hello from AWS Lambda"}'
    }

  # list_ids = {}
  # for l in board.all_lists():
  #     list_ids[l.name] = l.id
  # list_todo = board.get_list(list_ids["ToDo"])

  # new_card = list_todo.add_card("APIで作ったカード", "詳細")
  # new_card.comment("開始時間" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
  # new_card.comment("Arg:event" + str(event))
  try:
    target_card = client.get_card(event_body["action"]["display"]["entities"]["card"]["id"])
    list_before = event_body["action"]["display"]["entities"]["listBefore"]["text"]
    list_after = event_body["action"]["display"]["entities"]["listAfter"]["text"]
    # target_card.comment(list_before + "->" + list_after)
    if "ToDo" in list_before and "Doing" in list_after:
      target_card.comment(list_before + "->" + list_after + "\n開始時間：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
    if "Doing" in list_before:
      if "ToDo" in list_after:
        target_card.comment(list_before + "->" + list_after + "\n中断時間：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
      elif "Done" in list_after:
        target_card.comment(list_before + "->" + list_after + "\n完了時間：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
  except Exception as e:
    new_card.comment(str(e))

  return {
    'isBase64Encoded': False,
    'statusCode': 200,
    'headers': {},
    'body': '{"message": "Hello from AWS Lambda"}'
  }