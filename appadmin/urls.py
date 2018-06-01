from django.conf.urls import url, include
from question.views import AddQuestionFormView, AddQuestionAPIView
from .views import (
    BundleListView,
    BundleDetailView,
    QuestionEditView,
    EditQuestionAPIView,
    DeleteQuestionAPIView,
)


urlpatterns = [
    url(r'^$', BundleListView.as_view(), name='bundle_list'),
    url(r'^(?P<pk>\d+)/$', BundleDetailView.as_view(), name='bundle_detail'),
    url(r'^(?P<pk>\d+)/add/', AddQuestionFormView.as_view(), name='add_question_form'),
    url(r'^questionapi/$', AddQuestionAPIView.as_view(), name='add_question_api'),
    url(r'^edit/(?P<pk>\d+)/$', QuestionEditView.as_view(), name='question_edit'),
    url(r'^edit/question/(?P<pk>\d+)/$', EditQuestionAPIView.as_view(), name='question_edit_api'),
    url(r'^delete/question/(?P<pk>\d+)/$', DeleteQuestionAPIView.as_view(), name='question_delete_api'),
]