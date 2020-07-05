from trello import TrelloClient
import json
from datetime import datetime
import os
import base64

import trevent as te

def lambda_handler(event, context):
  # Trello Client
  client = TrelloClient(
    api_key=os.environ["trello_api_key"],
    api_secret=os.environ["trello_token"]
  )

  try:
    # イベント管理クラス
    tr_event = te.TrelloEvent(event)

    target_card = client.get_card(tr_event.get_card_id())
    list_before = tr_event.get_list_before_name()
    list_after = tr_event.get_list_after_name()
    if "ToDo" in list_before and "Doing" in list_after:
      target_card.comment(list_before + "->" + list_after + 
      "\n開始時間：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
    if "Doing" in list_before:
      if "ToDo" in list_after:
        target_card.comment(list_before + "->" + list_after + 
        "\n中断時間：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
      elif "Done" in list_after:
        target_card.comment(list_before + "->" + list_after + 
        "\n完了時間：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
  except Exception as e:    
    return {
      'isBase64Encoded': False,
      'statusCode': 200,
      'headers': {},
      'body': f'{{"message": "{e}"}}'
    }

  return {
    'isBase64Encoded': False,
    'statusCode': 200,
    'headers': {},
    'body': '{"message": "Succeed: Normal Exit"}'
  }