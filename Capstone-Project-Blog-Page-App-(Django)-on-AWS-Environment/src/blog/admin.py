from django.contrib import admin
from .models import Post, Like, PostView, Comment

admin.site.register(Post)
admin.site.register(Like)
admin.site.register(PostView)
admin.site.register(Comment)

# Register your models here.
