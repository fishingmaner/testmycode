{% extends "base.tpl" %}

{% block title %}
<title>{{ partner.name }}</title>
{% endblock %}
{% block mainbody %}
<style>
    body {
        font-size: 14px;
        background-color: #f8f8f8;
        //background-image:url({{partner.img_url}});
        //background-size:100% 100%;
    }

    .placeholder {
        margin: 5px;
        //padding: 0 10px;
        background-color: white;
        height: 3.9em;
        width:3.9em;
        line-height: 2.3em;
        text-align: center;
        color: #cfcfcf;
     }

     .menu {
        margin: 0px;
        width: 28%;
        height:100%;
        background-color: white;
        float:left;
        position: absolute;
    }
    .page__bd {
        width:70%;
        float:right;
        background-color: white;
    }

    .screen {
        background-image:url({{ partner.img_url }});
        margin-top:-10px;
        margin-bottom:10px;
        height:12rem;
        background-color: white;
        //filter:alpha(Opacity=80);
        //-moz-opacity:0.2;
        //opacity: 0.2;
    }

    .weui-flex {
        border-bottom: 2px solid #f8f8f8;
    }

    .weui-flex img {
        height:100%;
        width:100%;
    }

    .weui-flex h5 {
        margin-top:5px;
    }

    .weui-flex p {
        color:orange;
    }

    .menu div {
        margin: 5px;
        background-color: white;
        height: 3.0em;
        line-height: 3.0em;
        text-align: center;
        border-bottom: 1px solid #ddd;
     }

     .weui-flex .choice {
        margin-left: 10px;
    }

    .container div:last-child {
        border-bottom: 0px;
    }

    .title {
        font-size:1rem;
        padding:5px 0px 0px 5px;
    }
    .info {
        background-color:#f8f8f8;
        width:80%;
        height:10rem;
        margin:1rem 10% 1rem 10%;
        position:absolute;
    }
    body span {
        position: absolute;
        top: 10px;
        left: 20px;
        display: block;
        padding: 10px;
        color: #336688
    }
</style>

<div class="container">
    <div class="screen">
        <div class="info"></div>
    </div>

    <div class="menu" id="menu" data-id="{{ partner.id }}">
        {% for key,products in items.items %}
        <div>{{ key }}</div>
        {% endfor %}
    </div>

    <div class="page__bd page__bd_spacing">
        {% for key,products in items.items %}
        <div class="title">{{ key }}</div>
        {% for product in products %}
        <div class="weui-flex">
            <div class="placeholder"><img src="{{ product.img_url }}" /></div>
            <div class="weui-flex__item">
                <h5 class="">{{ product.name }}</h5>
                <p class=""><font>￥{{ product.price }}</font><font style="color:grey; font-size:10px"> /份</font></p>
            </div>
            <div class="weui-flex__item">
                <div class="choice" data-id="{{ product.id }}" price="{{ product.price }}" data-num=0>
                    <i class="minus green large icon"></i>
                    <font class="amount" >0</font>
                    <i class="plus green large icon"></i>
                </div>
            </div>
        </div>
        {% endfor %}
        {% endfor %}
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
            <div class="content button" style="margin-top:25px;margin-left:20px;"><p class="ui white header" style="font-size:1.3rem;color:rgba(255,255,255,0.9)">选好了</p></div>
        </div>
    </div>

<script>

function update_content()
{
    var price_all = 0.0;
    var product_num = 0;
    var ids = new Array();
    var nums = new Array();
    $('.choice').each(function(i){
        var product_id = $(this).attr('data-id');
        var price = parseFloat( $(this).attr('price') );
        var num = parseInt( $(this).find('.amount').text() );
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
        var num = parseInt( $(this).parent().find('.amount').text() );
        if (num > 0) num--;
        $(this).parent().find('.amount').text(num);
        update_content();
    });
    $('.plus.icon').on('click',function(){
        var num = parseInt( $(this).parent().find('.amount').text() );
        num++;
        $(this).parent().find('.amount').text(num);
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
       var pid = $('.menu').attr('data-id');
       $.StandardPost('/wx/submit_order',{'id':ctx.product_ids, 'nums' : ctx.product_nums, 'pid':pid});
        
    });

    var menu_top = document.getElementById('menu').offsetTop;
    window.onscroll = function () {
        HoverTreeMove( document.getElementById('menu'), menu_top);
    };

    wsinit();
});

function HoverTreeMove(obj,top)
{
    console.log(top);
    var h_scrollTop = document.documentElement.scrollTop || document.body.scrollTop;//滚动的距离

    if ( top <= h_scrollTop )
    {
        obj.style.top = h_scrollTop + "px";
    } else {
        obj.style.top = "auto";
    }
    return;
    var h_buchang = 20;
    if (obj.offsetTop < h_scrollTop + top - h_buchang)
    {
        obj.style.top = obj.offsetTop + h_buchang + "px";
        setTimeout(function () { HoverTreeMove(obj, top); }, 80);
    } else if (obj.offsetTop > h_scrollTop + top + h_buchang)
    {
        obj.style.top = (obj.offsetTop - h_buchang) + "px";
        setTimeout(function () { HoverTreeMove(obj, top); }, 80);
    } else {
        obj.style.top = h_scrollTop + top + "px";
    }
}

function createEle(txt, cw, ch) {
    //动态生成span标签
    var oMessage = document.createElement('span');   //创建标签
    oMessage.innerHTML = txt;   //接收参数txt并且生成替换内容
    oMessage.style.left = cw + 'px';  //初始化生成位置x
    document.body.appendChild(oMessage);
    roll.call(oMessage, {
    //call改变函数内部this的指向
    timing: ['linear', 'ease-out'][~~(Math.random() * 2)],
            color: '#' + (~~(Math.random() * (1 << 24))).toString(16),
            top: random(0, ch),
            fontSize: random(16, 32)
    });
}
function roll(opt) {
    //弹幕滚动
    //如果对象中不存在timing 初始化
    opt.timing = opt.timing || 'linear';
    opt.color = opt.color || '#fff';
    opt.top = opt.top || 0;
    opt.fontSize = opt.fontSize || 16;
    this._left = parseInt(this.offsetLeft);   //获取当前left的值
    this.style.color = opt.color;   //初始化颜色
    var h_scrollTop = document.documentElement.scrollTop || document.body.scrollTop;//滚动的距离
    this.style.top = (opt.top + h_scrollTop) + 'px';
    this.style.fontSize = opt.fontSize + 'px';
    this.timer = setInterval(function () {
        if (this._left <= -150) {
            clearInterval(this.timer);   //终止定时器
            this.parentNode.removeChild(this);
            return;   //终止函数
        }
        switch (opt.timing) {
            case 'linear':   //如果匀速
                this._left += -2;
                break;
            case 'ease-out':   //
                this._left += (0 - this._left) * .01;
                break;
        }
        this.style.left = this._left + 'px';
    }.bind(this), 1000 / 60);
}
function random(start, end) {
    //随机数封装
    return start + ~~(Math.random() * (end - start));
}

// web socket
var ws;
function wsinit() {
    // Connect to Web Socket
    ws = new WebSocket("ws://sc.kangyanping.com:9001/");
    // Set event handlers.
    ws.onopen = function() {
        ws.send("{ \"action\":\"sub\", \"uuid\":\"123\" }");
    };
                        
    ws.onmessage = function(e) {
        // e.data contains received string.
        console.log(e.data);
        var obj = JSON.parse(e.data);
        var cW = document.body.offsetWidth;
        var cH = document.body.offsetHeight;
        str = "增加的有以下:";
        for(var i=0;i<obj.add.length;i++){
            str = str + obj.add[i];
        }
        createEle(str, cW, cH);   //执行节点创建模块
    };
                                                                                             
    ws.onclose = function() {
        console.log("onclose");
    };

    ws.onerror = function(e) {
        console.log(e)
    };
}
</script>
{% endblock %}
{% block footer %}
{% endblock %}
