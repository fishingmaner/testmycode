"""book URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.contrib import admin
from weixin import views as wxviews
from partner import views as pviews
from userextends import views as ueviews

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^wx/post', wxviews.post),
    url(r'^wx/booking', wxviews.booking),
    url(r'^wx/submit_order', wxviews.submit_order),
    url(r'^wx/user_center', wxviews.user_center),
    url(r'^wx/hot', wxviews.hot),
    url(r'^wx/list', wxviews.list),
    url(r'^wx/collect', wxviews.collect),
    url(r'^wx/order', wxviews.order),
    url(r'^wx/logout', wxviews.wxlogout),
    url(r'^wx/login', wxviews.wxlogin),
    url(r'^wx/partner/order', wxviews.partner_order),
    url(r'^wx/partner', wxviews.partner),
    url(r'^api/create_order', pviews.create_order),
    url(r'^api/verifycode', ueviews.verifycode),
    url(r'^api/phonelogin', ueviews.phonelogin),
    url(r'^api/phonesupply', ueviews.phonesupply),
    url(r'^api/cancel_order', pviews.cancel_order),
    url(r'^api/accept_order', pviews.accept_order),
    url(r'^api/dismiss_order', pviews.dismiss_order),
]
