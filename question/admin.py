from django.contrib import admin
from .models import QuestionModel, QuestionLang


class QuestionModelAdmin(admin.ModelAdmin):
    list_display = (
        'label',
        'difficulty',
        'bundle',
    )


class QuestionLangModelAdmin(admin.ModelAdmin):
    list_display = (
        'pk',
        'question',
        'language',
        'answer1',
        'answer2',
        'answer3',
        'answer4',
        'correct_answer',
    )


admin.site.register(QuestionLang, QuestionLangModelAdmin)

admin.site.register(QuestionModel, QuestionModelAdmin)