
from django.contrib import admin
from django.urls import path,include

from django.conf.urls.static import static
from django.conf import settings
# from jazmin_admin_dashboard.urls import urlpatterns as jazmin_admin_urls

urlpatterns = [
     path('admin/', admin.site.urls),

    path('', include('api.urls')),
    
  

    
]

urlpatterns+= static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
           
