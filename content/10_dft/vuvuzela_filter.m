clear;
clf;
startTime = 15;
endTime   = 20;
soundfile = 'Vuvuzela_chant_holland_vs_Denmark.mp3';
% soundfile = 'Vuvuzela_Tshabalala_Goal.mp3';

%% read the sound sample
% read first 5 samples just to get the sample frequency Fs
[~, Fs] = audioread(soundfile,[1, 5]);

% now read the sound file from second 3 to 4
samples = Fs*[startTime, endTime]+1;
[vuvuzela, Fs] = audioread(soundfile, samples);

%convert stereo to mono by avaraging the signals
vuvuzela = mean(vuvuzela,2);

% play sound sample
soundsc(vuvuzela, Fs);
pause(endTime-startTime)

%% plot the sound data in the time domain
subplot(2,2,1);
time = startTime + (0:size(vuvuzela,1)-1)'./(size(vuvuzela,1)-1)*(endTime-startTime);
plot(time,vuvuzela)
xlabel('time [s]')
ylabel('Amplitude')
title('Time Domain');

%% calculate fast fourier transform

Z = fft(vuvuzela);
N=length(Z);
freq=(0:N-1)/(endTime - startTime);
coeffs = [ 2*real(Z), -2*imag(Z)]/N;

%% plot the fourier transform
subplot(2,2,2);
stem(freq(1:floor(N/2)), coeffs(1:floor(N/2),:),'LineWidth',2)
xlim([0, 3000]); % zoom into the low frequencies
ylim([-0.07, 0.07]);
title('Frequency Domain')
xlabel('Frequency [Hz]')
ylabel('Fourier coefficients')
legend('ak','bk');

%% create a filter function

% the logistic function is a smooth step function
logistic = @(k, x0, x) 1./(1+exp(-k*(x-x0)));

F =     [240; 475; 715; 940; 1180; 1400; 1640];
Fband = [ 50;  50;  50;  50;   50;   50;   50];

% filter multiples of F to take ripple effect into account
filter = ones(size(freq));
for k = 1:length(F)
    filter = filter - logistic(0.125, F(k)-Fband(k), freq);
    filter = filter + logistic(0.125, F(k)+Fband(k), freq);
end

% make sure that the filter is symmetric
filter(end:-1:end - floor(N/2)) = filter(1:floor(N/2)+1);

%% plot filtered signal

subplot(2,2,3);
plot(freq,filter)
xlim([0, 3000])
title('Filter in Freq. domain (take ripple effect into account');
xlabel('Frequency [Hz]')
ylabel('Factor')


subplot(2,2,4);
filteredsignal = [filter'.*coeffs(:,1) filter'.*coeffs(:,2)];
stem(freq(1:floor(N/2)), filteredsignal(1:floor(N/2),:),'LineWidth',2)
title('Filtered Signal in Frequency Domain');
xlabel('Frequency [Hz]')
ylabel('Amplitude')
xlim([0, 3000])
ylim([-0.07, 0.07]);

%% do the inverse transform

vuvuzela_filtered = real(ifft(filter'.*Z));

% play the filtered sound
soundsc(vuvuzela_filtered, Fs)
pause(endTime-startTime)