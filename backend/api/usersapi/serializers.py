from rest_framework.serializers import ModelSerializer,SerializerMethodField

from roomsapp.models import Room
from usersapp.models import Users

class base_user_ser(ModelSerializer):
    class Meta:
        model=Users
        fields=['id','name','email']
