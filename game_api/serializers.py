from rest_framework.serializers import ModelSerializer
from difficulty.models import Difficulty
from languages.models import Language
from bundle.models import BundleModel
from question.models import QuestionLang, QuestionModel


class DifficultiesSerializer(ModelSerializer):

    class Meta:
        model = Difficulty
        fields = '__all__'


class LanguagesSerializer(ModelSerializer):

    class Meta:
        model = Language
        fields = '__all__'


class BundleSerializer(ModelSerializer):

    class Meta:
        model = BundleModel
        fields = (
            'db_version',
            'update_info',
        )


class QuestionModelSerializer(ModelSerializer):

    class Meta:
        model = QuestionModel
        fields = '__all__'


class QuestionLangSerializer(ModelSerializer):

    class Meta:
        model = QuestionLang
        fields = '__all__'
