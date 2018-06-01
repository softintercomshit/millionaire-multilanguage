from rest_framework.serializers import ModelSerializer
from ..models import InsertsHistory, UpdatesHistory, RemovesHistory


class InsertsHistorySerializer(ModelSerializer):
    class Meta:
        model = InsertsHistory
        fields = '__all__'
