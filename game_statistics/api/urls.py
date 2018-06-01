from django.conf.urls import url
from .views import AppendStatisticsAPIView, AppendBulkStatisticsAPIView, BugReportAPIView, TestAPIView


urlpatterns = [
    url(r'^appendstatistics/$', AppendStatisticsAPIView.as_view(), name='appendstatistics'),
    url(r'^appendbulkstatistics/$', AppendBulkStatisticsAPIView.as_view(), name='appendbulkstatistics'),
    url(r'^bugreport/$', BugReportAPIView.as_view(), name='bugreport'),
    url(r'^test/$', TestAPIView.as_view(), name='bugreport'),
]