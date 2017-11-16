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

<div class="ui middle aligned divided list">
    <div class="item">
        <div class="right floated content">
            <div class="content">{{ userextends.phone }}</div>
        </div>
        <i class="call green large icon"></i>
        <div class="content">手机号</div>
    </div>
    <div class="item">
        <div class="right floated content">
            <div class="content">{{ userextends.bouns }}</div>
        </div>
        <i class="shopping bag green large icon"></i>
        <div class="content">积分</div>
    </div>
    <div class="item">
        <div class="right floated content">
            <a href="/wx/order"><i class="angle grey right icon"></i></a>
        </div>
        <i class="browser green large icon"></i>
        <div class="content">订单中心</div>
    </div>
    <div class="item">
        <div class="right floated content">
            <a href="/wx/collect"><i class="angle grey right icon"></i></a>
        </div>
        <i class="heart green large icon"></i>
        <div class="content">我的收藏</div>
    </div>
</div>

</div>

</div>
<script>
$(document).ready(function() {
    $('.red.column').on('click', function(){
        location.href = '/wx/logout';
    });
});
</script>
{% endblock %}
