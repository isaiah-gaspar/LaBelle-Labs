
%   Created:    Isaiah Gaspar           07/08/19
%
%   Last Modified:  Isaiah Gaspar       07/09/19
% 
% 
%   Purpose:
%
%            The goal of this script is to pull data from excel
%            and be able to graph, beat detect, and accuratley 
%            calculate BPM. In addition to offering ease of use
%            for different devices and data sets that may vary
%            in length and sampled data may even vary drastically
%            in amplitude.
%
%   To-Use: 
%
%           To use you first need to edit/update where to read raw data
%           with the xlsread functions listed.
%           After this is determined time_LAB, TDK, and IWRX (Three DUT)
%           are arrays that contain the minutes that you want to further
%           evaluate. 
% 
%           Verifying in your raw data, I determined the number of rows
%           until a minute has been reached. For instance, the TDK raw
%           data takes approximatley 30000 samples (rows of data) before
%           the first minute is reached. Using this algebra I am determining
%           low and high range of my soon-to-be partitioned data.
% 
%           Using these new sections of data I am using a very simple method
%           for beat detection in the nested if statement. This works
%           by comparing previous and next samples to determine where the 
%           true max/peak/beat value occurs. Since data sets are already
%           brooken down into minute intervals, simply counting the samples
%           that meet this condition provides BPM which I am saving
%           into a single matrix for all three devices for later comparison.
%             
%  Potential Issues:
%
%           If the minutes requested is not in the origianlly
%           imported data set there will be an idex error when 
%           determinng bpm. Also all devices seem to operate at
%           within different ranges so each if statement was determined
%           by first graphing the data set with samples marked
%           and determining the best way of dealing with a potentially
%           odd PQRS complex.
% 
% 
% 


%% 
%Read data into workspace
DataLAB_1 = xlsread('Subject_1_ECG_TEMP.xlsx','Lab_ECG','A1:C721950'); %msec, min, ecg
DataTDK_1 = xlsread('Subject_1_ECG_TEMP.xlsx','TDK_ECG','A1:C1048567'); %msec, min, ecg
DataIWRX_1 = xlsread('Subject_1_ECG_TEMP.xlsx','iWorx_ECG','A1:C722855'); %sec, ecg

%% 
%  3 6 9 14 20 31 38 44 50 
time_LAB = [ 3 6 9 14 20 31 38 44 50]; %%minutes that we want to evaluate
time_TDK = [3 6 9 14 20 31];
time_IWRX = [3 6 9 14 20 31 38 44 50];

for k = 1 : length(time_LAB) %build matrix for BPM with respective minutes for later reference
    
    
    t = time_LAB(k);
    
    res_DataBPM_1(k,1) = t;
    
    k = k+1;
    
end


lowLAB_1 = time_LAB * 12000; %Cell for 'n' min start at n*12000
highLAB_1 = lowLAB_1 + 12000;

lowTDK_1 = time_TDK * 30000; %Cell for 'n' min start at n*30000
highTDK_1 = lowTDK_1 + 30000;

lowIWRX_1 = time_IWRX * 12000; %Cell for 'n' min start at n*12000, although time is in seconds
highIWRX_1 = lowIWRX_1 + 12000;



%% 
beat_count = 0; %Initialize to zero, not resetting between iterations to use as an index for results of the same device

%%Graph, beat detection, bpm calculation for lab data
for k = 1 : length(lowLAB_1) %length of time so this script can scale to a larger or smaller data set
    
    c = 2; %column for BPM
    
    l = lowLAB_1(k); %setting initial time value, start of the minute we are evaluating
    h = highLAB_1(k); %setting final time value, end of the minute we are evaluating
    
    x = DataLAB_1(l:h,2); %Full range of x data (time)
    y = DataLAB_1(l:h,3); %Full range of y data (electical activity
    
    bpm = 0; %Reset bpm for every minute under evaluation
   
    for n = 2 : length(x)-1 
        
        if((y(n) > y(n-1)) && (y(n) > y(n+1)) && (y(n) > 1.85) && (y(n) < 2.2))
            
            beat_count = beat_count + 1;
            bpm = bpm + 1;

            time = DataLAB_1(n,2);
            elect_actv = DataLAB_1(n,3);

            res_DataLAB_1(beat_count,1) = n; 
            res_DataLAB_1(beat_count,2) = time;
            res_DataLAB_1(beat_count,3) = elect_actv;
            res_DataBPM_1(k,c) = bpm;
            
        end

    end

     plot(x,y, '-o')
     hold on
    
    k = k + 1;
    
end
hold off


%% 
beat_count = 0;

%%Graph, beat detection, bpm calculation for TDK data
for k = 1 : length(lowTDK_1) %length of time so this script can scale to a larger or smaller data set
    
    c = 3; %column for BPM
    
    l = lowTDK_1(k); %setting initial time value, start of the minute we are evaluating
    h = highTDK_1(k); %setting final time value, end of the minute we are evaluating
    
    x = DataTDK_1(l:h,2); %Full range of x data (time)
    y = DataTDK_1(l:h,3); %Full range of y data (electical activity
    
    bpm = 0; %Reset bpm for every minute under evaluation
   
    for n = 7 : length(y)-10 
        
        if((y(n) > y(n-1)) && (y(n) > y(n+1)) && (y(n) > y(n-6)+50) && (y(n) > y(n+10)+150) && (y(n) > 550) && (y(n) < 900))
            
            beat_count = beat_count + 1;
            bpm = bpm + 1;

            time = DataTDK_1(n,2);
            elect_actv = DataTDK_1(n,3);

            res_DataTDK_1(beat_count,1) = n; 
            res_DataTDK_1(beat_count,2) = time;
            res_DataTDK_1(beat_count,3) = elect_actv;
            res_DataBPM_1(k,c) = bpm;
            
        end

    end

    plot(x,y,'-o')
    hold on
    
    k = k + 1;
    
end

hold off

%% 
beat_count = 0;

%%Graph, beat detection, bpm calculation for IWORX data
for k = 1 : length(lowIWRX_1) %length of time so this script can scale to a larger or smaller data set
    
    c = 4; %column for BPM
    
    l = lowIWRX_1(k); %setting initial time value, start of the minute we are evaluating
    h = highIWRX_1(k); %setting final time value, end of the minute we are evaluating
    
    x = DataIWRX_1(l:h,1)/60; %Full range of x data (time)
    y = DataIWRX_1(l:h,2)*100; %Full range of y data (electical activity)
    
    bpm = 0; %Reset bpm for every minute under evaluation
   
    for n = 6 : length(y)-3 
        
        if((y(n) > y(n-1)) && (y(n) > y(n+1)) && (y(n) > y(n-5)+.015) && (y(n) > y(n+3)+ .025) && (y(n) > 0))
            
            beat_count = beat_count + 1;
            bpm = bpm + 1;

            time = DataIWRX_1(n,1); %Convert from seconds to minutes?
            elect_actv = DataIWRX_1(n,2);
            
            res_DataIWRX_1(beat_count,1) = n; 
            res_DataIWRX_1(beat_count,2) = time;
            res_DataIWRX_1(beat_count,3) = elect_actv;
            res_DataBPM_1(k,c) = bpm;
            
        end

    end

     plot(x,y,'-o')
     hold on
    
    k = k + 1;
    
end
hold off
