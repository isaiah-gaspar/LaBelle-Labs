%Read data into workspace
testData = xlsread('0testData.xlsx','Sheet1','A1:C721950');

%Select all rows and first column for x
x = testData(:,1);  

%Select all rows and column 3 for y
y = testData(:,3);    

%Plot x-y with ecg script for sliding window, also showing red line with
%markers 'o' at every sample

% title('Plot of ECG')
% plot(x,y, 'r-o')
% hold on
% xlabel("Time [ms]")
% ylabel("ECG Biopotential [uV?]")

beat_count=0;
for k = 2 :length(y)-1
    if((y(k) > y(k-1)) && (y(k) > y(k+1)) && (y(k) > 1.8) && (y(k) < 2.3))
        
        beat_count = beat_count + 1;
       
        time = testData(k,1);
        actv = testData(k,3);
        
        results_eeg(beat_count,1) = k;
        results_eeg(beat_count,2) = beat_count;
        results_eeg(beat_count,3) = time;
        results_eeg(beat_count,4) = actv;
        
        
    end 
    
       
    
end

