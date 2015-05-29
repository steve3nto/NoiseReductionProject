function splitted_result = split_hanning(input_signal,split_length,overlapping_length,fs)
    % Input_signal is the row vector which is needed to be splited. Split_length
    % and overlapping_length is the lenght of the windows in milliseconds 
    % Every column of the output matrix corresponds to a chunk of the vector

    % Transform milliseconds to samples
    Ts = 1/fs;
    split_length_samples = fix(split_length*0.001 / Ts);
    overlapping_length_samples = fix(overlapping_length*0.001 / Ts);
    win = Modhanning(split_length_samples);
    
    clip_length=fix(size(input_signal,1)/split_length_samples)*split_length_samples;
    splitted_result=zeros(split_length_samples,clip_length/split_length_samples);
    index=1;
    for i=1:split_length_samples-overlapping_length_samples:clip_length-split_length_samples
        splitted_result(:,index)=input_signal(i:i+split_length_samples-1,1);
        index=index+1;
    end
    
    splitted_result=splitted_result.*repmat(win,1,size(splitted_result,2));
    

end