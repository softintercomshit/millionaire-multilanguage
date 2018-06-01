from ..models import InsertsHistory, UpdatesHistory, RemovesHistory
from rest_framework.generics import ListAPIView
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK
from rest_framework.permissions import AllowAny
from question.models import QuestionLang
from bundle.models import BundleModel


class InsertsHistoryAPIView(ListAPIView):
    permission_classes = (AllowAny,)

    def get(self, request, *args, **kwargs):
        db_version = float(self.kwargs['db_version'])
        bundle_id = self.kwargs['bundle']
        bundle_model = BundleModel.objects.get(identifier=bundle_id)

        question_model_set = set()

        query_set = InsertsHistory.objects.filter(db_version__gt=db_version, bundle=bundle_model)

        if query_set.exists():
            for item in query_set:
                question_model_set.add(item.question_model)

        question_model_list = []
        question_lang_model_list = []

        for question_model in question_model_set:
            question_model_dict = {'id': question_model.id, 'difficulty': question_model.difficulty_id,
                                   'label': question_model.label}
            question_model_list.append(question_model_dict)

            question_lang_query_set = QuestionLang.objects.filter(question=question_model)
            if question_lang_query_set.exists():
                for question_lang_model in question_lang_query_set:
                    question_lang_id = question_lang_model.id
                    text = question_lang_model.text
                    answer1 = question_lang_model.answer1
                    answer2 = question_lang_model.answer2
                    answer3 = question_lang_model.answer3
                    answer4 = question_lang_model.answer4
                    correct_answer = question_lang_model.correct_answer
                    question_id = question_lang_model.question_id
                    language_id = question_lang_model.language_id
                    question_lang_model_dict = {'id': question_lang_id, 'text': text, 'answer1': answer1,
                                                'answer2': answer2, 'answer3': answer3, 'answer4': answer4,
                                                'correct_answer': correct_answer, 'question': question_id,
                                                'language': language_id}
                    question_lang_model_list.append(question_lang_model_dict)

        return Response({'question_model': question_model_list, 'question_lang_model': question_lang_model_list},
                        status=HTTP_200_OK)


class UpdatesHistoryAPIView(ListAPIView):
    permission_classes = (AllowAny,)

    def get(self, request, *args, **kwargs):
        db_version = float(self.kwargs['db_version'])
        bundle_id = self.kwargs['bundle']
        bundle_model = BundleModel.objects.get(identifier=bundle_id)

        question_model_set = set()
        question_lang_model_set = set()

        query_set = UpdatesHistory.objects.filter(db_version__gt=db_version, bundle=bundle_model)

        if query_set.exists():
            for item in query_set:
                question_model_set.add(item.question_model)
                question_lang_model_set.add(item.question_lang)

        question_model_list = []
        question_lang_model_list = []

        for question_model in question_model_set:
            question_model_dict = {'id': question_model.id, 'difficulty': question_model.difficulty_id,
                                   'label': question_model.label}
            question_model_list.append(question_model_dict)

        for question_lang_model in question_lang_model_set:
            question_lang_id = question_lang_model.id
            text = question_lang_model.text
            answer1 = question_lang_model.answer1
            answer2 = question_lang_model.answer2
            answer3 = question_lang_model.answer3
            answer4 = question_lang_model.answer4
            correct_answer = question_lang_model.correct_answer
            question_id = question_lang_model.question_id
            language_id = question_lang_model.language_id
            question_lang_model_dict = {'id': question_lang_id, 'text': text, 'answer1': answer1,
                                        'answer2': answer2, 'answer3': answer3, 'answer4': answer4,
                                        'correct_answer': correct_answer, 'question': question_id,
                                        'language': language_id}
            question_lang_model_list.append(question_lang_model_dict)

        return Response({'question_model': question_model_list, 'question_lang_model': question_lang_model_list},
                        status=HTTP_200_OK)


class RemovesHistoryAPIView(ListAPIView):
    permission_classes = (AllowAny,)

    def get(self, request, *args, **kwargs):
        db_version = float(self.kwargs['db_version'])
        bundle_id = self.kwargs['bundle']
        bundle_model = BundleModel.objects.get(identifier=bundle_id)

        question_model_ids_set = set()
        question_lang_model_ids_set = set()

        query_set = RemovesHistory.objects.filter(db_version__gt=db_version, bundle=bundle_model)

        if query_set.exists():
            for item in query_set:
                if item.question_model_id:
                    question_model_ids_set.add(item.question_model_id)
                if item.question_lang_id:
                    question_lang_model_ids_set.add(item.question_lang_id)

        return Response(
            {'question_model_ids': question_model_ids_set, 'question_lang_model_ids': question_lang_model_ids_set},
            status=HTTP_200_OK)
