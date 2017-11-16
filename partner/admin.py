# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin
from django import forms
from PIL import Image
from partner import models

# Register your models here.
admin.site.register(models.Tag)
#admin.site.register(models.Product)
admin.site.register(models.ProductType)
admin.site.register(models.Orders)

class RoomsInline(admin.TabularInline):
    model = models.Rooms

class ProductInline(admin.TabularInline):
    model = models.Product

class PartnerAdminForm(forms.ModelForm):

    def clean_name(self):
        data = self.cleaned_data['name']
        if len(data) <= 3:
            raise forms.ValidationError(u"大于3个汉字")
        return data

    #def clean_img(self):
    #    data = self.cleaned_data['img']
    #    img = Image.open('media/' + data.name)
    #    img.resize(80, 80)
    #    raise forms.ValidationError(str("xx"))

@admin.register(models.Partner)
class PartnerAdmin(admin.ModelAdmin):
    #exclude = ('state', 'judge')
    fields = ('username', ('name', 'phone'), 'welcomemsg', 'img', 
            ('address', 'opentime'), 'tags')
    list_display = ('username', 'name', 'state')
    list_display_links = ('name',)
    list_editable = ('state',)
    search_fields = ('name',)
    inlines = [ProductInline, RoomsInline]
    form = PartnerAdminForm
