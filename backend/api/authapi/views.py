
from rest_framework import generics,permissions
from rest_framework.response import Response
from roomsapp.models import Room
from usersapp.models import Users
from .serializers import *
from django.shortcuts import get_object_or_404

 
class UserInit(generics.CreateAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    serializer_class=user_init_ser
    queryset=Users.objects.all()
    fields=['id','name','status','notification','image']
  