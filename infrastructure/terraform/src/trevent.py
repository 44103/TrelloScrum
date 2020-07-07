import base64
import json

import singleton as sg
import exitjudge as ej

class TrelloEvent(sg.Singleton):
  def __init__(self, event):
    self.__event = event

    if "HEAD" == self.get_http_method():
      raise ej.ExitException("Succeed: Create Trello API")
    if "PUT" == self.get_http_method():
      raise ej.ExitException("Succeed: Update Trello API")

      
    self.__body = None if "body" not in event else json.loads(base64.b64decode(event["body"]).decode())

    if None == self.__body:
      raise ej.ExitException("Failed: Trello API Event Body is None")
    if "action_move_card_from_list_to_list" != self.get_translation_key():
      raise ej.ExitException("Failed: This Action is not Target")

  def get_http_method(self):
    return self.__event["httpMethod"]

  def get_translation_key(self):
    return self.__body["action"]["display"]["translationKey"]

  def get_card_id(self):
    return self.__body["action"]["display"]["entities"]["card"]["id"]

  def get_list_before_name(self):
    return self.__body["action"]["display"]["entities"]["listBefore"]["text"]

  def get_list_after_name(self):
    return self.__body["action"]["display"]["entities"]["listAfter"]["text"]