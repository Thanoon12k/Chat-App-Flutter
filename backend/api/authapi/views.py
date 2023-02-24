
from rest_framework import generics,permissions
from rest_framework.authtoken.models import Token

from rest_framework.response import Response
from roomsapp.models import Room
from usersapp.models import Users
from .serializers import *
from django.shortcuts import get_object_or_404

 
class UserRegister(generics.CreateAPIView):
    """ list of all rooms """
    permission_classes=[permissions.BasePermission]
    queryset=Users.objects.all()
    def post(self,*args,**kwargs):
        data=user_register_ser(self.request.POST).data
        user=Users.objects.filter(name=data['name']).first()
        if not user:
            user=Users.objects.create(**data)
        
            


            data['new_user']=True
             

        token,created=Token.objects.get_or_create(user=user)
        data['id']=user.id
        data['token']=token.key
        
        return Response(data)

   
  