function filtered_speech = OverlapAdd(speech, split_length,overlapping_length,fs, y_length)
% OverlapAdd recreates speech signal from hamming-windowed speech

% Transform milliseconds to samples
    Ts = 1/fs;
    split_length_samples = fix(split_length*0.001 / Ts);
    overlapping_length_samples = fix(overlapping_length*0.001 / Ts);
    
    filtered_speech = zeros(y_length,1);
    speech = real(speech);
    
    for i=1:size(speech,2)
        
    filtered_speech((i-1)*overlapping_length_samples+1 : (i+1)*overlapping_length_samples) = ...
        filtered_speech((i-1)*overlapping_length_samples+1 : (i+1)*overlapping_length_samples) + speech(:,i);
    end
end

