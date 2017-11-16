{% extends "base.tpl" %}

{% block title %}
<title>列表页</title>
{% endblock %}
{% block mainbody %}
<div class="ui container">
    <div class="header">开始</div>
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
    </div>

    <div class="ui container">
    <div class="ui three column grid" style="margin-top:10px;">
        <div class="one wide column"></div>
        <div class="fourteen wide center aligned green column"><h5>登录</h5></div>
        <div class="one wide column"></div>
    </div>
    </div>
</div>

<script>
$(document).ready(function() {
    $('.green.column').api({
            url : '/api/phonelogin',
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
                    location.href = '/wx/user_center';
                } else {
                    alert(response.message);
                }
            },
            onFailure: function(response) {
                alert(response.message);
            },
    });

    $('.ui.verify.button').api({
        url : '/api/verifycode',
        beforeSend: function(settings) {
            if ($("input[name='phone']").val() == '')
            {
                alert('输入手机号');
                return false;
            }
            return settings;
        },
        onSuccess: function(response) {
            $("input[name='verifycode']").val(response.data.vc);
            $(this).addClass("disabled");
        },
        onFailure: function(response) {
            alert("系统忙");
        },
    });
});
</script>
{% endblock %}

