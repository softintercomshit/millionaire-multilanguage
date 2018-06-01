from bundle.models import BundleModel
from django.views.generic import ListView, DetailView
from django.views.generic.edit import FormView
from question.models import QuestionModel, QuestionLang
from difficulty.models import Difficulty
from django.utils.decorators import method_decorator
from django.contrib.auth.decorators import login_required
from django import forms
from rest_framework.permissions import IsAuthenticated
from rest_framework.generics import UpdateAPIView, DestroyAPIView
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST
import math
from django.shortcuts import redirect
from game_updates.models import UpdatesHistory, RemovesHistory


@method_decorator(login_required, name='dispatch')
class BundleListView(ListView):
    model = BundleModel
    template_name = 'appadmin/index.html'


@method_decorator(login_required, name='dispatch')
class BundleDetailView(DetailView):
    model = BundleModel
    template_name = 'appadmin/bundle_detail.html'

    def get(self, request, *args, **kwargs):
        try:
            _ = BundleModel.objects.get(pk=self.kwargs['pk'])
            self.object = self.get_object()
            context = self.get_context_data(object=self.object)
            return self.render_to_response(context)
        except Exception as e:
            return redirect('/')

    def get_context_data(self, **kwargs):
        context = super(BundleDetailView, self).get_context_data(**kwargs)
        bundle = kwargs['object']

        index_to_delete = self.request.GET.get('delete', None)
        if index_to_delete:
            try:
                QuestionModel.objects.get(pk=index_to_delete).delete()
                bundle.db_version += 0.1
                bundle.save()
                removes_history_model = RemovesHistory.objects.create(question_model_id=index_to_delete,
                                                                      bundle=bundle,
                                                                      db_version=bundle.db_version)
                removes_history_model.save()
            except:
                pass

        text = self.request.GET.get('q', None)
        if not text:
            query_set = QuestionModel.objects.filter(bundle=bundle).order_by('difficulty__level')
        else:
            query_set = QuestionModel.objects.filter(bundle=bundle, label__contains=text).order_by(
                'difficulty__level')

        items_per_page = 50
        max_pages = math.ceil(query_set.count() / items_per_page)
        page = self.request.GET.get('page')

        try:
            page = int(float(page))
            if page not in range(1, max_pages + 1):
                raise TypeError
        except TypeError:
            page = 1

        min_index = page * items_per_page - items_per_page
        max_index = min_index + items_per_page

        context['questions'] = query_set[min_index:max_index]
        context['pages'] = range(max_pages)
        context['current_page'] = page

        return context


try:
    DIFFICULTY_CHOICES = tuple([(difficulty.id, difficulty.level) for difficulty in Difficulty.objects.all()])
except Exception as e:
    DIFFICULTY_CHOICES = ((0, 0),)


class QuestionForm(forms.Form):
    difficulty = forms.ChoiceField(choices=DIFFICULTY_CHOICES, initial=DIFFICULTY_CHOICES[0])
    language = forms.ChoiceField(disabled=True)
    question = forms.CharField()
    answer1 = forms.CharField()
    answer2 = forms.CharField()
    answer3 = forms.CharField()
    answer4 = forms.CharField()


@method_decorator(login_required, name='dispatch')
class QuestionEditView(FormView):
    form_class = QuestionForm
    template_name = 'appadmin/question_edit.html'

    def get(self, request, *args, **kwargs):
        try:
            _ = QuestionModel.objects.get(pk=self.kwargs['pk'])
            return self.render_to_response(self.get_context_data())
        except Exception as e:
            return redirect('/')

    def get_context_data(self, **kwargs):
        context = super(QuestionEditView, self).get_context_data(**kwargs)
        question_model = QuestionModel.objects.get(pk=self.kwargs['pk'])
        question_lang = QuestionLang.objects.filter(question=question_model)
        context['question_lang'] = question_lang
        return context


class EditQuestionAPIView(UpdateAPIView):
    permission_classes = (IsAuthenticated,)

    def patch(self, request, *args, **kwargs):
        question = request.data['question']
        answer1 = request.data['answer1']
        answer2 = request.data['answer2']
        answer3 = request.data['answer3']
        answer4 = request.data['answer4']
        correct_answer = request.data['correct_answer_string']
        difficulty = request.data['difficulty']
        difficulty = int(float(difficulty))

        question_id = kwargs['pk']
        question_lang_model = QuestionLang.objects.get(pk=question_id)
        question_lang_model.text = question
        question_lang_model.answer1 = answer1
        question_lang_model.answer2 = answer2
        question_lang_model.answer3 = answer3
        question_lang_model.answer4 = answer4
        question_lang_model.correct_answer = correct_answer
        question_lang_model.save()

        difficulty_model = Difficulty.objects.get(pk=difficulty)
        question_lang_model.question.difficulty = difficulty_model
        question_lang_model.question.save()

        bundle_model = question_lang_model.question.bundle
        bundle_model.db_version += 0.1
        bundle_model.save()

        try:
            UpdatesHistory.objects.update_or_create(
                question_model=question_lang_model.question,
                question_lang=question_lang_model,
                bundle=bundle_model,
                defaults={'db_version': bundle_model.db_version}
            )
        except Exception as e:
            print(e)
            pass

        return Response({'message': 'Question was updated.'}, status=HTTP_200_OK)


class DeleteQuestionAPIView(DestroyAPIView):
    permission_classes = (IsAuthenticated,)

    def delete(self, request, *args, **kwargs):
        question_id = kwargs['pk']
        question_lang_model = QuestionLang.objects.get(pk=question_id)
        question_model = question_lang_model.question
        bundle_model = question_lang_model.question.bundle

        question_lang_model.delete()

        bundle_model.db_version += 0.1
        bundle_model.save()

        question_lang_query_set = QuestionLang.objects.filter(question=question_model)
        if not question_lang_query_set:
            removes_history_model = RemovesHistory.objects.create(question_model_id=question_model.id,
                                                                  bundle=bundle_model,
                                                                  db_version=bundle_model.db_version)
            removes_history_model.save()

            RemovesHistory.objects.filter(parent_id=question_model.id).delete()

            question_model.delete()

            return Response({'back': True, 'message': 'Question was deleted.'}, status=HTTP_200_OK)

        removes_history_model = RemovesHistory.objects.create(question_lang_id=question_id, bundle=bundle_model,
                                                              db_version=bundle_model.db_version,
                                                              parent_id=question_model.id)
        removes_history_model.save()

        return Response({'message': 'Question was deleted.'}, status=HTTP_200_OK)
