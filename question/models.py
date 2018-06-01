from django.db import models
from languages.models import Language
from difficulty.models import Difficulty
from bundle.models import BundleModel


class QuestionModel(models.Model):
    difficulty = models.ForeignKey(Difficulty, on_delete=models.CASCADE, )
    bundle = models.ForeignKey(BundleModel, on_delete=models.CASCADE, )
    label = models.CharField(max_length=500)

    def __str__(self):
        return '{}'.format(self.label)

    class Meta:
        unique_together = (('label', 'bundle'),)


class QuestionLang(models.Model):
    question = models.ForeignKey(QuestionModel, on_delete=models.CASCADE)
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    text = models.CharField(max_length=500)
    answer1 = models.CharField(max_length=500)
    answer2 = models.CharField(max_length=500)
    answer3 = models.CharField(max_length=500)
    answer4 = models.CharField(max_length=500)
    correct_answer = models.CharField(max_length=500)

    def __str__(self):
        return '{}'.format(self.text)

    class Meta:
        unique_together = (('question', 'language'),)
