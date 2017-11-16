{% extends "base.tpl" %}

{% block title %}
<title>订单中心</title>
<style>
body{
    background-color:#f8f8f8;
}

.green {
    color : green;
}

.red {
    color : red;
}

.orange {
    color : orange;
}

</style>
{% endblock %}
{% block mainbody %}
<div class="container">
    {% for order in orders %}
    <div class="weui-panel">
    <a href="/wx/order?id={{ order.id }}">
             <div class="weui-panel__bd">
                <div class="weui-media-box weui-media-box_text">
                    <h3 class="weui-media-box__title">{{order.partner.name }}</h3>
                    <ul class="weui-media-box__info">
                        <li class="weui-media-box__info__meta">{{ order.effected_on }}</li>
                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">{{ order.state_str }}</li>
                    </ul>
                </div>
             </div>
     </a>
    </div>
    {% endfor %}

</div>
<script>
$(document).ready(function() {
    $('.weui-media-box__info__meta_extra').each(function(i){
        if ($(this).text() == '已确认')
        {
            $(this).addClass('green');
        } else if ($(this).text() == '已拒绝')
        {
            $(this).addClass('red');
        } else if ($(this).text() == '待确认')
        {
            $(this).addClass('orange');
        }
    });
});
</script>
{% endblock %}
