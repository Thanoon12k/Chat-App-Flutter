from django.contrib import admin
from.models import Room,Message


class RoomAdmin(admin.ModelAdmin):
     list_display=('name','owner','password')
class MessageAdmin(admin.ModelAdmin):
     list_display=('sender','text','attachment','room_id','addtime')
    

admin.site.register(Room, RoomAdmin)
admin.site.register(Message, MessageAdmin)
