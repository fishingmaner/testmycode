{% extends "base.tpl" %}

{% block title %}
<title>{{ partner.name }}</title>
{% endblock %}
{% block mainbody %}
<style>
    body {
        font-size: 14px;
    }
</style>
<div class="ui container">
    {% if site %}
    <h1>座号：{{ site.name }}</h1>
    {% else %}
    <div class="ui fluid card partner" data-id={{ partner.id }}>
        <div class="content">
            <img class="right floated tiny ui image" src="{{ partner.img_url }}">
            <div class="header">{{ partner.name }}</div>
            <div class="meta"><i class="marker icon"></i>{{ partner.address }}</div>
        </div>
        <div class="extra content">
            <span class="left floated">
                <div class="ui star large rating" data-rating="3" data-max-rating="5"></div>
            </span>
            <span class="right floated">
                <i class="green large call icon"></i><a href="tel://{{ partner.phone }}">{{ partner.phone }}</a>
            </span>
        </div>
    </div>
    {% endif %}

{% for key,products in items.items %}
    <div class="ui dividing header">{{ key }}</div>
    <div class="ui tree colunn vertically divided grid">
    {% for product in products %}
    <div class="row">
        <div class="five wide column">
            <div class="ui image">
                <img class="ui rounded image" src="{{ product.img_url }}">
                {% if product.type.name == "标准" %}
                    <a class="ui green left ribbon label">标准</a>
                {% endif %}
            </div>
        </div>
         <div class="five wide column">
            <div class="content">
                <div class="ui header">{{ product.name }}</div>
                <div class="ui heart large rating" data-rating="{{ product.recommend }}" data-max-rating="5"></div>
                    <div class="ui orange mini horizontal statistic">
                        <div class="value mini">
                            ￥{{ product.price }}
                        </div>
                        <div class="value">
                            <s style="font-size:1.1rem;color:grey;margin-left:10px;">{{ product.off }}</s>
                        </div>
                    </div>
            </div>
         </div>
         <div class="six wide column">
            <div class="content right floated">
                <div class="ui three column grid product" data-id="{{ product.id }}" price="{{ product.price }}" data-num=1>
                    <div class="column"><i class="minus green icon"></i></div>
                    <div class="column number">0</div>
                    <div class="column"><i class="plus green icon"></i></div>
                </div>
            </div>
        </div>
    </div>
    {% endfor %}
    </div>
{% endfor %}
    <div style="height:70px">
        <div class="ui horizontal divider">没有了</div>
    </div>
</div>

    <div class="bottombar" style="border-left-width:0px;border-bottom-width:0px;border-right:0px">
        <div class="ui green mini horizontal statistic" style="margin-top:20px; margin-left:5%">
            <div class="label">已选： </div>
            <div class="chioce value">0</div>
        </div>

        <div class="ui orange mini horizontal statistic" style="margin-top:20px; margin-left:5%">
            <div class="label">总计： ￥</div>
            <div class="total value">0.0</div>
        </div>

        <div class="submitorder" style="width:80px; height:100%;background:green;float:right;position:relative;bottom:0px;right:0px;top:0px">
            <div class="content button" style="margin-top:25px;margin-left:20px;"><p class="ui white header" style="font-size:1.3rem;color:rgba(255,255,255,0.9)">下单</p></div>
        </div>
    </div>

<script>

function update_content()
{
    var price_all = 0.0;
    var product_num = 0;
    var ids = new Array();
    var nums = new Array();
    $('.grid.product').each(function(i){
        var product_id = $(this).attr('data-id');
        var price = parseFloat( $(this).attr('price') );
        var num = parseInt( $(this).find('.column.number').text() );
        if (num > 0)
        {
            price_all += price * num;
            product_num += num;
            ids.push(product_id);
            nums.push(num);
        }
    });
    $('.chioce.value').text(product_num);
    $('.total.value').text(price_all.toFixed(1));
    return {'prices':price_all.toFixed(1), 'product_num' : product_num, 'product_ids' : ids, 'product_nums' : nums };
}

$(document).ready(function() {
    $('.minus.icon').on('click',function(){
        var num = parseInt( $(this).parent().parent().find('.column.number').text() );
        if (num > 0) num--;
        $(this).parent().parent().find('.column.number').text(num)
        update_content();
    });
    $('.plus.icon').on('click',function(){
        var num = parseInt( $(this).parent().parent().find('.column.number').text() );
        num++;
        $(this).parent().parent().find('.column.number').text(num)
        update_content();
    });

    $('.ui.rating').rating();

    $('.submitorder').on('click', function(){
        var ctx = update_content();
        if (ctx.product_num <= 0)
        {
            alert("没有选择任何东西");
            return;
        }
        $.extend({
            StandardPost:function(url,args){
            var form = $("<form method='post'></form>");
            $(document.body).append(form);
            form.attr({"action":url});
            $.each(args,function(key,value){
                input = $("<input type='hidden'>");
                input.attr({"name":key});
                input.val(value);
                form.append(input);
                });
                form.submit();
            }
       });
       var pid = $('.partner').attr('data-id');
       $.StandardPost('/wx/submit_order',{'id':ctx.product_ids, 'nums' : ctx.product_nums, 'pid':pid});
        
    });

});

</script>
{% endblock %}
{% block footer %}
{% endblock %}
