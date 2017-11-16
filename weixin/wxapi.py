# -*- coding : utf-8 -*-
from django.http import HttpResponseRedirect
from urllib import quote
from utils import contrib
import json

appid = settings.APP_ID
appsecret = settings.SECRET_ID

def wx_redirect(request):
    url = 'http://' + request.get_host() + request.get_full_path()
    return HttpResponseRedirect("https://open.weixin.qq.com/connect/oauth2/authorize?appid="+appid+"&redirect_uri="+quote(url)+"&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect")

def wx_web_access_token(code):
    url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="+appid+"&secret="+appsecret+"&code="+code+"&grant_type=authorization_code"
    return contrib.http_get("https://api.weixin.qq.com/sns/oauth2/access_token", "appid="+appid+"&secret="+appsecret+"&code="+code+"&grant_type=authorization_code")

def wx_userinfo(access_token, openid):
    return contrib.http_get("https://api.weixin.qq.com/sns/userinfo", "access_token="+access_token+"&openid="+openid+"&lang=en")

def wx_access_token():
    file_name = "/tmp/verifycode/access_token"
    try:
        f = file(file_name)
        if f:
            line = f.readline()
            if len(line) > 0:
                return line
        return ''
    except:
        return ''

def send_wxmsg(access_token, openid, order, first_msg, remark_msg, url):
    jd = {
        "touser":openid,
        "template_id":"Ytf6mKqdiP4snxdYLFuPsxa04HzZCWiypNN1-KHkEvo",
        "url":url,
        "data":{
            "first":{
                "value":first_msg,
                "color":"#173177"
            },
            "date":{
                "value":str(order.create_on),
                "color":"#173177"
            },
            "state":{
                "value":order.tostr(),
                "color":"#173177"
            },
            "remark":{
                "value":remark_msg,
                "color":"#173177"
            }
        }
    }
    data = contrib.http_post("https://api.weixin.qq.com/cgi-bin/message/template/send?access_token="+access_token, json.dumps(jd))
    return data
