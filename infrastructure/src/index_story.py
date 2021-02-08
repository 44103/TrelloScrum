from trello import TrelloClient
import os
import sys
import traceback
import logging

import trevent as te
import scrum as sc

logger = logging.getLogger()
logger.setLevel(logging.INFO)

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
    # Scrumに必要な作業を管理
    scrum = sc.Scrum(client, tr_event, os.environ["trello_story_board_id"], os.environ["trello_task_board_id"])
    scrum.stamping(True)
    scrum.request_slack()
    scrum.move_story_to_task()

  except Exception as e:
    # デバッグ用
    t, v, tb = sys.exc_info()
    logger.error(f"{e}: {tb}")
    return return_context(f"{e}")

  return return_context("Succeed: Normal Exit")
