import coreapi

from game_api.documentation import game_api_documentation
from game_statistics.api.documentation import statistics_documentation
from game_updates.api.documentation import game_updates_documentation

CONTENT = dict()
CONTENT['Statistics'] = statistics_documentation
CONTENT['Game API'] = game_api_documentation
CONTENT['Game Updates'] = game_updates_documentation


schema_doc = coreapi.Document(
    title='Millionaire API',
    url='http://localhost:8000/docs/',
    content=CONTENT
)