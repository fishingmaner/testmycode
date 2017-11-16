{% extends "base.tpl" %}

{% block title %}
<title>订单详情</title>
{% endblock %}
{% block mainbody %}
<div class="ui container">

<div class="ui dividing header">
    <div class="ui column grid">

        <div class="four wide column">
            <div class="content">
                <div class="ui tiny image">
                    <img src="{{ userextends.headimgurl }}">
                </div>
            </div>
        </div>

        <div class="ten wide column">
            <div class="content" ><span>{{ userextends.nickname }}</span> </div>
        </div>

        <div class="two wide column">
            <!-- <div class="content"><div class="ui form"><input type="text" name="shipping[first-name]" placeholder="手机号"></div></div> --!>
        </div>

    </div>
</div>

{% include "step.tpl" %}

<div class="ui list">
    <div class="item">
        <i class="large middle aligned add to calendar icon"></i> 
        <div class="content">
            <a class="header">预定时间</a>
            <div class="ui form"><input name="booktime" type="time" value="{{ booktime }}" /></div>
       </div>
    </div>
</div>

<div class="ui dividing header">
<div class="ui content">
    <span>菜单</span>
    <span class="orange"><div class="partner" data-id={{ partnerid }}></div><h5>共{{ count }}道菜 ￥{{ price }}</h5></span>
</div>
</div>

<div class="ui middle aligned divided list">
    {% for product in products %}
    <div class="product item" data-id={{ product.id }} data-price={{ product.price }} data-num={{ product.num }}>
        <span class="right floated">{{ product.num }}</span>
        <img class="ui avatar image" src="{{ product.img_url }}">
        <div class="content">
            <a class="header">{{ product.name }}</a>
        </div>
    </div>
    {% endfor %}
</div>

<div class="ui middle aligned divided list">
    <div class="ui form">
        <div class="ui toggle checkbox">
            <input name="needroom" type="checkbox" value="off">
            <label>是否需要包间，当前状态为不需要</label>
        </div>
    </div>
</div>

<div class="ui dividing header">备注</div>
<div class="ui form"><textarea name="note"></textarea></div>

<div class="ui modal">
    <div class="header">确认联系方式</div>
    <div class="content">
        <form class="ui form signin">
            <div class="inline field">
                <input type="text" placeholder="您的手机号" name="phone" />
            </div>
            <div class="inline field">
                <input type="text" placeholder="输入收到的验证码" name="verifycode" />
                <div class="ui blue verify button">验证码</div>
            </div>
        </form>
    </div>
    <div class="actions">
        <div class="ui green login button">确定</div>
    </div>
</div>

</div>

    <div class="bottombar submit" style="border-left-width:0px;border-bottom-width:0px;border-right:0px;background-color:green;">
        <div class="ui grid" style="margin-top: 0px;margin-left:0px;margin-bottom:0px;margin-right:0px;">
            <div class="center aligned column">
                <span style="font-size:2rem;margin-top:0rem;color:rgba(255,255,255,0.9);">完成</span>
            </div>
        </div>
    </div>

    <div style="height:70px"></div>
<script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script>

function choiceid()
{
    var ids = new Array();

    $('.product.item').each(function(i){
        ids.push({
            'num': parseInt( $(this).attr('data-num') ),
            'price': parseFloat( $(this).attr('data-price') ),
            'id' : parseFloat( $(this).attr('data-id') ),
        });
    });
    return ids;
}

$(document).ready(function() {
    $('.ui.login.button').api({
        url : '/api/phonesupply',
        method : 'POST',
        beforeSend: function(settings) {
            phone = $("input[name='phone']").val();
            verifycode = $("input[name='verifycode']").val();
            settings.data.phone = phone;
            settings.data.verifycode = verifycode;
            return settings;
        },
        onSuccess: function(response) {
            if (response.code == 0)
            {
                complete_order();
            } else {
                alert(response.message);
            }
        },
    });

    $('.ui.verify.button').api({
        url : '/api/verifycode',
        method: 'POST',
        beforeSend: function(settings) {
            var phone = $("input[name='phone']").val();
            if (phone == '')
            {
                alert('输入手机号');
                return false;
            }
            settings.data.phone = phone;
            return settings;
        },
        onSuccess: function(response) {
            alert(response.message)
            $(this).addClass("disabled");
        },
        onFailure: function(response) {
            alert(response.message);
        },
    });
    //$('.ui.checkbox').checkbox('checked');
    $('.bottombar.submit').on('click', function(){
        complete_order();
    });

    $('.order').addClass('current');
    $('.accept').addClass('unstart');
    $('.pay').addClass('unstart');
    $('.eat').addClass('unstart');
});

function complete_order()
{
    var pid = $('.partner').attr('data-id');
    var ids = choiceid();
    var booktime = $("input[name='booktime']").val();
    var needroom = $('.ui.checkbox').checkbox('is checked');
    var note = $("textarea[name='note']").val();

    post_data = { pid: pid, ids: ids, booktime : booktime, needroom : needroom, note : note };
    $.ajax({
        type : 'POST',
        url : "/api/create_order",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(post_data),
        dataType: 'json',
        success : function(data){
            if (data.code != 0)
            {
                $('.ui.modal').modal('show');
            } else {
                location.href = '/wx/order?id='+ data.data.id;
            }
        }
    });
}
</script>
{% endblock %}
