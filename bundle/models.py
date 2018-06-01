from django.db import models


class BundleModel(models.Model):
    identifier = models.CharField(max_length=200, unique=True)
    display_name = models.CharField(max_length=200, default='')
    db_version = models.FloatField(default=1.0)
    update_info = models.CharField(max_length=500, null=True)

    def __str__(self):
        return '{}'.format(self.display_name)

