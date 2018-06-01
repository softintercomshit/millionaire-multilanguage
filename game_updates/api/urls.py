from django.conf.urls import url
from .views import InsertsHistoryAPIView, UpdatesHistoryAPIView, RemovesHistoryAPIView

urlpatterns = [
    url(r'^getinserts/(?P<db_version>(.*?))/(?P<bundle>(.*?))/$', InsertsHistoryAPIView.as_view(),
        name='inserts_history'),
    url(r'^getupdates/(?P<db_version>(.*?))/(?P<bundle>(.*?))/$', UpdatesHistoryAPIView.as_view(),
        name='updates_history'),
    url(r'^getremoves/(?P<db_version>(.*?))/(?P<bundle>(.*?))/$', RemovesHistoryAPIView.as_view(),
        name='removes_history'),
]
