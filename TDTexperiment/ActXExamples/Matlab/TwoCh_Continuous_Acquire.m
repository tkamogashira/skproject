% Two-channel continous acquistion example using a serial buffer
% This program reads from a rambuffer once it has cycled half way through the buffer

npts=100000;  % Size of the serial buffer
bufpts = npts/2; % Number of points to write to buffer
fs=97656.25;
t=(1:bufpts)/fs;
noise=t;

RP = Circuit_Loader('C:\TDT\ActiveX\ActXExamples\RP_files\TwoCh_Continuous_Acquire.rcx');

if RP.GetStatus==7
    
    fnoise = fopen('C:\TDT\ActiveX\ActXExamples\matlab\shuf2.dat','w');
    plot(t,noise);
    RP.SoftTrg(1);
    
    % Main Looping Section
    for i = 1:1
        curindex=RP.GetTagVal('index');
        disp(['Current index: ' num2str(curindex)]);
        
        % Wait until first half of Buffer fills
        while(curindex<bufpts) % Checks to see if it has read into half the buffer
  	        curindex=RP.GetTagVal('index');
        end
        
        % Reads first segment
        noise=RP.ReadTagVEX('dataout', 0, bufpts,'I16','F64',2); % Reads from the buffer
        disp(['Wrote ' num2str(fwrite(fnoise,noise,'double')) ' points to file']);
        
	    % Checks to see if the data transfer rate is fast enough
        curindex=RP.GetTagVal('index');
        disp(['Current index: ' num2str(curindex)]);
	    if(curindex<bufpts)
 	        disp('Transfer rate is too slow');
        end

    	% Wait until second half of buffer fills
	    while(curindex>bufpts)
   	        curindex=RP.GetTagVal('index');
        end
        
        % Read second segment
        noise=RP.ReadTagVEX('dataout', bufpts, bufpts,'I16','F64',2); % Reads from the buffer
        disp(['Wrote ' num2str(fwrite(fnoise,noise,'double')) ' points to file']);
        
        % Checks to see if the data transfer rate is fast enough
        curindex=RP.GetTagVal('index');
        disp(['Current index: ' num2str(curindex)]);
	    if(curindex>bufpts)
   	        disp('Transfer rate is too slow');
	    end
        % Loop back to start of data capture routine.
    end
    fclose(fnoise);
    
    % Stop playing
    RP.SoftTrg(2);
    RP.Halt;
end

plot(t,noise); % Plots the last 1/2 second of acquistion   