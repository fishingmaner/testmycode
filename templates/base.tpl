<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/semantic-ui/2.2.4/semantic.min.css">
    <script src="http://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/semantic-ui/2.2.4/semantic.min.js"></script>

    <link rel="stylesheet" href="//res.wx.qq.com/open/libs/weui/1.1.2/weui.min.css">
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.1.2/weui.min.js"></script>

    {% block title%}
    <title>Semantic UI</title>
    {% endblock %}
    <style>
        body { padding-top: 10px; padding-bottom: 5px;font-size: 1.2rem;}
        .bottombar {width:100%; height:60px;position:fixed;bottom:0;background:white;border:1px solid #D1D1D1;}
        .weui-footer p {
            line-height:inherit;
        }
    </style>

</head>

<body>
	{% block mainbody %}
	{% endblock %}

    {% block footer %}
    <div class="container">
    <div class="page footer">
    <div class="page__bd page__bd_spacing">
    <div class="weui-footer">
    <p class="weui-footer__links">
    <a href="javascript:void(0);" class="weui-footer__link">帮助中心</a>
    </p>
    <p class="weui-footer__text">Copyright © 2017-2017 com</p>
    </div>
    </div>
    </div>
    </div>
    {% endblock %}
</body>
</html>
