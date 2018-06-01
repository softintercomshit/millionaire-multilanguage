from django.db import models
from question.models import QuestionLang
from difficulty.models import Difficulty
from question.models import QuestionLang


class StatisticsModel(models.Model):
    question = models.ForeignKey(QuestionLang, on_delete=models.CASCADE)
    difficulty = models.ForeignKey(Difficulty, on_delete=models.CASCADE)
    answer = models.CharField(max_length=500)
    game_play_id = models.CharField(max_length=500)
    datetime = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = (('difficulty', 'game_play_id'),)


class BugTypeModel(models.Model):
    BUGS_TYPE = (
        (1, 'Bad question'),
        (2, 'Incorrect answer options'),
        (3, 'Inaccurate translation'),
        (4, 'Spelling mistakes'),
    )
    type = models.IntegerField(choices=BUGS_TYPE, default=1, primary_key=True)

    def __str__(self):
        return '{}'.format(self.BUGS_TYPE[self.type-1][1])


class BugReportsModel(models.Model):
    question = models.ForeignKey(QuestionLang, on_delete=models.CASCADE)
    bug_type = models.ForeignKey(BugTypeModel, on_delete=models.CASCADE)
    device_token = models.CharField(max_length=200)

    class Meta:
        unique_together = (('question', 'bug_type', 'device_token'),)
