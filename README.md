# Simple Automatic Speech Recognition System
As the title suggests this a simple ASR system, made to detect english words from audio signals (mainly numbers e.g. "zero", "two", ...).

This project was made for a university assigment during the summer of 2023.

## Example
Run main.m script (use availabe mp3/wav files in folder **samples**)

Alternatively, use the function **isolateWords**.

# Enviroment
The project was developped in Matlab version R2020b. It will not work in GNU Octave as it uses Matlab's fitcecoc function.

# Details
More specifically, the following steps are implemented:

1. Sample rate is changed to 8.000Hz
2. Signal is passed throud a highpass FIR filter
3. Each word in the signal is isolated with a simple classifier
4. Calculate the fundamental frequency of each word (with autocorrelation)
5. Recognize which words are in the signal with a trained SVM model (two pretrained models are provided)

A detailed documentation is also provided in Greek.

Usefull files:
- main.m
- isolateWords.m
- pitchTracking.m
- srcInterpolation.m
- srcLowPassHilter.m
- preprocess_dataset_script.m
- feature_extraction_script.m
- SVM_training_script.m
- SVM_evaluation_script.m
- numbersASR.m
- extractFeatures.m

aux:
- interpolation_examle.m
- src_demo_script.m
	
# Sources

## Digital sources:

- Dataset used for the training of the SVM models: [AudioMNIST](https://github.com/soerenab/AudioMNIST)
- .wav sample files from Professor Lawrence Rabiner's [website](https://web.ece.ucsb.edu/Faculty/Rabiner/ece259) and some recoreded from me
- https://www.mathworks.com/help/signal/ref/resample.html

## Books used:

- A. V. Oppenheim, R. W. Schafer, and J. R. Buck, Discrete-Time Signal Processing. Prentice-hall Englewood Cliffs, second ed., 1999.
- R. G. Lyons, Understanding Digital Signal Processing (2nd Edition). USA: Prentice Hall PTR, 2004.
- L. Rabiner and R. Schafer, Theory and applications of digital speech processing. Prentice Hall Press, 2010.

