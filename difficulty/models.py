from django.db import models


class Difficulty(models.Model):
    level = models.PositiveSmallIntegerField(null=False, unique=True, )
    remuneration = models.PositiveIntegerField(default=0)

    def __str__(self):
        return "{}".format(self.level)

    class Meta:
        verbose_name = 'Difficulty'
        verbose_name_plural = 'Difficulties'
