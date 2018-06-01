from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST, HTTP_201_CREATED
from rest_framework.permissions import AllowAny
from rest_framework.generics import CreateAPIView, RetrieveAPIView
from ..models import StatisticsModel, BugReportsModel
from .serializers import AppendStatisticsSerializer, BugReportSerializer
from difficulty.models import Difficulty
from question.models import QuestionLang
import datetime
import json


class AppendStatisticsAPIView(CreateAPIView):
    permission_classes = (AllowAny,)
    queryset = StatisticsModel.objects.all()
    serializer_class = AppendStatisticsSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        try:
            serializer.is_valid(raise_exception=True)
        except Exception as e:
            print(e)
            return Response({'success': False}, status=HTTP_400_BAD_REQUEST)

        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)

        return Response({'success': True}, status=HTTP_201_CREATED)


class AppendBulkStatisticsAPIView(CreateAPIView):
    permission_classes = (AllowAny,)

    def create(self, request, *args, **kwargs):
        counter = 0
        error_counter = 0

        params = json.loads(request.POST.get(''))

        for item in params:
            counter += 1
            answer = item['answer']
            difficulty = int(float(item['difficulty']))
            game_play_id = item['game_play_id']
            question = int(float(item['question']))
            timestamp = float(item['datetime'])
            date_time = datetime.datetime.fromtimestamp(timestamp)

            difficulty_model = Difficulty.objects.get(pk=difficulty)
            question_model = QuestionLang.objects.get(pk=question)
            try:
                statistics_model = StatisticsModel.objects.create(
                    question=question_model,
                    difficulty=difficulty_model,
                    answer=answer,
                    game_play_id=game_play_id,
                    datetime=date_time
                )
                statistics_model.save()
            except Exception as e:
                error_counter += 1

        if error_counter == counter:
            return Response({'success': False}, status=HTTP_400_BAD_REQUEST)

        return Response({'success': True}, status=HTTP_201_CREATED)


class BugReportAPIView(CreateAPIView):
    permission_classes = (AllowAny,)
    queryset = BugReportsModel.objects.all()
    serializer_class = BugReportSerializer


class TestAPIView(RetrieveAPIView):
    permission_classes = (AllowAny,)

    def get(self, request, *args, **kwargs):
        from django.db.models import Count

        query_set = QuestionLang.objects.all().values('question__difficulty').annotate(dcount=Count('question'))
        for item in query_set:
            print('difficulty: {} -----------> {}'.format(item['question__difficulty'], item['dcount']))

        return Response('success', status=HTTP_200_OK)
