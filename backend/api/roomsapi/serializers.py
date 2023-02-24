from rest_framework.serializers import ModelSerializer,SerializerMethodField,StringRelatedField,DateTimeField

from roomsapp.models import Room,Message

class base_room_ser(ModelSerializer):
    users_count=SerializerMethodField()
    class Meta:
        model=Room
        fields=['id','name','owner','users_count','image','addtime']
    def get_users_count(self,obj):
        return obj.users.count()
class base_message_ser(ModelSerializer):
    addtime = DateTimeField(format='%a , %I:%M %p',read_only=True)
    sender_name=StringRelatedField(source='sender')

    class Meta:
        model = Message
        fields=['id','text','sender','sender_name','room_id','attachment','addtime']
