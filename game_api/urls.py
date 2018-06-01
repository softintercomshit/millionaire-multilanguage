from django.conf.urls import url
from .views import (
    DifficultiesAPIView,
    LanguagesAPIView,
    BundleAPIView,
    QuestionLangAPIView,
    QuestionModelAPIView,
)

urlpatterns = [
    url(r'^difficulties/$', DifficultiesAPIView.as_view(), name='difficulties'),
    url(r'^languages/$', LanguagesAPIView.as_view(), name='languages'),
    url(r'^questions/$', QuestionModelAPIView.as_view(), name='questions'),
    url(r'^questions/langs/$', QuestionLangAPIView.as_view(), name='questionslangs'),
    url(r'^bundle/(?P<identifier>(.*?))/$', BundleAPIView.as_view(), name='bundle'),
]
