from trello import TrelloClient
import os

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
    scrum = sc.Scrum(client, tr_event)
    scrum.stamping()
    # scrum.request_slack()

  except Exception as e:
    # デバッグ用
    # target_card.comment(f"{e}")
    return return_context(f"{e}")

  return return_context("Succeed: Normal Exit")