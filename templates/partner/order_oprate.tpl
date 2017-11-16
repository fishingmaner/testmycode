{% extends "weui/order_desc.tpl" %}
{% block title %}
<title>订单处理</title>
{% endblock %}
{% block buttonblock %}
<div class="ui container">
    <div class="ui three column grid" style="margin-top:10px;">
        <div class="one wide column"></div>
        <div class="fourteen wide center aligned green column" data-id={{ order.id }}><h5>接受</h5></div>
        <div class="one wide column"></div>
    </div>
    <div class="ui three column grid" style="margin-top:10px;">
        <div class="one wide column"></div>
        <div class="fourteen wide center aligned red column" data-id={{ order.id }}><h5>拒绝</h5></div>
        <div class="one wide column"></div>
    </div>
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
    $('.green.column').on('click', function(){
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
    $('.red.column').on('click', function(){
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
