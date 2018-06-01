from ..models import StatisticsModel
from rest_framework.serializers import ModelSerializer, RelatedField
from ..models import BugReportsModel


class AppendStatisticsSerializer(ModelSerializer):
    class Meta:
        model = StatisticsModel
        exclude = ('id',)


class BugReportSerializer(ModelSerializer):
    class Meta:
        model = BugReportsModel
        exclude = ('id',)