

Fs=10000;
endTime=1;
t=0:1/Fs:endTime;
f1=250;

s1=cos(2*pi*f1*t);


stem(s1)

R = xcorr(s1,'biased');
R = R(length(s1):end);
g = R/R(1);

plot(g);