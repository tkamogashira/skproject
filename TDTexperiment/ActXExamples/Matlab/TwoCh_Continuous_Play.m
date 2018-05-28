% Two-channel continuous play example using a serial buffer
% This program writes to the rambuffer once it has cyled half way through the buffer

npts=100000;  % Size of the serial buffer
bufpts = npts/2; % Number of points to write to buffer

RP = Circuit_Loader('C:\TDT\ActiveX\ActXExamples\RP_files\TwoCh_Continuous_Play.rcx');

if RP.GetStatus==7
   
   % Generate two tone signals to play out in MATLAB
   
    freq1=1000;
    freq2=5000;
    fs=97656.25;
    
    t=(1:bufpts)/fs;
    s1=round(sin(2*pi*t*freq1)*32760);
    s2=round(sin(2*pi*t*freq2)*32760);
    
    % Serial buffer will be divided into two buffers A & B
    % Load up entire buffer with segments A and B
    
    s=[s1;s2]; % Concatenate two arrays into a matrix
    RP.WriteTagVEX('datain', 0, 'I16', s);  

    freq1=freq1+1000;
    freq2=freq2+1000;
    s3=round(sin(2*pi*t*freq1)*32760);
    s4=round(sin(2*pi*t*freq2)*32760);
    
    s=[s3;s4];
    RP.WriteTagVEX('datain', bufpts,'I16', s);

    % Start Playing
    RP.SoftTrg(1);
    curindex=RP.GetTagVal('index');
    disp(['Current index: ' num2str(curindex)]);
    
    % Main Looping Section
    for i = 1:5
   	    s=[s1;s3];
        
        % Wait until done playing A
	    while(curindex<bufpts) % Checks to see if it has played from half the buffer
  	        curindex=RP.GetTagVal('index');
        end
        
        % Loads the next signal segment
	    RP.WriteTagVEX('datain', 0,'I16', s);
        
	    % Checks to see if the data transfer rate is fast enough
	    curindex=RP.GetTagVal('index');
        disp(['Current index: ' num2str(curindex)]);
	    if(curindex<bufpts)
   	        disp('Transfer rate is too slow');
        end
        
	    % Wait until start playing A 
	    while(curindex>bufpts)
   	        curindex=RP.GetTagVal('index');
        end
        
        % Load B
        s=[s4;s2];
        RP.WriteTagVEX('datain', bufpts,'I16', s);

        % Make sure still playing A 
	    curindex=RP.GetTagVal('index');
        disp(['Current index: ' num2str(curindex)]);
	    if(curindex>bufpts)
   	        disp('Transfer rate too slow');
        end
        
	    % Loop back to wait until done playing A
    end

    % Stop Playing
    RP.SoftTrg(2);
    RP.Halt;
end






   