from rest_framework.serializers import ModelSerializer,SerializerMethodField,StringRelatedField,CharField;

from roomsapp.models import Room
from usersapp.models import Users

class user_register_ser(ModelSerializer):
    token=StringRelatedField(source='user.token',read_only=True)
    class Meta:
        model=Users
        fields=['id','name','status','notification','image','token']


