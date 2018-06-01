import coreapi
import coreschema

statistics_documentation = {
    'append': coreapi.Link(
        url='/api/appendstatistics/',
        action='post',
        description='Append new answer for statistics',
        encoding='multipart/form-data',
        fields=[
            coreapi.Field(
                name='answer',
                required=True,
                location='form',
                schema=coreschema.String(description='Player answer.')
            ),
            coreapi.Field(
                name='difficulty',
                required=True,
                location='form',
                schema=coreschema.Integer(description='Difficulty id from core data.')
            ),
            coreapi.Field(
                name='game_play_id',
                required=True,
                location='form',
                schema=coreschema.String(description='Generated unique id for current game.')
            ),
            coreapi.Field(
                name='question',
                required=True,
                location='form',
                schema=coreschema.Number(description='Question id from core data.')
            ),
            coreapi.Field(
                name='datetime',
                required=True,
                location='form',
                schema=coreschema.Number(description='Timestamp per game.')
            ),
        ]
    ),

    'appendbulk': coreapi.Link(
        url='/api/appendbulkstatistics/',
        action='post',
        description='Append new game for statistics',
        encoding='application/x-www-form-urlencoded',
        fields=[
            coreapi.Field(
                name='',
                required=True,
                location='body',
                schema=coreschema.Object(description="""
\t[
    \t{ 
      \t"answer":"Player answer.",
      \t"difficulty":Difficulty id from core data.,
      \t"game_play_id":"Generated unique id for current game.",
      \t"question":Question id from core data.,
      \t"datetime":Timestamp per game.
    \t},
    \t{...},
\t]
      """
                                         )
            ),
        ]
    ),

    'bugreport': coreapi.Link(
        url='/api/bugreport/',
        action='post',
        description='Send a bug report',
        encoding='multipart/form-data',
        fields=[
            coreapi.Field(
                name='question',
                required=True,
                location='form',
                schema=coreschema.Integer(description='question id')
            ),
            coreapi.Field(
                name='bug_type',
                required=True,
                location='form',
                schema=coreschema.Integer(description='bug type id')
            ),
            coreapi.Field(
                name='device_token',
                required=True,
                location='form',
                schema=coreschema.String(description='Generated unique id for current device.')
            ),
        ]
    ),
}
