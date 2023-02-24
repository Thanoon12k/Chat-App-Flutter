
from rest_framework import generics,permissions
from rest_framework.response import Response
from roomsapp.models import Room
from usersapp.models import Users
from .serializers import *
from django.shortcuts import get_object_or_404



class RoomActiveMembers(generics.ListAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_user_ser
    def get_queryset(self,pk=None,*args,**kwargs):
        pk=self.kwargs['pk']
        room=Room.objects.filter(id=pk).first()
        if room:
            return room.users.all()
        return Room.objects.none()

class RoomBannedMembers(generics.ListAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_user_ser
    def get_queryset(self,pk=None,*args,**kwargs):
        room=get_object_or_404(Room,id=self.kwargs['pk'])
        return room.banned_users.all()

class RoomAddMember(generics.CreateAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_user_ser
    def post(self,*args,**kwargs):
        room=get_object_or_404(Room,id=kwargs['pk'])
        user=get_object_or_404(Users,id=kwargs['user_id'])
        room.users.add(user)
        return Response(f'user {user} add to room {room}')
class RoomBanMember(generics.CreateAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_user_ser
    def post(self,*args,**kwargs):
        room=get_object_or_404(Room,id=kwargs['pk'])
        user=get_object_or_404(Users,id=kwargs['user_id'])
        room.banned_users.add(user)
        return Response(f'banned successfully',200)
class RoomSetMemberAdmin(generics.CreateAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_user_ser
    def post(self,*args,**kwargs):
        room=get_object_or_404(Room,id=kwargs['pk'])
        user=get_object_or_404(Users,id=kwargs['user_id'])
        room.admin_users.add(user)
        return Response(f'set admin successfully',200)
class RoomKickMember(generics.CreateAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=base_user_ser
    def post(self,*args,**kwargs):
        room=get_object_or_404(Room,id=kwargs['pk'])
        user=get_object_or_404(Users,id=kwargs['user_id'])
        room.users.remove(user)
        room.admin_users.remove(user)
        return Response(f'kicked successfully',200)
