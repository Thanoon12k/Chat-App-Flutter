from django.urls import path

from . import views


urlpatterns = [
    path("chat", views.index, name="index"),
    path("ws/rooms/<str:room_name>/messages/", views.room, name="room"),
    path("async_rooms/<str:room_name>/", views.room, name="room"),
    path("rest_rooms/<str:room_name>/", views.room, name="room"),
]