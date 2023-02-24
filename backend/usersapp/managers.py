from django.contrib.auth.base_user import BaseUserManager
from django.utils.translation import gettext as _

class UserManager(BaseUserManager):
    def create_user(self, name, password=None,**extra_fields):
        if not name:
            raise ValueError('Users must have an name')
        user = self.model(name=name,**extra_fields )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, name, password=None,**extra_fields):
      
        user = self.create_user( name, password=password,**extra_fields)
        user.is_admin = True
        user.save(using=self._db)
        return user


