from django.views.generic.edit import FormView
from django import forms
from languages.models import Language
from bundle.models import BundleModel
from difficulty.models import Difficulty
from question.models import QuestionModel, QuestionLang
from django.db.utils import IntegrityError
from rest_framework.generics import (RetrieveAPIView, CreateAPIView, ListCreateAPIView, )
from rest_framework.permissions import (IsAdminUser, AllowAny, IsAuthenticated, )
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST
from django.utils.decorators import method_decorator
from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect
from game_updates.models import InsertsHistory

try:
    LANGUAGE_CHOICES = tuple([(language.id, language.name) for language in Language.objects.all()])
    DIFFICULTY_CHOICES = tuple([(difficulty.id, difficulty.level) for difficulty in Difficulty.objects.all()])
except Exception as e:
    LANGUAGE_CHOICES = ((0, 0),)
    DIFFICULTY_CHOICES = ((0, 0),)


class QuestionForm(forms.Form):
    try:
        language = forms.ChoiceField(choices=LANGUAGE_CHOICES, initial=LANGUAGE_CHOICES[0])
        difficulty = forms.ChoiceField(choices=DIFFICULTY_CHOICES, initial=DIFFICULTY_CHOICES[0])
        question = forms.CharField()
        answer1 = forms.CharField()
        answer2 = forms.CharField()
        answer3 = forms.CharField()
        answer4 = forms.CharField()
    except IndexError as e:
        print(e)
        pass


@method_decorator(login_required(login_url='/adminsecret/login/'), name='dispatch')
class AddQuestionFormView(FormView):
    form_class = QuestionForm
    template_name = 'question/add_question_form.html'

    def get(self, request, *args, **kwargs):
        try:
            BundleModel.objects.get(pk=self.kwargs['pk'])
            return self.render_to_response(self.get_context_data())
        except Exception as e:
            return redirect('/')

    def get_context_data(self, **kwargs):
        context = super(AddQuestionFormView, self).get_context_data(**kwargs)
        context['bundle'] = BundleModel.objects.get(pk=self.kwargs['pk'])
        return context


class AddQuestionAPIView(CreateAPIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request, *args, **kwargs):
        language_id = request.data['language']
        difficulty_id = request.data['difficulty']
        bundle_id = request.data['bundle']
        question = request.data['question']
        answer1 = request.data['answer1']
        answer2 = request.data['answer2']
        answer3 = request.data['answer3']
        answer4 = request.data['answer4']
        correct_answer = request.data['correct_answer']

        try:
            language_model = Language.objects.filter(pk=language_id).first()
            bundle_model = BundleModel.objects.filter(pk=bundle_id).first()
            difficulty_model = Difficulty.objects.filter(pk=difficulty_id).first()
            question_model, _ = QuestionModel.objects.get_or_create(
                difficulty=difficulty_model,
                bundle=bundle_model,
                label=question
            )
            question_language_model = QuestionLang.objects.create(
                question=question_model,
                language=language_model,
                text=question,
                answer1=answer1,
                answer2=answer2,
                answer3=answer3,
                answer4=answer4,
                correct_answer=correct_answer
            )
            question_language_model.save()
            bundle_model.db_version += 0.1
            bundle_model.save()

            """add question to history for InsertsModel"""
            try:
                inserts_history_model = InsertsHistory.objects.create(question_model=question_model,
                                                                      db_version=bundle_model.db_version,
                                                                      bundle=bundle_model)
                inserts_history_model.save()
            except Exception as e:
                pass

            return Response('Question was successfully added.', status=HTTP_200_OK)
        except IntegrityError as e:
            print(e)
            return Response('Question with same language already exists in db or difficulty is not right.',
                            status=HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response(e, status=HTTP_400_BAD_REQUEST)
