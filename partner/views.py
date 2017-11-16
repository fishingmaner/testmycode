# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.shortcuts import render_to_response
from django.http import HttpResponse
from utils.contrib import build_json
from utils.contrib import order_state
from partner.models import Orders
from partner.models import Partner
from partner.models import Product
from userextends.models import UserExtends
from weixin import wxapi
from utils import contrib
import datetime
import time
import json
import uuid

# Create your views here.
def cancel_order(request):
    if oprate_order(request, u'已撤销'):
        return HttpResponse(build_json(None));
    return HttpResponse(build_json(None, 1, '当前状态不允许再改变'));

def accept_order(request):
    if oprate_order(request, u'已确认'):
        return HttpResponse(build_json(None));
    return HttpResponse(build_json(None, 1, '当前状态不允许再改变'));

def dismiss_order(request):
    if oprate_order(request, u'已拒绝'):
        return HttpResponse(build_json(None));
    return HttpResponse(build_json(None, 1, '当前状态不允许再改变'));

def oprate_order(request, oprate):
    states = order_state()
    if 'id' in request.POST:
        order = Orders.objects.get(id=request.POST['id'])
        if order.change_state(oprate) is True:
            userextends = UserExtends.objects.get(user=order.user)
            access_token = wxapi.wx_access_token()
            wxapi.send_wxmsg(
                access_token,
                userextends.openid, order, u"你的订单状态有变化!", u"祝用餐愉快!", "http://sc.kangyanping.com/wx/order?id=" + str(order.id))
            return True
        return False

def create_order(request):
    now = datetime.datetime.now()
    if not request.user.is_authenticated:
        return HttpResponse(build_json(None, 1, 'not login'));

    userextends = UserExtends.objects.get(user=request.user)
    if not userextends:
        return HttpResponse(build_json(None, 1, 'not login'));

    data = json.loads(request.body)
    note = ''
    booktime = ''
    bookdate = now.strftime('%Y-%m-%d ')
    menu_products = []
    pid = ''
    needroom = ''
    vcode = ''
    phone = ''
    if 'note' in data:
        note = data['note']
    if 'booktime' in data:
        booktime = data['booktime']
    if 'ids' in data:
        menu_products = data['ids']
    if 'pid' in data:
        pid = data['pid']
    if 'needroom' in data:
        needroom = data['needroom']
    if 'vcode' in data:
        vcode = data['vcode']
    if 'phone' in data:
        phone = data['phone']
    if 'bookdate' in data:
        bookdate = data['bookdate']

    #如果没有手机号需要校验验证码
    if not userextends.phone:
        if not contrib.verify_code(phone, vcode):
            return HttpResponse(build_json(None, 1, '验证码错误'))
        userextends.phone = phone
    #如果手机号有变化需要校验验证码
    if userextends.phone != phone:
        if not contrib.verify_code(phone, vcode):
            return HttpResponse(build_json(None, 1, '验证码错误'))
        userextends.phone = phone

    product_ids = []
    for p in menu_products:
        product_ids.append(p['id'])

    products = Product.objects.filter(id__in = product_ids).filter(partner_id=pid)
    price = 0.0
    count = 0
    for product in products:
        for p in menu_products:
            if p['id'] == product.id:
                price += p['num'] * p['price']
                count += p['num']

    partner = Partner.objects.get(id=pid)
    order = Orders()
    order.user = request.user
    order.partner = partner
    order.set_products(menu_products)
    order.price = price
    order.create_on = now.strftime('%Y-%m-%d %H:%M:%S')
    order.create_by = request.user.username
    order.modify_on = now.strftime('%Y-%m-%d %H:%M:%S')
    order.modify_by = request.user.username
    order.effected_on = bookdate + " " + booktime + now.strftime(':%S')
    effected_on = time.mktime(time.strptime(order.effected_on, "%Y-%m-%d %H:%M:%S"))
    if effected_on - time.time() < (30 * 60):
            return HttpResponse(build_json(None, 2, '必须提前30分钟预定'))
    order.guid = uuid.uuid1()
    order.set_needroom(needroom)
    order.set_note(note)
    order.save()

    userextends.set_collect(partner.id)
    userextends.save()

    userextends = UserExtends.objects.get(user=partner.username)
    access_token = wxapi.wx_access_token()
    wxapi.send_wxmsg(
        access_token,
        userextends.openid, order, u"你收到了新的订单!", u"请及时处理!", "http://sc.kangyanping.com/wx/partner/order?id="+str(order.id))
    return HttpResponse(build_json({ 'id':  order.id}))
