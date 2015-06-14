function Y_bart = Bartlett( y, fs, L, spl, ovl )
%Bartlett estimates the power spectrum of y(t) on a time window using the average of
% different periodograms 
% y is the signal
% Fs is the sampling frequency of the signal y
% L is the number of subsequent periodograms being averaged
% spl is the length of the window in milliseconds
% ovl is the overlap length in milliseconds
% Y_bart is a matrix containing the estimates for every window as a column
windows = split_hanning(y,spl,ovl,fs);
ffts = fft(windows);
magnitudes = abs(ffts);
Yk2s = magnitudes.^2;
for i=L:size(windows,2)
     Y_bart(:,i) = mean(Yk2s(:,i-L+1:i),2);
end
% Add the first L-1 windows that could not be averaged
  Y_bart(:,1:L-1) = Yk2s(:,1:L-1);


end

