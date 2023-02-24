from .serizlizers import base_room_ser,base_message_ser
from roomsapp.models import Room,Message
from rest_framework import generics,permissions

from djangochannelsrestframework.generics import GenericAsyncAPIConsumer
from djangochannelsrestframework.mixins import(
ListModelMixin,
RetrieveModelMixin,
PatchModelMixin,
CreateModelMixin,
UpdateModelMixin,
DeleteModelMixin,

)

class rest_msg(GenericAsyncAPIConsumer,ListModelMixin,CreateModelMixin,
RetrieveModelMixin,):
    permission_classes=[permissions.BasePermission]
    serializer_class=base_message_ser
    queryset=Message.objects.all()