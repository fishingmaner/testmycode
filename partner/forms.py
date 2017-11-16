from django import forms
from .models import MyModel

class ImgForm(forms.ModelForm):
  img = forms.ChoiceField(choices=[...], widget=forms.RadioSelect())

    class Meta:
        model = MyModel
        fields = ['id', 'xxx']
