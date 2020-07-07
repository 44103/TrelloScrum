import singleton as sg
import os
from datetime import datetime, timedelta

class Scrum(sg.Singleton):
  target_comments = ["開始時間", "中断時間", "完了時間"]
  def __init__(self, client, trevent):
    self.tr_event = trevent
    self.board = client.get_board(os.environ["trello_board_id"])
    self.card = client.get_card(self.tr_event.get_card_id())
    self.labels = {}
    for label in self.board.get_labels():
      self.labels[label.name] = label

  def request_slack(self):
    # POレビュー依頼
    import slackweb

    slack = slackweb.Slack(url=os.environ["slack_url"])
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
      slack.notify(text="<@kyoshitomi>", attachments=attachments)

  def stamping(self):
    # 自動打刻
    list_before = self.tr_event.get_list_before_name()
    list_after = self.tr_event.get_list_after_name()

    if "ToDo" in list_before and "Doing" in list_after:
      self.card.comment("**開始時間**：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
    if "Doing" in list_before:
      if "ToDo" in list_after:
        self.card.comment("**中断時間**：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
      elif "Done" in list_after:
        self.card.comment("**完了時間**：" + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))

      self.__labeling_2h()

  def __labeling_2h(self):
    # 2H超えのタスクにラベルをつける
    delta_time = timedelta()
    tmp_time = datetime(year=2000, month=6, day=15)

    for c in self.card.get_comments():
      for tg_c in Scrum.target_comments:
        if tg_c in c["data"]["text"]:
          break
      else:
        continue
      comment = c['data']['text'].split('：')
      if "開始時間" in comment[0]:
        delta_time += (tmp_time - datetime.strptime(comment[1], '%Y/%m/%d %H:%M:%S'))
      else:
        delta_time -= (tmp_time - datetime.strptime(comment[1], '%Y/%m/%d %H:%M:%S'))
    # self.card.comment(f"{delta_time}")
    if delta_time > timedelta(hours=2):
      self.card.add_label(self.labels["2H"])