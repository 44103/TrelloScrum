from trello import TrelloClient
import os
import sys
import traceback

import trevent as te
import scrum as sc

def return_context(message):
  return {
    'isBase64Encoded': False,
    'statusCode': 200,
    'headers': {},
    'body': f'{{"message": "{message}"}}'
  }

def lambda_handler(event, context):
  # Trello Client
  client = TrelloClient(
    api_key=os.environ["trello_api_key"],
    api_secret=os.environ["trello_token"]
  )

  try:
    # イベント管理クラス
    tr_event = te.TrelloEvent(event)
    # デバッグ用
    # target_card = client.get_card(tr_event.get_card_id())
    # Scrumに必要な作業を管理
    scrum = sc.Scrum(client, tr_event, os.environ["trello_story_board_id"], os.environ["trello_task_board_id")
    scrum.stamping(True)
    scrum.request_slack()
    scrum.move_story_to_task()

  except Exception as e:
    # デバッグ用
    t, v, tb = sys.exc_info()
    # target_card.comment(f"{e}\n{'>'.join(traceback.format_tb(tb))}")
    return return_context(f"{e}\n{traceback.format_tb(tb)}")

  return return_context("Succeed: Normal Exit")
