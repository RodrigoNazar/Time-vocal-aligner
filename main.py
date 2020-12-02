
from apps.detection import HFC_onset_detection
from apps.mapping import onset_mapping
from apps.correction import onset_correction
from apps.link_audio import link_onsets
from apps.tests import onset_detection_test

from utils.utils import LoadData


PROJECTS = [
    'Surfer Girl - tenor baryton',
    'Surfer Girl - tenor basse',
]

FEATUES = {
    'periodicity': 'periodicity',
    'energy': 'energy',
}


'''                         Program Hyperparameters
'''

# Change this parameters
PROJECT = PROJECTS[0]
FEATURES_NAMES = ['periodicity', 'energy']
SHOW_FIGS = True
WIN_LENGTH = 512

# Do not touch
DATA_PATH = './data'
FULL_DATA_PATH = DATA_PATH + '/' + PROJECT

FEATURES_METHODS = [FEATUES[i] for i in FEATURES_NAMES]


def main(project=PROJECT, data_path=FULL_DATA_PATH,
         features=FEATURES_METHODS, show_figs=SHOW_FIGS,
         win_len=WIN_LENGTH):

    # Say hello
    print()
    print('*'*10+' Time vocal alignment! '+'*'*10)

    print('\nFeatures:',
          [i for i in features])

    # Flow managing variables
    RODRIGO_RULES = True

    # Upload the data to the scope
    data = LoadData(data_path, project)

    # Step 1: Onset detection of syllables
    data['main_voice']['onsets'] = HFC_onset_detection(
        data['main_voice']['data'], win_len=win_len
    )
    # data['following_voice']['onsets'] = HFC_onset_detection(
    #     data['following_voice']['data']
    # )

    # Here's a test for the onset detection algorithm
    # onset_detection_test(data)


if __name__ == "__main__":
    main()
