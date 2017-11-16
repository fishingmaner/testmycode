{% extends "base.tpl" %}

{% block title %}
<title>个人收藏</title>
{% endblock %}
{% block mainbody %}
<div class="ui container">
<div class="ui items">
{% for partner in partners %}
<div class="item">
    <div class="ui image">
        <a href="/wx/booking?id={{ partner.id }}"><img src="/../media/{{ partner.img }}"></a>
    </div>
    <div class="middle aligned content">
        <a href="/wx/booking?id={{ partner.id }}" class="header">{{ partner.name }}</a>
    </div>
</div>
{% endfor %}
</div>
{% endblock %}

