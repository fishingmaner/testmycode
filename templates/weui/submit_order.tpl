{% extends "base.tpl" %}

{% block title %}
<title>订单详情</title>
{% endblock %}
{% block mainbody %}
<div class="container">
    <div class="weui-media-box weui-media-box_text">
        <h3 class="weui-media-box__title">{{ partner.name }}</h3>
        <p class="weui-media-box__desc">{{ partner.address }}</p>
    </div>

    <div class="weui-cells__title partner" data-id={{ partnerid }}><h5>共{{ count }}道菜 ￥{{ price }}</h5></div>
    <div class="weui-cells">
        {% for product in products %}
        <div class="weui-cell product"  data-id={{ product.id }} data-price={{ product.price }} data-num={{ product.num }}>
            <div class="weui-cell__hd"><img src="{{ product.img_url }}" alt="" style="width:20px;margin-right:5px;display:block"></div>
            <div class="weui-cell__bd">
                <p>{{ product.name }}</p>
            </div>
            <div class="weui-cell__ft">{{ product.num }}</div>
        </div>
        {% endfor %}
    </div>

    <div class="page__bd">
    <div class="weui-cells weui-cells_form">
        <div class="weui-cell weui-cell_switch">
            <div class="weui-cell__bd">是否需要包间</div>
            <div class="weui-cell__ft">
                <input class="weui-switch" name="room" type="checkbox">
            </div>
        </div>

        <div class="weui-cell weui-cell_vcode cell_phone">
            <div class="weui-cell__hd"><label class="weui-label">手机号</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="phone" type="tel" value="{{ userextends.phone }}" placeholder="请输入手机号">
            </div>
            <div class="weui-cell__ft">
                <button class="weui-vcode-btn">获取验证码</button>
            </div>
        </div>

        <div class="weui-cell vcode">
            <div class="weui-cell__hd"><label class="weui-label">验证码</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="number" name="vcode" pattern="[0-9]*" placeholder="输入收到的验证码">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label for="" class="weui-label">日期</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="date" name="bookdate" value="{{bookdate}}" placeholder="">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label for="" class="weui-label">时间</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="time" name="booktime" value="{{ booktime}}" placeholder="10:08">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__bd">
                <textarea class="weui-textarea" placeholder="备注" name="note" rows="3"></textarea>
            <div class="weui-textarea-counter"><span>0</span>/200</div>
        </div>
    </div>
</div>
</div>

    <div class="bottombar submit" style="text-align:center;border-left-width:0px;border-bottom-width:0px;border-right:0px;background-color:#09bb07;">
        <p style="font-size:2.0rem;color:white;">完成</p>
    </div>

    <div style="height:70px"></div>
<script>
function choiceid()
{
    var ids = new Array();

    $('.weui-cell.product').each(function(i){
        ids.push({
            'num': parseInt( $(this).attr('data-num') ),
            'price': parseFloat( $(this).attr('data-price') ),
            'id' : parseFloat( $(this).attr('data-id') ),
        });
    });
    return ids;
}

$(document).ready(function() {
    if ($("input[name='phone']").val() != '')
    {
        $('.weui-vcode-btn').hide();
        $('.weui-cell.cell_phone').removeClass('weui-cell_vcode');
        $('.weui-cell.vcode').hide();
    }
    $('.weui-vcode-btn').on('click', function(){
        var phone = $("input[type='tel']").val();
        $.post("/api/verifycode", { 'phone': phone} ,
            function(data){
                alert(data.message);
                if (data.code == 0)
                {
                    $('.weui-vcode-btn').attr('disabled', 'disabled');
                    $('.weui-vcode-btn').text('(50s)');
                }
            }, 'json'
        );
    });

    $('.showDatePicker').on('click', function () {
        weui.datePicker({
            start: 1990,
            end: new Date().getFullYear(),
            onChange: function (result) {
                console.log(result);
            },
            onConfirm: function (result) {
                console.log(result);
            }
        });
    });

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
    var bookdate = $("input[name='bookdate']").val();
    var needroom = 'off';
    var note = $("textarea[name='note']").val();
    var phone = $("input[name='phone']").val();
    var vcode = $("input[name='vcode']").val();

    if ($("input[name='room']").is(':checked'))
    {
        needroom = 'on';
    }
    post_data = { pid: pid, ids: ids, booktime : booktime, bookdate : bookdate, needroom : needroom, note : note, vcode:vcode, phone:phone };

    $.ajax({
        type : 'POST',
        url : "/api/create_order",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(post_data),
        dataType: 'json',
        success : function(data){
            if (data.code == 1)
            {
                alert(data.message);
                $('.weui-vcode-btn').show();
                $('.weui-cell.cell_phone').addClass('weui-cell_vcode');
                $('.weui-cell.vcode').show();
            } else if (data.code == 2)
            {
                alert(data.message);
            } else {
                location.href = '/wx/order?id='+ data.data.id;
            }
        }
    });
}
</script>
{% endblock %}
{% block footer %}
{% endblock %}

