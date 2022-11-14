clear;
close all;
%% spectogram and fourier transform of sound file using matlabs signal processing toolbox

%read sound file
file = 'doppler_effect.mp3';
[y, sample_freq] = audioread(file);

% make mono
y = 0.5*y(:,1) + 0.5*y(:,2);

% get time vector from frequency and resolution
nsamples = length(y);
t = (1/sample_freq)*(1:nsamples);

%% create spectogram
figure;

fourier_nsamples=2048;   % n samples used for FFT for the moving window
window_width = 0.05;     % width of the moving window [s]
window_overlap = 0.0005; % overlap for each moving window [s]
 
window_nsamples   = round(sample_freq*window_width);    % window width in nsamples rather than seconds
overlap_nsamples  = round(sample_freq*window_overlap);  % overlap in nsamples rather than seconds
window            = hamming(window_nsamples).';         % use Hamming for the moving window

% construct spectogram using signal processing toolbox
[S,F,T] = spectrogram(y, window,...
                      overlap_nsamples,...
                      fourier_nsamples,...
                      sample_freq);
                  
% scale spectogram to something like dB using 10*log10
S = abs(S);
S = S/max(max(S));
S = 10*log10(S);  

% plot spectogram
h = imagesc(T, F, S);
set(gca, 'YDir', 'normal');

ylim([0,5e3]);        % only freqs below 5000 Hz are interesting
xlim([T(12), max(T)]) % manually remove some Inf values from plot

title('Spectogram of passing honking car (log10-normalized)')
xlabel('t [s]')
ylabel('frequency [Hz]')

%% plot Fourier transform

figure;

% calculate FFT of mono sound file and normalize to [0,1]
y_fft = fft(y);
y_fft = abs(y_fft);
y_fft = y_fft(1:nsamples/2); % remove symmetry
y_fft = y_fft/max(y_fft);

% create frequency vector
f = sample_freq*(0:nsamples/2-1)/nsamples;

% plot Fourier transform
plot(f,y_fft);
xlim([0, 5e3]);
title('Fourier transform of passing honking car');
ylabel('Amplitude [normalized]')
xlabel('Frequency [Hz]')