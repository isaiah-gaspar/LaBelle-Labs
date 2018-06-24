%Read data into workspace
testData = xlsread('0testData.xlsx','Sheet1','A1:C721950');

%Select all rows and first column for x1
x1_minutes = testData(:,1);  

%Select all rows and column 3 for y1
y1_eeg = testData(:,3);    

%Plot x-y with ecg script for sliding window, also showing red line with
%markers 'o' at every sample

plotECG(x1_minutes,y1_eeg, 'r-o')
hold on
title('Plot of ECG')
xlabel("Time [ms]")
ylabel("ECG Biopotential [uV?]")

beat_count=0;
for k = 2 :length(y1_eeg)-1
    if((y1_eeg(k) > y1_eeg(k-1)) && (y1_eeg(k) > y1_eeg(k+1)) && (y1_eeg(k) > 1.8) && (y1_eeg(k) < 3.0))
        k
        disp('Prominant Peak')
        beat_count = beat_count + 1;
        beat_count
    end
end