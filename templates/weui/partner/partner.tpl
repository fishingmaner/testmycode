{% extends "base.tpl" %}

{% block title %}
<title>个人中心</title>
{% endblock %}
{% block mainbody %}
<div class="ui container">

<div class="content">
</div>

<div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="/wx/partner/order">
        <div class="weui-cell__hd">
            <i class="browser green large icon"></i>
        </div>
        <div class="weui-cell__bd">
            <p>收到的订单</p>
        </div>
        <div class="weui-cell__ft"></div>
    </a>

    <a class="weui-cell weui-cell_access" href="#">
        <div class="weui-cell__hd">
            <i class="heart green large icon"></i>
        </div>
        <div class="weui-cell__bd">
            <p>日统计报表</p>
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
