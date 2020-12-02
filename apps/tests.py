
import numpy as np

from utils.wavfile import read
from scipy.io.wavfile import write


def onset_detection_test(data, sr=44100):

    beep_path = './data/program/beep.wav'
    beep = read(beep_path)

    for voice in data:
        new_voice = []

        split = np.split(
            data[voice]['data'][1],
            data[voice]['onsets']
        )

        for elem in split:
            new_voice.append(np.concatenate((elem, beep[1]), axis=0))

        new_voice = np.concatenate(new_voice, axis=0)

        write(f'./results/tests/onset_det_{voice}.wav', sr, new_voice)

        print(new_voice.shape)
