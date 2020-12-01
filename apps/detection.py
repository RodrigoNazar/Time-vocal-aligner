
import numpy as np
import matplotlib.pyplot as plt


def onset_detection(data, win_len=1024):

    gammas = get_gammas(data, win_len=1024)

    # Features
    _periodicity = periodicity_by_gammas(gammas)
    _relevant_energy = relevant_energy_by_gammas(gammas)


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
        p_h = (gamma / n_chunks - indx) / (gammas[0] / n_chunks)
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
