from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils.translation import gettext 
from django.utils import timezone
from .managers import UserManager

class Users(AbstractUser):
    email               = models.EmailField(null=True,blank=True, verbose_name='البريد الالكتروني ',max_length=255  )
    name                = models.CharField(unique=True,blank=False,null=False ,max_length=100,verbose_name='الاسم')
    birthdate           = models.DateField(default=timezone.now,verbose_name='تاريخ الميلاد')
    image               = models.ImageField(null=True,blank=True,upload_to='profile_images',verbose_name='الصورة الشخصية')
    cover_image         = models.ImageField(null=True,blank=True,upload_to='cover_images',verbose_name='صورة الغلاف')
    gender              = models.CharField(choices=(('m','male'),('f','famle')),default='m',max_length=15,verbose_name='الجنس')
    notification        = models.CharField(choices=(
                                            ('no_alert','ايقاف الاشعارات'),
                                            ('just_icon','ايقونة فقط'),
                                            ('icon_image','ايقونة وصورة')
                                            ),default='icon_image',max_length=15,verbose_name='الاشعارات')
    status              = models.CharField(max_length=25,default='-',verbose_name='الحالة')
    comments            = models.BooleanField(default=False,verbose_name='التعليفات')
    private             = models.BooleanField(default=False,verbose_name='الخاص')
    is_banned           = models.BooleanField(default=False,verbose_name='حالة الحضر')
    is_admin            = models.BooleanField(default=False,verbose_name='ادمن')
    ip               = models.CharField(blank=True,null=True ,max_length=100,verbose_name='الأي بي')
    mac                = models.CharField(blank=True,null=True ,max_length=100,verbose_name='الماك')
    

    USERNAME_FIELD = 'name'
    objects = UserManager()
    def __str__(self):
        return self.name
    
    def has_perm(self, perm, obj=None):
      return self.is_admin
    def has_module_perms(self, app_label):
        return True
    @property
    def is_staff(self):
        return self.is_admin
    @property
    def first_name(self):
        return self.name
    @property
    def username(self):
        return self.name
    class Meta:
            verbose_name_plural='المستخدمين'