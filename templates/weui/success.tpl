{% extends "base.tpl" %}

{% block title %}
<title>支付成功</title>
{% endblock %}
{% block mainbody %}
    <div class="weui-msg">
        <div class="weui-msg__icon-area"><i class="weui-icon-success weui-icon_msg"></i></div>
        <div class="weui-msg__text-area">
            <h2 class="weui-msg__title">操作成功</h2>
            <p class="weui-msg__desc">内容详情，可根据实际需要安排，如果换行则不超过规定长度，居中展现<a href="javascript:void(0);">文字链接</a></p>
        </div>
        <div class="weui-msg__opr-area">
            <p class="weui-btn-area">
                <a href="javascript:history.back();" class="weui-btn weui-btn_primary">推荐操作</a>
                <a href="javascript:history.back();" class="weui-btn weui-btn_default">辅助操作</a>
            </p>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        $('.weui-footer').addClass('weui-footer_fixed-bottom');
    });
    </script>
{% endblock %}
