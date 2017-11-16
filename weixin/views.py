# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.shortcuts import render_to_response
from django.http import HttpResponseRedirect
from django.http import HttpResponse
from django.contrib.auth import authenticate,login,logout
from partner.models import Tag
from partner.models import Partner
from partner.models import Product
from partner.models import Orders
from userextends.models import UserExtends
from urllib import urlencode
from urllib import quote
from utils.contrib import order_state
from utils.contrib import get_img_url
import wxapi
import hashlib
import xml.etree.ElementTree as ET
import time
import datetime
import json

# Create your views here.
def rendertpl(request, tpl, content = None):
    try:
        return render(request, 'weui/'+ tpl, content)
    except Exception,e:
        return render(request, 'weixin/' + tpl, content)

def list(request):
    return render(request, 'weixin/list.tpl')

def collect(request):
    if request.user.is_authenticated:
        userextends = UserExtends.objects.get(user=request.user)
        collects = userextends.get_collect()
        partners = []
        if collects is not None:
            partners = Partner.objects.filter(id__in = collects)
        return render(request, 'weixin/collect.tpl', { 'partners' : partners })
    return HttpResponseRedirect("/wx/login?next=/wx/collect")

def partner_order(request):
    if request.user.is_authenticated:
        if 'id' in request.GET:
            order = Orders.objects.get(id=request.GET['id'])
            content = order_content(order)
            return rendertpl(request, 'partner/order_oprate.tpl', content)
        else:
            for group in request.user.groups.all():
                if group.name == 'partner':
                    states = order_state()
                    partners = Partner.objects.filter(username=request.user)
                    all_orders = []
                    for partner in partners:
                        orders = Orders.objects.filter(partner=partner).order_by('-effected_on')
                        for order in orders:
                            order.state_str = order.tostr()
                        all_orders.append(orders)
                    return rendertpl(request, 'partner/order.tpl', { 'all_orders':all_orders })
    return HttpResponseRedirect("/wx/login?next=/wx/partner/order")

def partner(request):
    if request.user.is_authenticated:
        for group in request.user.groups.all():
            if group.name == 'partner':
                return rendertpl(request, 'partner/partner.tpl', { 'user' : request.user })
    return render(request, 'weixin/partner_welcome.tpl')

def hot(request):
    partners = Partner.objects.all()
    for partner in partners:
        partner.img_url = get_img_url(partner.img, 200, 200)
    return render(request, 'weixin/collect.tpl', { 'partners' : partners })

def wxlogin(request):
    if 'code' not in request.GET:
        return wxapi.wx_redirect(request)
    userextends = wxtestlogin(request)
    if 'next' in request.GET:
        return HttpResponseRedirect(request.GET['next'])
    return HttpResponseRedirect("/wx/hot")

def wxlogout(request):
    logout(request)
    return HttpResponse("")
    return HttpResponseRedirect("/wx/login")

def user_center(request):
    if request.user.is_authenticated:
        userextends = UserExtends.objects.get(user=request.user)
        return rendertpl(request, 'user_center.tpl', { 'userextends' : userextends })
    return HttpResponseRedirect("/wx/login?next="+request.get_full_path())

def order_content(order):
    order.state_str = order.tostr()
    order.note_str = order.get_note()
    userextends = UserExtends.objects.get(user=order.user)
    menu_products = order.get_products()
    product_ids = []
    for p in menu_products:
        product_ids.append(p['id'])
    products = Product.objects.filter(id__in = product_ids)
    for product in products:
        product.img_url = get_img_url(product.img, 50, 50)
    return { 'order' : order, 'userextends' : userextends, 'products' : products }

def order(request):
    if not request.user.is_authenticated:
        return HttpResponseRedirect("/wx/login?next="+ quote(request.get_full_path()))

    states = order_state()
    if 'id' not in request.GET:
        orders = Orders.orders_by_user(request.user)
        return rendertpl(request, 'order.tpl', { 'orders' : orders })

    order_id = request.GET['id']
    try: 
        order = Orders.objects.get(id=order_id)
    except Orders.DoesNotExist:
        orders = Orders.orders_by_user(request.user)
        return rendertpl(request, 'order.tpl', { 'orders' : orders })
    if request.user != order.user:
        return HttpResponseRedirect("/wx/hot")
    content = order_content(order)
    return rendertpl(request, 'order_desc.tpl', content)

def submit_order(request):
    if 'id' not in request.POST:
        return HttpResponseRedirect("/wx/hot")
    ids = request.POST['id'].split(",")
    nums = request.POST['nums'].split(",")
    pid = request.POST['pid']

    partner = Partner.objects.get(id=pid)
    products = Product.objects.filter(id__in = ids).filter(partner=partner)
    price = 0.0
    count = 0
    if len(ids) != len(nums):
        return HttpResponseRedirect("/wx/hot")
    index = 0
    product_nums = {}
    for d in ids:
        product_nums[d] = int(nums[index])
        index += 1

    for product in products:
        product.img_url = get_img_url(product.img, 50, 50)
        product.num = product_nums[str(product.id)]
        price += product.price * product.num
        count += product.num

    now = datetime.datetime.now()
    delta = datetime.timedelta(minutes=39)
    n_days = now + delta
    booktime = n_days.strftime('%H:%M')
    bookdate = now.strftime('%Y-%m-%d')

    try:
        ue = UserExtends.objects.get(user=request.user)
        return rendertpl(request, 'submit_order.tpl', { 'partner' : partner, 'userextends' : ue,
            'booktime':booktime, 'bookdate':bookdate, 'partnerid':pid, 'products' : products, 'count':count, 'price':price})
    except:
        return HttpResponseRedirect("/wx/hot")

def wxtestlogin(request):
    data = wxapi.wx_web_access_token(request.GET['code'])
    if 'errcode' in data:
        # 如果刷新页面导致获取token失败
        pass
    access_token = data['access_token']
    openid = data['openid']
    userinfo = wxapi.wx_userinfo(access_token, openid)
    if not userinfo:
        return None
    userinfo['nickname'] = userinfo['nickname'].encode('iso-8859-1').decode('utf-8')
    ue = UserExtends.user_create(userinfo)
    if ue:
        login(request, ue.user)
        return ue
    else:
        # TODO
        return None

def booking(request):
    if not request.user.is_authenticated:
        return HttpResponseRedirect("/wx/login?next="+ quote(request.get_full_path()))

    if 'id' not in request.GET:
        return render_to_response('404.html')

    pid = request.GET['id']
    partner = Partner.objects.get(id=pid)
    partner.img_url = get_img_url(partner.img, 100, 100)
    context = {}
    products = []
    products = Product.objects.filter(partner=partner.id)
    items = {}
    for product in products:
        product.img_url = get_img_url(product.img, 100, 100)
        if product.type.name not in items:
            items[product.type.name] = []
        items[product.type.name].append(product)

    content = { 'partner' : partner, 'items' : items }
    if 'siteid' in request.GET:
        site = {'name' : 'A101' }
        content['site'] = site
    return rendertpl(request, 'booking.tpl', content)

def post(request):
    print request.GET
    signature = ''
    if 'signature' in request.GET:
        signature = request.GET['signature']

    timestamp = ''
    if 'timestamp' in request.GET:
        timestamp = request.GET['timestamp']

    nonce = ''
    if 'nonce' in request.GET:
        nonce = request.GET['nonce']

    if 'echostr' is request.GET:
        echostr = request.GET['echostr']
        token = "12321" #请按照公众平台官网\基本配置中信息填写

        list = [token, timestamp, nonce]
        list.sort()
        sha1 = hashlib.sha1()
        map(sha1.update, list)
        hashcode = sha1.hexdigest()
        #print "handle/GET func: hashcode, signature: ", hashcode, signature
        if hashcode == signature:
            return HttpResponse(echostr)
        else:
            return HttpResponse("")
    else:
        rev_msg = ''
        root = ET.fromstring(request.body)
        for child in root:
            if child.tag == 'Content':
                rev_msg = child.text
            else:
                print(child.tag, child.text)

        openid = ''
        if 'openid' in request.GET:
            openid = request.GET['openid']

        objs = Tag.objects.all()
        tags = []
        for obj in objs:
            tags.append(obj.tagname)
        resp_msg = ''
        if rev_msg in tags:
            resp_msg = "igotit"
        else:
            resp_msg = u"亲，你可以回复如下特色获得推荐："
            for tag in tags:
                resp_msg += tag + ", "
        resp_msg = build_msg(openid, resp_msg)
        return HttpResponse(resp_msg)
        #return HttpResponse("success")

def build_msg(to_user, msg):
    ct = str(int(time.time()))
    resp_msg = '<xml><ToUserName><![CDATA['+to_user+']]></ToUserName><FromUserName><![CDATA[gh_21102275b08d]]></FromUserName><CreateTime>'+ct+'</CreateTime><MsgType><![CDATA[text]]></MsgType><Content><![CDATA['+msg+']]></Content></xml>'
    return resp_msg
