from bundle.models import BundleModel
from difficulty.models import Difficulty
from languages.models import Language
from question.models import QuestionModel, QuestionLang
from .DBManager import DBManager


class Populate:
    def __init__(self):
        self.db_manager = DBManager()
        self.bundle_identifier = 'millionaire.paid.6.language.alavar.soft.2014'

    def populate_languages(self):
        languages = self.db_manager.getFetchAllFromDB('select Lang from questions group by Lang')
        for lang in languages:
            lang = lang[0]
            try:
                language_model = Language.objects.create(name=lang)
                language_model.save()
            except:
                pass
                # print('{} language allready in db'.format(lang))

    def populate_difficulty_levels(self):
        levels = self.db_manager.getFetchAllFromDB('select Difficulty from questions group by Difficulty')

        remuneration_list = (100, 200, 300, 500, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 125000, 250000, 500000,
                             1000000,)

        for level in levels:
            level = level[0]
            try:
                difficulty_model = Difficulty.objects.create(level=level, remuneration=remuneration_list[int(level)-1])
                difficulty_model.save()
            except Exception as e:
                print(e)
                # print('level {} allready in db'.format(level))

    def populate_data(self):
        results = self.db_manager.getFetchAllFromDB_dict('select * from questions')
        for result in results:
            question = result['Question'].encode('utf-8')
            answer1 = result['Answer1'].encode('utf-8')
            answer2 = result['Answer2'].encode('utf-8')
            answer3 = result['Answer3'].encode('utf-8')
            answer4 = result['Answer4'].encode('utf-8')
            answers_list = (answer1, answer2, answer3, answer4)
            correct_answer_index = int(result['Correct']) - 1
            try:
                correct_answer = answers_list[correct_answer_index]
            except Exception as e:
                continue

            difficulty = result['Difficulty']
            language = result['Lang']

            difficulty_model = Difficulty.objects.filter(level=difficulty)
            if not difficulty_model.exists():
                raise Exception('difficulty_model does not exist')
            difficulty_model = difficulty_model.first()

            bundle_model, created = BundleModel.objects.get_or_create(identifier=self.bundle_identifier,
                                                                      display_name='Millionaire multilanguage')

            language_model = Language.objects.filter(name=language)
            if not language_model.exists():
                raise Exception('language_model does not exist')
            language_model = language_model.first()

            question_model, _ = QuestionModel.objects.get_or_create(label=question,
                                                                    bundle=bundle_model,
                                                                    defaults={'difficulty': difficulty_model})

            try:
                QuestionLang.objects.create(question=question_model,
                                            language=language_model,
                                            text=question,
                                            answer1=answer1,
                                            answer2=answer2,
                                            answer3=answer3,
                                            answer4=answer4,
                                            correct_answer=correct_answer,
                                            )
            except Exception as e:
                print('{} -----> {}'.format(result['Id'], language))
                print(e)


if __name__ == '__main__':
    obj = Populate()
    obj.populate_languages()
