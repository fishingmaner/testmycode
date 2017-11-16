{% extends "weui/order_desc.tpl" %}
{% block title %}
<title>订单处理</title>
{% endblock %}
{% block buttonblock %}
<div class="page__bd page__bd_spacing">
    <a class="weui-btn weui-btn_primary accept" data-id="{{ order.id}}">接受</a>
    <a class="weui-btn weui-btn_warn refuse" data-id="{{ order.id}}">拒绝</a>
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
    $('.weui-btn.accept').on('click', function(){
        $.post("/api/accept_order",{'id' : $(this).attr('data-id')},
            function(data){
                if (data.code == 0) {
                    location.href = '/wx/partner';
                } else {
                    alert(data.message);
                }
            }
         ,'json');
    });
    $('.weui-btn.refuse').on('click', function(){
        $.post("/api/dismiss_order",{'id' : $(this).attr('data-id')},
            function(data){
                if (data.code == 0) {
                    location.href = '/wx/partner';
                } else {
                    alert(data.message);
                }
            }
         ,'json');
    });
});
</script>
{% endblock %}
