function Y_bart = Bartlett( y, fs, L )
%Bartlett estimates the power spectrum of y(t) on a time window using the average of
% different periodograms 
% y is the signal
% Fs is the sampling frequency of the signal y
% L is the number of subsequent periodograms being averaged
% Y_bart is a matrix containing the estimates for every window as a column
windows = split_hanning(y,20,10,fs);
ffts = fft(windows,2^10);
magnitudes = abs(ffts);
Yk2s = magnitudes.^2;
for i=1:size(windows,2)-L
    Y_bart(:,i) = mean(Yk2s(:,i:i+L-1),2);
end
% Append the last 10 windows that could not be averaged
    Y_bart = [Y_bart, Yk2s(:,end-L+1:end)];


end

