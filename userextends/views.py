# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.contrib.auth import authenticate,login,logout
from django.contrib.auth.models import User, Group
from utils.contrib import build_json
from utils import alisms
from userextends.models import UserExtends
from weixin import wxapi
import uuid
import json
import re
import random

# Create your views here.
def phonesupply(request):
    ue = UserExtends.objects.get(user=request.user)
    if not ue:
        return HttpResponse(build_json(None, 1, '无效的用户'))

    phone = ''
    verifycode = ''
    pattern = re.compile(r'^[1][3,4,5,7,8][0-9]{9}$')
    if 'phone' in request.POST:
        phone = request.POST['phone']
    if 'verifycode' in request.POST:
        verifycode = request.POST['verifycode']

    # 校验验证码是否匹配
    if not verifycode:
        return HttpResponse(build_json(None, 1, '验证码错误'))
    else:
        file_name = "/tmp/verifycode/%s" % phone
        try:
            f = file(file_name)
            if f:
                line = f.readline()
                if len(line) == 0:
                    return HttpResponse(build_json(None, 1, '验证码错误'))
                if verifycode != line:
                    return HttpResponse(build_json(None, 1, '验证码错误'))
            else:
                return HttpResponse(build_json(None, 1, '验证码错误'))
        except:
            return HttpResponse(build_json(None, 1, '验证码错误'))

    match = pattern.match(phone)
    if not match:
        return HttpResponse(build_json(None, 1, '手机号格式不正确'))
    ue.phone = phone
    ue.save()
    return HttpResponse(build_json({ 'phone' : phone, 'verifycode' : verifycode }))

def phonelogin(request):
    pattern = re.compile(r'^[1][3,4,5,7,8][0-9]{9}$')
    if 'phone' in request.POST:
        phone = request.POST['phone']
    if 'verifycode' in request.POST:
        verifycode = request.POST['verifycode']

    if verifycode == 1:
        return HttpResponse(build_json(None, 1, '验证码错误'))

    match = pattern.match(phone)
    if not match:
        return HttpResponse(build_json(None, 1, '手机号格式不正确'))

    group = Group.objects.get(name='verifycode')
    try:
        ue = UserExtends.objects.get(phone=phone)
        login(request, ue.user);
        return HttpResponse(build_json({ 'phone' : ue.phone}))
    except UserExtends.DoesNotExist:
        username = 'id_'+phone
        try:
            if User.objects.get(username=username):
                #用户名存在，但没有扩展信息
                return HttpResponse(build_json(None, 1, '错误'))
        except User.DoesNotExist:
            user = User.objects.create_user(username=username)
            ue = UserExtends()
            ue.user = user
            ue.phone = phone
            ue.nickname = user.username
            ue.save()
            group.user_set.add(user)
            login(request, user);
    return HttpResponse(build_json({ 'phone' : phone, 'verifycode' : verifycode }))

def verifycode(request):
    pattern = re.compile(r'^[1][3,4,5,7,8][0-9]{9}$')
    phone = ''
    if 'phone' in request.POST:
        phone = request.POST['phone']

    match = pattern.match(phone)
    if not match:
        return HttpResponse(build_json(None, 1, '手机号格式不正确'))

    code = ''
    for i in range(0,6):
        r = random.randint(0, 9)
        code += str(r)
    params = {'code' : code }
    __business_id = uuid.uuid1()
    data = json.loads(alisms.send_sms(__business_id, phone, u"康乐", "SMS_107090178", json.dumps(params)))
    if data['Code'] == 'OK':
        file_name = "/tmp/verifycode/%s" % phone
        f = file(file_name, "w")
        f.write("%s" % code)
        f.close()
        return HttpResponse(build_json(None, 0, u'验证码已发送'))
    return HttpResponse(build_json(None, 1, data['Message']))
