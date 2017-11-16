# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models
import uuid
import json
import datetime

# Create your models here.
class Qrcode(models.Model):
    extends = models.TextField()
    create_on = models.DateTimeField(auto_now_add=True, verbose_name=u'创建时间')
    effected_on = models.DateTimeField(blank=True,verbose_name=u'生效时间')
    expired_on = models.DateTimeField(blank=True,verbose_name=u'过期时间')
    guid = models.CharField(max_length=100, verbose_name=u'编号')

    @staticmethod
    def create(content):
        now = datetime.datetime.now()
        qrcode = Qrcode()
        qrcode.extends = json.dumps(content)
        qrcode.guid = uuid.uuid1()
        qrcode.create_on = now.strftime('%Y-%m-%d %H:%M:%S')
        qrcode.create_on = now.strftime('%Y-%m-%d %H:%M:%S')

    def get_content(self):
        return json.loads(self.extends)
