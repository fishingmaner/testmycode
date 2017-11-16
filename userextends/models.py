# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User, Group
from utils.storage import ImageStorage
from weixin import wxapi
import json

#   extends 格式
#   {
#       'collects' : [],
#   }
# Create your models here.
class UserExtends(models.Model):
    user = models.ForeignKey(User, verbose_name=u'用户')
    nickname =  models.CharField(max_length=20, verbose_name=u'昵称')
    phone =  models.CharField(max_length=15, verbose_name=u'手机号')
    avator = models.ImageField(upload_to='upload/%Y/%m', verbose_name=u'头像', storage=ImageStorage())
    bouns = models.IntegerField(default=0, verbose_name=u'积分')
    extends = models.TextField(default='')
    openid = models.CharField(default='', max_length=32, verbose_name=u'微信openid')
    headimgurl = models.CharField(default='', max_length=1024, verbose_name=u'微信头像')
    class Meta:
        verbose_name = u"用户信息";
    def __str__(self):
        return self.nickname

    def get_collect(self):
        if not self.extends:
            return None
        extends = json.loads(self.extends)
        if 'collects' not in extends:
            return None
        return extends['collects']

    def set_collect(self, pid):
        collects = self.get_collect()
        if collects is None:
            collects = []
        if pid in collects:
            return
        collects.append(pid)

        extends = {}
        if self.extends:
            extends = json.loads(self.extends)
        extends['collects'] = collects
        self.extends = json.dumps(extends)

    @staticmethod
    def user_create(userinfo):
        group = Group.objects.get(name='weixin')
        try:
            return UserExtends.objects.get(openid=userinfo['openid'])
        except UserExtends.DoesNotExist:
            username = 'id_' + userinfo['openid']
            try:
                user = User.objects.get(username=username)
                if user:
                    print("用户名存在，但没有扩展信息")
            except User.DoesNotExist:
                user = User.objects.create_user(username=username)

            ue = UserExtends()
            ue.user = user
            ue.nickname = userinfo['nickname']
            ue.openid = userinfo['openid']
            ue.headimgurl = userinfo['headimgurl']
            ue.save()
            group.user_set.add(user)
            return ue
