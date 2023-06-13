function [coeffs] = analyzeWord(filenameaudio,visualize)
%ANALYZEWORD Reads an audio speech file containing 1 word and returns the
%spectogram coeffs
%   uses simple spectogram


    % USER DEFINED PARAMETERS:
    
    NFFT=32;
    WINDOW=32;
    NOVERLAP=16;
    
    hpforder=30;                % order of highpass filter  
    lowcut=100;                 % low band reject frequency   (Hz)
    highcut=200;                % high band cut-off frequency (Hz)
                                % transition between lowcut-highcut
    
    Fs = 8000;
    
    % load speech file
    [speech,FsOrig]=audioread(filenameaudio);
    
    % normalize the original signal
    % so the values are in the interval [0, 1]
    speechMin=min(speech);
    speechMax=max(speech);
    speech=speech/max(speechMax,-speechMin);
    
    % resample the signal
    x=resample(speech,Fs,FsOrig);
    
    hpfilter=firpm(hpforder,[0 lowcut highcut Fs/2]/(Fs/2),[0 0 1 1]);
    y=filter(hpfilter,1,x);
    
    coeffs = specgram(y,NFFT,Fs,WINDOW,NOVERLAP);


    if visualize==1
        figure('Name','Word Analysis')
        specgram(y,NFFT,Fs,WINDOW,NOVERLAP);
        title(['audio file' filenameaudio 'Hz'])
    end

end

