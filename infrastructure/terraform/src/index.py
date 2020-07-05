from trello import TrelloClient
import json
from datetime import datetime, timedelta
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
    board = client.get_board(os.environ["trello_board_id"])
    dic_label = {}
    for label in board.get_labels():
      dic_label[label.name] = label
    target_comments = ["開始時間", "中断時間", "完了時間"]
    delta_time = timedelta()
    tmp_time = datetime(year=2000, month=6, day=15)
    # イベント管理クラス
    tr_event = te.TrelloEvent(event)
    # 自動打刻
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
        # 2H超えのタスクにタグをつける
        for c in target_card.get_comments():
          for tg_c in target_comments:
            if tg_c in c["data"]["text"]:
              break
          else:
            continue
          comment = c['data']['text'].split('\n')[1].split('：')
          if "開始時間" in comment[0]:
            delta_time += (tmp_time - datetime.strptime(comment[1], '%Y/%m/%d %H:%M:%S'))
          else:
            delta_time -= (tmp_time - datetime.strptime(comment[1], '%Y/%m/%d %H:%M:%S'))
        if delta_time > timedelta(hours=2):
          target_card.add_label(dic_label["2H"])

  except Exception as e:
    # target_card.comment(f"{e}")
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