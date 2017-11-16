{% extends "base.tpl" %}

{% block title %}
<title>订单详情页</title>
{% endblock %}
{% block mainbody %}
<div class="ui container">
    <div class="ui grid">
        <div class="center aligned column">
            <div class="ui orange statistic">
                <div class="value"><i class="yen mini icon"></i>{{ order.price }}</div>
                <div class="label">总计</div>
            </div>
        </div>
    </div>

{% include "step.tpl" %}

<style>
.pop{width:200px;height:100px;-moz-border-radius:20px;-webkit-border-radius:20px;border-radius:20px;background:green;margin-top:20px;position:relative}
.pop:after{content: "";border: 0 solid transparent; border-bottom:30px solid #669;-moz-border-radius:0 0 0 200px;-webkit-border-radius:0 0 0 200px;
border-radius:0 0 0 200px;width:50px;height:50px;position:relative;margin-top:20px;-webkit-transform: rotate(-90deg); -moz-transform: rotate(-90deg); 
-ms-transform: rotate(-90deg); -o-transform: rotate(-90deg);position:absolute;top:50px;}
</style>

<div class="ui middle aligned divided list">
    <div class="item">
        <div class="right floated content"><p style="font-size:13px;">{{ order.guid }}</p></div>
        <div class="content">订单编号</div>
    </div>
    <div class="item">
        <div class="right floated content">{{ userextends.nickname }}</div>
        <div class="content">创建人</div>
    </div>
    <div class="item">
        <div class="right floated content">{{ userextends.phone }}</div>
        <div class="content">联系电话</div>
    </div>
    <div class="item">
        <div class="right floated content">{{ order.effected_on}}</div>
        <div class="content">就餐时间</div>
    </div>
    <div class="item">
        <div class="right floated content">{{ order.partner.name }}</div>
        <div class="content">就餐地点</div>
    </div>
    <div class="item">
        <div class="right floated content">￥{{ order.income }}</div>
        <div class="content">实收</div>
    </div>
    <div class="item">
        <div class="right floated content">{{ order.state_str }}</div>
        <div class="content">订单状态</div>
    </div>
    <div class="item">
        <div class="ui two column grid">
            <div class="six wide column">
                <div class="content">备注</div>
            </div>
            <div class="ten wide column">
                <div class="text content"><p>{{ order.note_str }}</p></div>
            </div>
        </div>
    </div>
    <div class="item">
        <div class="right floated content"><a class="show_product">展开</a><i class="angle up icon"></i></div>
        <div class="content">菜单</div>
        <div class="extra content product" style="display:none">
            <div class="ui middle aligned divided list">
                {% for product in products %}
                <div class="product item" data-id={{ product.id }}>
                    <img class="ui avatar image" src="{{ product.img_url }}">
                    <div class="content">
                         {{ product.name }}
                    </div>
                </div>
               {% endfor %}
            </div>
        </div>
    </div>
</div>

{% block buttonblock %}
<div class="page__bd page__bd_spacing">
    <a href="javascript:;" class="weui-btn weui-btn_primary">支付</a>
    <a class="weui-btn weui-btn_default cancel" data-id="{{ order.id}}">撤销</a>
</div>
<script>
$(document).ready(function() {
    $('.show_product').on('click', function(){
        var display = $('.extra.content.product').css('display');
        if (display == 'none')//隐藏
        {
            $(this).text("合上");
            $('.extra.content.product').show();
        } else {
            $(this).text("展开");
            $('.extra.content.product').hide();
        }
    });

    $('.weui-btn.cancel').on('click', function(){
        $.post("/api/cancel_order",{'id' : $(this).attr('data-id')},
            function(data){
                if (data.code == 0) {
                    location.href = '/wx/order';
                } else {
                    alert(data.message);
                }
            }
        ,'json');
    });

    $('.pay').addClass('current');
    $('.eat').addClass('unstart');
});
</script>
{% endblock %}
</div>
{% endblock %}

