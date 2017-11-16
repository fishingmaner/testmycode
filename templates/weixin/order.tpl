{% extends "base.tpl" %}

{% block title %}
<title>订单中心</title>
{% endblock %}
{% block mainbody %}
<div class="ui container">

<div class="ui middle aligned divided list">
{% for order in orders %}
    <div class="item">
        <div class="right floated content">
            {{ order.state_str }}
            <a href="/wx/order?id={{ order.id }}"><i class="angle grey right icon"></i></a>
        </div>
        <i class="browser green large icon"></i>
        <div class="content">
            <a href="/wx/order?id={{ order.id }}">{{order.partner.name }}</a>
        </div>
    </div>
{% endfor %}
</div>

</div>
{% endblock %}
