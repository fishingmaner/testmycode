# -*- coding: utf8 -*-
from book import settings
import json
import requests

def build_json(data, code=0, msg='success', state=True):
    res = {}
    res['code'] = code
    res['message'] = msg
    res['data'] = data
    res['success'] = state
    return json.dumps(res)

def order_state():
    return (
        (0, u"待确认"),
        (1, u"已撤销"),
        (2, u"已确认"),
        (3, u"已作废"),
        (4, u"已拒绝"),
    )

def get_img_url(img, width=0, height=0):
    if img is None or img == '':
        return ''
    nodes = str(img).split('/')
    if width == 0 or height == 0:
        return ".." + settings.MEDIA_URL + str(img)
    pnodes = []
    pnodes.append(nodes[0])
    pnodes.append(nodes[1])
    pnodes.append(nodes[2])
    pnodes.append(str(width))
    pnodes.append(str(height))
    pnodes.append(nodes[3])
    return ".." + settings.MEDIA_URL + 'resize/' + '/'.join(pnodes)

def http_get(url, params=''):
    r = requests.get(url + "?" + params, timeout = (1, 1))
    if r.status_code == 200:
        return(r.json())
    return None

def http_post(url, json_data):
    h = {
        "Content-type" : "application/x-www-form-urlencoded",
    }
    r = requests.post(url, data=json_data, headers=h, timeout = (2, 1))
    if r.status_code == 200:
        return r.json()
    return None

def http_post2(url, params):
    h = {
        "Content-type" : "application/x-www-form-urlencoded",
    }
    # For Python 3
    #temp_params = urllib.parse.urlencode(params)
    temp_params = urllib.urlencode(params)
    r = requests.post(url, data=temp_params, headers=h, timeout = (2, 1))
    if r.status_code == 200:
        return r.json()
    return None

#验证手机码
def verify_code(phone, vcode):
    if not phone:
        return False
    if not vcode:
        return False
    else:
        file_name = "/tmp/verifycode/%s" % phone
        print file_name
        try:
            f = file(file_name)
            if f:
                line = f.readline()
                if len(line) == 0:
                    return False
                if int(vcode) != int(line):
                    return False
            else:
                return False
        except Exception, e:
            return False
    return True
