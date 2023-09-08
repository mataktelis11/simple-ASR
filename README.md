# Simple Automatic Speech Recognition System
As the title suggests this a simple ASR system, made to detect english words from audio signals (mainly numbers e.g. "zero", "two", ...).

This project was made for a university assigment during the summer of 2023.

**Table of contents**
- [Example](#example)
- [Enviroment](#enviroment)
- [Details](#details)
  - [Graphs/Screenshots](#graphsscreenshots)
  - [How to train your own model](#how-to-train-your-own-model)
- [Sources](#sources)
  - [Digital sources](#digital-sources)
  - [Books used](#books-used)

## Example
Run **main.m** script (use availabe mp3/wav files in folder **samples**)

Below is an example recording (from me)

https://github.com/mataktelis11/simple-ASR/assets/61196956/77d5cd32-3f91-43f6-b7ec-6cfb3e104209

The script **main.m** recognizes the words i spoke in this recording. We have the following output (pitch is in Hz):
```
Detected word#1: pitch = 109.589041, class = one
Detected word#2: pitch = 106.666667, class = two
Detected word#3: pitch = 108.108108, class = three
Detected word#4: pitch = 400.000000, class = four
```

Alternatively, use the function **numbersASR**:

Example 1 (recognize words in a wav file):
```matlab
load trainedModelsCompact\svmClassifierV0.mat;

[speech,FsOrig] = audioread('samples/3rec.wav');

[Y,pitch] = numbersASR(speech,FsOrig,SVMClassifierCompact,1)
```

Example 2 (create recording and recognize words in it):
```matlab
r = audiorecorder(44100,16,1);
record(r) % speak into microphone
stop(r)
p = play(r); % listen

speech = getaudiodata(r);

load trainedModelsCompact\svmClassifierV0.mat;

[Y,pitch] = numbersASR(speech,44100,SVMClassifierCompact,0)
```

# Enviroment
The project was developped in Matlab version R2020b. It will not work in GNU Octave as it uses Matlab's fitcecoc function.

# Details
More specifically, the following steps are implemented:

1. Sample rate is changed to 8.000Hz
2. Signal is passed throud a highpass FIR filter
3. Each word in the signal is isolated with a simple classifier (uses zero-crossing rate and log Energy)
4. For each word we calculate the fundamental frequency (pitch) with autocorrelation
5. Finally the program automatically recognizes which words are in the signal with a trained SVM model (two pretrained models are provided)

A detailed technical documentation is also provided in Greek. Read it [here](https://github.com/mataktelis11/simple-ASR/tree/main/pdfs/audio_n_speech_processing_doc.pdf).

## Graphs/Screenshots
Below are some graphs the program creates.

This is the highpass FIR filter's impulse response

<img src='https://github.com/mataktelis11/simple-ASR/assets/61196956/2956c37f-680d-4778-8d7e-dbe8ba979f66' height=200px>

bellow is the isolation of the words in the .wav file

<img src='https://github.com/mataktelis11/simple-ASR/assets/61196956/84cbe8c6-5c89-4318-be1e-7275e09dfdcb' height=400px>

finally we have the spectrogram and autocorrelation of each recognized word

<img src='https://github.com/mataktelis11/simple-ASR/assets/61196956/9a9c7980-4885-467c-bb6f-fa741bb72668' height=250px>
<img src='https://github.com/mataktelis11/simple-ASR/assets/61196956/a925eca5-eb53-4059-8eeb-3210d81ba806' height=250px>

<img src='https://github.com/mataktelis11/simple-ASR/assets/61196956/5e877628-573c-4a33-b387-0cb3c2e7d976' height=250px>
<img src='https://github.com/mataktelis11/simple-ASR/assets/61196956/661d4408-14ab-4609-b53b-b009e798fcf8' height=250px>

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

Auxiliary files:
- interpolation_examle.m
- src_demo_script.m


## How to train your own model
First clone this repo
```
git clone https://github.com/mataktelis11/simple-ASR.git
```
now you need a dataset. I suggest [AudioMNIST](https://github.com/soerenab/AudioMNIST) which is the one i used for the included models. This dataset has 30000 audio samples of spoken digits (0-9) of 60 different speakers.
```
git clone https://github.com/soerenab/AudioMNIST.git
```
Now go into the root folder of the current project and create and empty dir
```
cd simple-ASR
mkdir audioData2
```
The dataset is divided in folders based on the speakers and not the words. For our model we want the **audioData2** folder to contain subfolders each with all the audio files that correspond to a specific word. This can be done easily with bash commands.
```bash
cp ../AudioMNIST/data/??/0*.wav audioData2/zero
cp ../AudioMNIST/data/??/1*.wav audioData2/one
cp ../AudioMNIST/data/??/2*.wav audioData2/two
cp ../AudioMNIST/data/??/3*.wav audioData2/three
cp ../AudioMNIST/data/??/4*.wav audioData2/four
cp ../AudioMNIST/data/??/5*.wav audioData2/five
cp ../AudioMNIST/data/??/9*.wav audioData2/nine
```
You can add more words and more audio files if you want. Now in order to train the model you need to run the following scripts in this order:

1. preprocess_dataset_script.m
2. feature_extraction_script.m
3. SVM_training_script.m
4. SVM_evaluation_script.m


 
# Sources

## Digital sources:

- Dataset used for the training of the SVM models: [AudioMNIST](https://github.com/soerenab/AudioMNIST)
- .wav sample files from Professor Lawrence Rabiner's [website](https://web.ece.ucsb.edu/Faculty/Rabiner/ece259) and some recoreded from me
- https://www.mathworks.com/help/signal/ref/resample.html
- https://www.mathworks.com/help/stats/confusionchart.html
- https://www.mathworks.com/help/stats/improving-classification-trees-and-regression-trees.html

## Books used:

- A. V. Oppenheim, R. W. Schafer, and J. R. Buck, Discrete-Time Signal Processing. Prentice-hall Englewood Cliffs, second ed., 1999.
- R. G. Lyons, Understanding Digital Signal Processing (2nd Edition). USA: Prentice Hall PTR, 2004.
- L. Rabiner and R. Schafer, Theory and applications of digital speech processing. Prentice Hall Press, 2010.

