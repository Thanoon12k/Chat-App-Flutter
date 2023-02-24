
from rest_framework import generics,permissions
from roomsapp.models import Room,Message
from usersapp.models import Users
from .serializers import *




class ListRooms(generics.ListAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_room_ser
    queryset=Room.objects.all()

class ListMessages(generics.ListAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_message_ser
    queryset=Message.objects.all()
    def get_queryset(self):
        pk=self.kwargs['pk']
        return Message.objects.filter(room_id=pk)
    

class CreateMessage(generics.CreateAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_message_ser
    queryset=Message.objects.all()
  
    def perform_create(self, serializer):
        user=Users.objects.first()
        serializer.save(sender=user)
