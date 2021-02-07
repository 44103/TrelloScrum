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

def get_list(board, name):
  # 対象のリストを取得
  for l in board.all_lists():
    if name in l.name:
      return l
  return None

def lambda_handler(event, context):
  # Trello Client
  client = TrelloClient(
    api_key=os.environ["trello_api_key"],
    api_secret=os.environ["trello_token"]
  )

  try:
    # イベント管理クラス
    # tr_event = te.TrelloEvent(event)
    # デバッグ用
    # target_card = client.get_card(tr_event.get_card_id())
    task_board = client.get_board(os.environ["trello_task_board_id"])

    # 対象のリストを取得
    doing_list = get_list(task_board, "Doing")

    for card in doing_list.list_cards():
      todo_list = get_list(task_board, card.labels[0].name)
      card.change_list(todo_list.id)

  except Exception as e:
    # デバッグ用
    # target_card.comment(f"{e}")
    return return_context(f"{e}")

  return return_context("Succeed: Normal Exit")
