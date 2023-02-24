from rest_framework.serializers import ModelSerializer,SerializerMethodField

from roomsapp.models import Room
from usersapp.models import Users

class user_init_ser(ModelSerializer):
    class Meta:
        model=Users
        fields=['id','name','status','notification','image']
class base_user_ser(ModelSerializer):
    class Meta:
        model=Users
        fields=['id','name','email']
