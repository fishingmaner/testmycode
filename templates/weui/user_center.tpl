{% extends "base.tpl" %}

{% block title %}
<title>个人中心</title>
{% endblock %}
{% block mainbody %}
<div class="ui container">

<div class="content">
<img class="ui center middle aligned tiny image" src="{{ userextends.headimgurl }}">
<span>{{ userextends.nickname }}</span>
</div>

<div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="">
        <div class="weui-cell__hd">
            <i class="call green large icon"></i>
        </div>
        <div class="weui-cell__bd">
            <p>手机号</p>
        </div>
        <div class="weui-cell__ft">{{ userextends.phone }}</div>
    </a>

    <div class="weui-cell">
        <div class="weui-cell__hd">
            <i class="shopping bag green large icon"></i>
        </div>
        <div class="weui-cell__bd">
            <p>积分</p>
        </div>
        <div class="weui-cell__ft">{{ userextends.bouns }}</div>
    </div>
    <a class="weui-cell weui-cell_access" href="/wx/order">
        <div class="weui-cell__hd">
            <i class="browser green large icon"></i>
        </div>
        <div class="weui-cell__bd">
            <p>订单中心</p>
        </div>
        <div class="weui-cell__ft"></div>
    </a>

    <a class="weui-cell weui-cell_access" href="/wx/collect">
        <div class="weui-cell__hd">
            <i class="heart green large icon"></i>
        </div>
        <div class="weui-cell__bd">
            <p>我的收藏</p>
        </div>
        <div class="weui-cell__ft"></div>
    </a>

</div>
</div>

<script>
$(document).ready(function() {
    $('.red.column').on('click', function(){
        location.href = '/wx/logout';
    });

    $('.weui-footer').addClass('weui-footer_fixed-bottom');
});
</script>
{% endblock %}
