# Generated by Django 4.1.5 on 2023-01-15 14:29

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='Users',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('last_name', models.CharField(blank=True, max_length=150, verbose_name='last name')),
                ('is_active', models.BooleanField(default=True, help_text='Designates whether this user should be treated as active. Unselect this instead of deleting accounts.', verbose_name='active')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now, verbose_name='date joined')),
                ('email', models.EmailField(blank=True, max_length=255, null=True, verbose_name='Email Address')),
                ('name', models.CharField(max_length=100, unique=True)),
                ('birthdate', models.DateField(default=django.utils.timezone.now)),
                ('image', models.ImageField(blank=True, null=True, upload_to='profile_images')),
                ('cover_image', models.ImageField(blank=True, null=True, upload_to='cover_images')),
                ('gender', models.CharField(choices=[('m', 'male'), ('f', 'famle')], default='m', max_length=15)),
                ('status', models.CharField(default='-', max_length=25)),
                ('comments', models.BooleanField(default=False)),
                ('private', models.BooleanField(default=False)),
                ('notification', models.BooleanField(default=False)),
                ('is_banned', models.BooleanField(default=False)),
                ('is_admin', models.BooleanField(default=False)),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.permission', verbose_name='user permissions')),
            ],
            options={
                'verbose_name': 'user',
                'verbose_name_plural': 'users',
                'abstract': False,
            },
        ),
    ]
