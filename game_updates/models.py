from django.db import models
from question.models import QuestionModel, QuestionLang
from bundle.models import BundleModel


class UpdatesHistory(models.Model):
    question_model = models.ForeignKey(QuestionModel, on_delete=models.CASCADE)
    question_lang = models.ForeignKey(QuestionLang, on_delete=models.CASCADE)
    bundle = models.ForeignKey(BundleModel, on_delete=models.CASCADE)
    db_version = models.FloatField()

    class Meta:
        verbose_name = 'Updates history'
        verbose_name_plural = 'Updates history'


class RemovesHistory(models.Model):
    bundle = models.ForeignKey(BundleModel, on_delete=models.CASCADE)
    question_model_id = models.PositiveIntegerField(null=True)
    question_lang_id = models.PositiveIntegerField(null=True)
    parent_id = models.PositiveIntegerField(null=True)
    db_version = models.FloatField()

    class Meta:
        verbose_name = 'Removes history'
        verbose_name_plural = 'Removes history'


class InsertsHistory(models.Model):
    question_model = models.ForeignKey(QuestionModel, on_delete=models.CASCADE)
    bundle = models.ForeignKey(BundleModel, on_delete=models.CASCADE)
    db_version = models.FloatField()

    class Meta:
        verbose_name = 'Inserts history'
        verbose_name_plural = 'Inserts history'
