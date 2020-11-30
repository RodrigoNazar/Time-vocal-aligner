
import os

from utils.wavfile import read


def LoadData(data_path, project=''):

    data = {}

    for _dir in os.listdir(data_path):

        if 'main' in _dir:

            voice_path = os.listdir(f'{data_path}/{_dir}')[0]

            data['main_voice'] = {
                'name': voice_path,
                'data': read(f'{data_path}/{_dir}/{voice_path}')
            }

        elif 'following' in _dir:

            voice_path = os.listdir(f'{data_path}/{_dir}')[0]

            data['following_voice'] = {
                'name': voice_path,
                'data': read(f'{data_path}/{_dir}/{voice_path}')
            }

    return data
