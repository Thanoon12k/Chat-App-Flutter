import json
from roomsapp.models import Message,Room

from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer
def save_to_db(room,txt):
        room=Room.objects.filter(name=room).first()  
        Message.objects.create(text=txt,room_id=room)
        print(txt ,' saved')


class sync_msg(WebsocketConsumer):
    def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_name"]
        self.room_group_name = "chat_%s" % self.room_name
        async_to_sync(self.channel_layer.group_add)(
            self.room_group_name, self.channel_name
        )
        ########################## send old messages to all cliens
        room=Room.objects.filter(name=self.room_name).first()
        msgs=Message.objects.filter(room_id=room)    
        for m in msgs:
            async_to_sync(self.channel_layer.group_send)(
                self.room_group_name, {"type": "chat_message", "message": m.text}
            )
        ###########################
        
        self.accept()

    def disconnect(self, close_code):
        async_to_sync(self.channel_layer.group_discard)(
            self.room_group_name, self.channel_name
        )

    def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]
        save_to_db(self.room_name, message)
        async_to_sync(self.channel_layer.group_send)(
            self.room_group_name, {"type": "chat_message", "message": message}
        )
    def chat_message(self, event):
        message = event["message"]
        self.send(text_data=json.dumps({"message": message}))
