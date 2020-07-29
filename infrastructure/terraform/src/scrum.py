import singleton as sg
import os
from datetime import datetime, timedelta
# from collections import defaultdict
import random as rand

class Scrum(sg.Singleton):
  def __init__(self, client, trevent):
    self.client = client
    self.tr_event = trevent
    self.main_board = client.get_board(os.environ["trello_main_board_id"])
    self.sub_board = client.get_board(os.environ["trello_sub_board_id"])
    self.card = client.get_card(self.tr_event.get_card_id())
    self.labels = {}
    for label in self.main_board.get_labels():
      self.labels[label.name] = label

  def request_slack(self):
    # POレビュー依頼
    import slackweb

    slack = slackweb.Slack(url=os.environ["slack_webhook_url"])
    list_after = self.tr_event.get_list_after_name()

    attachments = [
      {
        "color": "#2eb886",
        "title": f"ストーリー「{self.card.name}」",
        "title_link": f"{self.card.url}",
        "text": "がDoneになりました。お手すきの際にPOレビューお願いします。"
      }
    ]

    if "Done" in list_after:
      slack.notify(text=f"<@{os.environ['slack_mention']}>", attachments=attachments)

  def stamping(self, is_story=False):
    # 自動打刻
    list_before = self.tr_event.get_list_before_name()
    list_after = self.tr_event.get_list_after_name()

    ts_comment =  self.__get_time_stamp_comment()
    now_time = datetime.now()
    summary = ""
    if "ToDo" in list_before and "Doing" in list_after:
      summary = ">**再開**" if ts_comment else "\n**開始時間**"
    if "Doing" in list_before:
      if "ToDo" in list_after:
        summary = ">**中断**"
      elif "Done" in list_after:
        summary = "**完了時間**"
    if not summary:
      return

    message = f"{summary}：" + now_time.strftime("%Y/%m/%d %H:%M:%S")
    indent_flag = 0

    if ts_comment:
      text = ts_comment["data"]["text"]
      message += '\n' + text

      self.card.update_comment(ts_comment["id"], message)
      if "再開" in summary:
        return
      # 中断・完了時に経過時間を記載
      elapsed_time = self.__calc_elapsed_time()
      if "経過" not in message:
        message += f"\n---\n**経過時間**：{elapsed_time}"
      else:
        message_split = message.split('\n')
        message_split[-1] = f"**経過時間**：{elapsed_time}"
        message = '\n'.join(message_split)

      self.card.update_comment(ts_comment["id"], message)
      if not is_story:
        self.__labeling_2h(elapsed_time)
    else:
      self.card.comment(message)

  def __labeling_2h(self, elapsed_time):
    # 2H超えのタスクにラベルをつける
    # 既にラベルが付いているものは除く
    if self.card.labels:
      for label in self.card.labels:
        if "2H" in label.name:
          return

    if elapsed_time > timedelta(hours=2):
      self.card.add_label(self.labels["2H"])

  def __calc_elapsed_time(self):
    # 経過時間の計算
    elapsed_time = timedelta()
    tmp_time = datetime(year=2000, month=6, day=15)

    ts_comment =  self.__get_time_stamp_comment()
    if not ts_comment:
      return elapsed_time

    for line in ts_comment["data"]["text"].split('\n'):
      if "経過" in line:
        continue
      context = line.split('：')
      if len(context) == 1:
        continue
      past_time = datetime.strptime(context[1], '%Y/%m/%d %H:%M:%S')
      if "開始" in context[0] or "再開" in context[0]:
        elapsed_time += (tmp_time - past_time)
      else:
        elapsed_time -= (tmp_time - past_time)

    return elapsed_time

  def __get_time_stamp_comment(self):
    for comment in self.card.get_comments():
      if "**開始時間**" in comment["data"]["text"]:
        return comment
    return None

  def move_story_to_task(self):
    # Story内容をTaskにコピー
    list_before = self.tr_event.get_list_before_name()
    list_after = self.tr_event.get_list_after_name()

    if not ("Backlog" in list_before and "ToDo" in list_after):
      return

    list_story = False
    for l in self.sub_board.all_lists():
      if "Story" in l.name:
        list_story = l

    if not list_story:
      raise Exception("Not Exist: Story List in Task Board")

    colors = ["green", "yellow", "orange", "red", "purple", "blue"]
    new_label = self.sub_board.add_label(self.card.name, rand.choice(colors))
    list_story.add_card(self.card.name, self.card.description, [new_label])
