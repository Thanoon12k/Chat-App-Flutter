from django.shortcuts import render


def index(request):
    return render(request, "index.html")

def room(request, room_name):
    connection_type=(request.path).split(f'/{room_name}/')[0]
    print(connection_type)
    if connection_type=='/rest_rooms':
        return render(request, "rest_room.html", {"room_name": room_name})
    elif connection_type=='/async_rooms':
        return render(request, "async_room.html", {"room_name": room_name})
    return render(request, "sync_room.html", {"room_name": room_name})