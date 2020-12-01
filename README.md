# Time-vocal-aligner
Source code of the Computer Audition course Project.

Rodrigo Nazar Meier.\
Pontificia Universidad Católica de Chile.

---


## References

* http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.332.989&rep=rep1&type=pdf


## Acknowledgements

* Simon Craipeau, *Music and Vocals* extracted from [Tutorial, Surfer Girl Vocals Parts](https://www.youtube.com/watch?v=IYnaLyeujDU).


## Personal Notes

# Periodicity

The periodicity of a speech frame is then defined as the largest value among the peaks of the normalized autocorrelation function.

The first computed values of the periodicity will be kind of fake because of the correlation between adjacent samples. In practice, only the peaks in the middle stable portion are considered for the periodicity value of a frame.

In our implementations, only sample shifts from 40 to 240 are considered.
 