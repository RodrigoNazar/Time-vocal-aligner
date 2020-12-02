
import numpy as np
import matplotlib.pyplot as plt

from scipy.spatial import ConvexHull
from librosa.onset import onset_detect
from scipy.signal import stft


def HFC_onset_detection(data, win_len=1024, debug=False):
    '''
    From:
    http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.332.989&rep=rep1&type=pdf
    '''
    if len(data) == 3:
        sr, data, _ = data
    else:
        sr = 44100

    frec, tiempo, X = stft(data[:, 0], fs=sr, window='hann', nperseg=1024,
                           noverlap=512)

    if debug:
        plt.pcolormesh(tiempo, frec, np.abs(X), vmin=0,
                       vmax=2 * np.sqrt(2), shading='gouraud')
        plt.title('STFT Magnitude')
        plt.ylabel('Frequency [Hz]')
        plt.xlabel('Time [sec]')
        plt.show()

    E_n = np.multiply(np.power(X, 2).T, np.abs(frec)).T
    E_n = np.sum(E_n, axis=0)

    print(E_n.shape)

    # for x in X.T:
    #     print(x.shape)

    plt.figure()
    plt.plot(E_n)
    plt.show()

    print('frec\t', frec.shape)
    print('tiempo\t', tiempo.shape)
    print('X\t', X.shape)


def librosa_onset_detect(data, win_len=1024):
    if len(data) == 3:
        sr, data, _ = data
    else:
        sr = 44100

    return onset_detect(data.astype(np.float32)[
        :, 0], sr=sr, units='samples')


def onset_detection(data, win_len=1024):

    gammas = get_gammas(data, win_len=1024)

    # Features
    _periodicity = periodicity_by_gammas(gammas)
    _relevant_energy = relevant_energy_by_gammas(gammas)

    plt.figure()
    # plt.plot(_periodicity)
    plt.plot(_relevant_energy)
    plt.show()

    periodicity_segmentation(_periodicity)


def periodicity_segmentation(per):
    per = np.array(per)

    convex_hull = ConvexHull(per)
    print(convex_hull)


def get_gammas(data, win_len=1024):
    '''
    From:
    https://www.isca-speech.org/archive/archive_papers/interspeech_2006/i06_1327.pdf
    '''

    if len(data) == 3:
        sr, data, _ = data
    else:
        sr = 44100

    for channel in range(data.shape[1]):
        chunks = data[:, channel]

        n_chunks = chunks.shape[0] // win_len

        indices = [i*win_len for i in range(n_chunks)]

        chunks = np.split(chunks, indices)
        chunks = chunks[1:] if len(chunks[0]) == 0 else chunks

        # Autocorrelations
        gammas = []
        for chunk in chunks:
            corr = autocorr(chunk)
            gamma = np.sum(corr) / corr.size
            gammas.append(gamma)

    return gammas


def periodicity_by_gammas(gammas):

    # Normalization of the gammas
    P_h = []
    for indx, gamma in enumerate(gammas):
        p_h = (gamma / len(gammas) - indx) / (gammas[0] / len(gammas))
        P_h.append(p_h)

    return P_h


def periodicity(data, win_len=1024):
    '''
    From:
    https://www.isca-speech.org/archive/archive_papers/interspeech_2006/i06_1327.pdf
    '''

    if len(data) == 3:
        sr, data, _ = data
    else:
        sr = 44100

    for channel in range(data.shape[1]):
        chunks = data[:, channel]

        n_chunks = chunks.shape[0] // win_len

        indices = [i*win_len for i in range(n_chunks)]

        chunks = np.split(chunks, indices)
        chunks = chunks[1:] if len(chunks[0]) == 0 else chunks

        # Autocorrelations
        gammas = []
        for chunk in chunks:
            corr = autocorr(chunk)
            gamma = np.sum(corr) / corr.size
            gammas.append(gamma)

        # Normalization of the gammas
        P_h = []
        for indx, gamma in enumerate(gammas):
            p_h = (gamma / n_chunks - indx) / (gammas[0] / n_chunks)
            P_h.append(p_h)

    return P_h


def relevant_energy_by_gammas(gammas):
    '''
    From:
    https://www.isca-speech.org/archive/archive_papers/interspeech_2006/i06_1327.pdf
    '''
    energy = np.array([np.log10(np.abs(gamma)) for gamma in gammas])

    max_energy = np.max(energy)
    energy = energy / max_energy

    return energy


def autocorr(x):
    '''
    Inspirated in the following implementation:
    https://stackoverflow.com/questions/23706524/finding-periodicity-in-an-algorithmic-signal
    '''
    result = np.correlate(x, x, mode='full')

    return result
