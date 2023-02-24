from rest_framework.serializers import ModelSerializer,SerializerMethodField,StringRelatedField

from roomsapp.models import Room,Message

class base_room_ser(ModelSerializer):
    class Meta:
        model=Room
        fields=['id','name','users_count']

class base_message_ser(ModelSerializer):
    class Meta:
        model = Message
        fields=['id','room_id','text']
