{% extends "base.tpl" %}

{% block title %}
<title>预约首页</title>
{% endblock %}
{% block mainbody %}
<style>
    body {
        background-color:#ffcc99;
    }
</style>
<div class="ui container">
<div class="ui dividing header">热门推荐</div>

<div class="ui items">
{% for partner in partners %}
<div class="item">
    <div class="ui image">
        <a href="/wx/booking?id={{ partner.id }}"><img class="ui rounded image" src="{{ partner.img_url }}"></a>
    </div>
    <div class="middle aligned content">
        <a href="/wx/booking?id={{ partner.id }}" class="header">{{ partner.name }}</a>
    </div>
</div>
{% endfor %}
</div>
{% endblock %}

