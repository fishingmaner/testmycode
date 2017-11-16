# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from utils.storage import ImageStorage
from utils.contrib import order_state
from contrib.models import Qrcode
import sys
import json
reload(sys)
sys.setdefaultencoding("utf8")
# Create your models here.
class ProductType(models.Model):
    name = models.CharField(max_length=10, verbose_name=u'菜品分类')
    class Meta:
        verbose_name = u"菜品分类";
    def __str__(self):
        return self.name

class Tag(models.Model):
    tagname = models.CharField(max_length=10, verbose_name=u'标签名')
    class Meta:
        verbose_name = u'标签'
    def __str__(self):
        return self.tagname

class Partner(models.Model):
    id = models.AutoField(primary_key=True)
    #username = models.CharField(max_length=10, verbose_name='用户名', db_index=True, editable=False)
    username = models.ForeignKey(User, verbose_name=u'申请人')
    name = models.CharField(max_length=30, verbose_name=u'名称')
    phone = models.CharField(max_length=15, verbose_name=u'联系方式')
    welcomemsg = models.TextField(verbose_name=u'欢迎语', blank=True)
    img = models.ImageField(upload_to='upload/%Y/%m', verbose_name=u'头像', storage=ImageStorage())
    state_choices = (
        (0, u"待申请"),
        (1, u"审核中"),
        (2, u"营业中"),
        (3, u"冻结中"),
    )
    state = models.IntegerField(choices=state_choices,default=0, verbose_name=u'状态')
    judge = models.IntegerField(default=0, verbose_name=u'星级')
    address =  models.CharField(max_length=100, verbose_name=u'地址')
    opentime = models.CharField(max_length=15, default=u'全天', verbose_name=u'营业时间')
    tags =  models.ManyToManyField(Tag, verbose_name=u'标签s')
    class Meta:
        verbose_name = u'餐馆'
    def __str__(self):
        return self.name

class Rooms(models.Model):
    partner = models.ForeignKey(Partner, verbose_name=u'所属餐馆')
    name = models.CharField(max_length=30, verbose_name=u'座号/房间号')
    capacity = models.IntegerField(default=0, verbose_name=u'可容纳人数')
    guid = models.CharField(max_length=100, verbose_name=u'二维码编号')
    class Meta:
        verbose_name = u'房间'
    def __str__(self):
        return self.name

class Product(models.Model):
    partner = models.ForeignKey(Partner, verbose_name=u'所属餐馆')
    name = models.CharField(max_length=30, verbose_name=u'菜名')
    price = models.FloatField(default=0.0, verbose_name=u'价格')
    off = models.FloatField(default=0.0, verbose_name=u'折扣')
    img = models.ImageField(default='', upload_to='upload/%Y/%m', verbose_name=u'菜品图样', storage=ImageStorage())
    type = models.ForeignKey(ProductType, verbose_name=u'菜品类型')
    recommend = models.IntegerField(default=0, verbose_name=u'推荐')
    products =  models.CharField(default='', blank=True, max_length=100, verbose_name=u'标准组合')
    class Meta:
        verbose_name = u'菜品'
    def __str__(self):
        return self.name

# extends 格式
#   {
#       'needroom':false,
#       'note':'',
#   }
class Orders(models.Model):
    user = models.ForeignKey(User, verbose_name=u'生成者')
    partner = models.ForeignKey(Partner, verbose_name=u'所属餐馆')
    products = models.CharField(max_length=500, verbose_name=u'菜单')
    price = models.FloatField(default=0.0, verbose_name=u'总价')
    income = models.FloatField(default=0.0, verbose_name=u'实收')
    extends = models.TextField() #备注，包厢等
    create_on = models.DateTimeField(auto_now_add=True, verbose_name=u'创建时间')
    create_by = models.CharField(max_length=150, verbose_name=u'创建人')
    modify_on = models.DateTimeField(verbose_name=u'修改时间')
    modify_by = models.CharField(max_length=150, verbose_name=u'修改人')
    effected_on = models.DateTimeField(blank=True,verbose_name=u'生效时间')
    state = models.IntegerField(choices=order_state(),default=0, verbose_name=u'状态')
    guid = models.CharField(max_length=100, verbose_name=u'订单编号')
    class Meta:
        verbose_name = u'订单'
    def __str__(self):
        return self.user.username

    def change_state(self, statename):
        states = order_state()
        am_state = self.tostr()
        if am_state == '已撤销' or am_state == '已拒绝' or am_state == '已确认':
            return False
        for state in states:
            if state[1] == statename:
                self.state = state[0]
                self.save()
                return True
        return False

    def tostr(self):
        states = order_state()
        for state in states:
            if self.state == state[0]:
                return state[1]
        return ''

    def get_needroom(self):
        if not self.extends:
            return false
        extends = json.loads(self.extends)
        if 'needroom' not in extends:
            return false
        return extends['needroom']

    def set_needroom(self, needroom=False):
        extends = {}
        if self.extends:
            extends = json.loads(self.extends)
        extends['needroom'] = needroom
        self.extends = json.dumps(extends)

    def get_note(self):
        if not self.extends:
            return None
        extends = json.loads(self.extends)
        if 'note' not in extends:
            return None
        return extends['note']

    def set_note(self, note):
        extends = {}
        if self.extends:
            extends = json.loads(self.extends)
        extends['note'] = note
        self.extends = json.dumps(extends)

    def get_products(self):
        if not self.products:
            return []
        return json.loads(self.products)

    def set_products(self, ids):
        self.products = json.dumps(ids)

    @staticmethod
    def orders_by_user(user):
        orders = Orders.objects.filter(user=user).order_by('-modify_on')
        for order in orders:
            order.state_str = order.tostr()
        return orders
