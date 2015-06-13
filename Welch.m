function Py_welch = Welch( y, fs, M, spl, ovl )
%Welch estimates the power spectrum of y(t) on a time window using the average of
% different periodograms 
% y is the signal
% Fs is the sampling frequency of the signal y
% M is the number of subsequent periodograms being averaged
% spl is the length of the time windows in milliseconds
% ovl is the length of the overlap between windows in milliseconds
% Py_welch is a matrix containing the estimates for every window as a column
windows = split_hanning(y,spl,ovl,fs); 
L = size(windows,1);
ffts = fft(windows);
magnitudes = abs(ffts);
Yk2s = magnitudes.^2;
P = Yk2s./L;

for i=M:size(windows,2)
     Py_welch(:,i) = mean(P(:,i-M+1:i),2);
end
% Add the first M-1 windows that could not be averaged
  Py_welch(:,1:M-1) = P(:,1:M-1);

end

