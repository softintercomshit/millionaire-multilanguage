from rest_framework.generics import ListAPIView, RetrieveAPIView
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST
from rest_framework.permissions import AllowAny
from .serializers import (
    DifficultiesSerializer,
    LanguagesSerializer,
    BundleSerializer,
    QuestionLangSerializer,
)
from bundle.models import BundleModel
from difficulty.models import Difficulty
from question.models import QuestionLang, QuestionModel
from languages.models import Language


class DifficultiesAPIView(ListAPIView):
    permission_classes = (AllowAny,)
    queryset = Difficulty.objects.all()
    serializer_class = DifficultiesSerializer


class LanguagesAPIView(ListAPIView):
    permission_classes = (AllowAny,)
    queryset = Language.objects.all()
    serializer_class = LanguagesSerializer


class BundleAPIView(RetrieveAPIView):
    permission_classes = (AllowAny,)
    lookup_field = 'identifier'
    queryset = BundleModel.objects.all()
    serializer_class = BundleSerializer


class QuestionModelAPIView(ListAPIView):
    permission_classes = (AllowAny,)
    queryset = QuestionModel.objects.all()

    def get(self, request, *args, **kwargs):
        result = []
        difficulties = Difficulty.objects.all()
        for difficulty in difficulties:
            question_model_query_set = QuestionModel.objects.filter(difficulty=difficulty)
            question_list = []
            for question_model in question_model_query_set:
                question_list.append({'id': question_model.id, 'label': question_model.label})
            result.append({'{}'.format(difficulty.level): question_list})
        return Response(result, status=HTTP_200_OK)


class QuestionLangAPIView(ListAPIView):
    permission_classes = (AllowAny,)
    queryset = QuestionLang.objects.all()
    serializer_class = QuestionLangSerializer
