% Continuous acquistion example using a serial buffer
% This program reads from a rambuffer once it has cyled half way through the buffer

% filePath - set this to wherever the examples are stored
filePath = 'C:\TDT\ActiveX\ActXExamples\matlab\';

npts=100000;  % Size of the serial buffer
bufpts = npts/2; % Number of points to write to buffer
fs=97656.25;
t=(1:bufpts)/fs;
noise=t;

RP = Circuit_Loader('C:\TDT\ActiveX\ActXExamples\RP_files\Continuous_Acquire.rcx'); % Runs Circuit_Loader.

if invoke(RP,'GetStatus')==7
    
    filePath = strcat(filePath, 'fnoise2.F32');
    fnoise = fopen(filePath,'w');
    plot(t,noise);
    
    % Begin acquiring
    invoke(RP, 'SoftTrg', 1);

    % Main Looping Section
    for i = 1:10            
        curindex=invoke(RP, 'GetTagVal', 'index');
        disp(['Current index: ' num2str(curindex)]);
        
        % Wait until first half of Buffer fills
	    while(curindex<bufpts) % Check to see if it has read into half the buffer
  	        curindex=invoke(RP, 'GetTagVal', 'index');
        end
        
        % Read first segment
        noise=invoke(RP, 'ReadTagV', 'dataout', 0, bufpts); % Read from the buffer
        disp(['Wrote ' num2str(fwrite(fnoise,noise,'float32')) ' points to file']); % Writes to a file
	    
        % Check to see if the data transfer rate is fast enough
        curindex=invoke(RP, 'GetTagVal', 'index');
        disp(['Current index: ' num2str(curindex)]);
	    if (curindex<bufpts)
   	       disp('Transfer rate is too slow');
        end

	    % Wait until second half of buffer fills
	    while(curindex>bufpts)
   	       curindex=invoke(RP, 'GetTagVal', 'index');
	    end

        % Read second segment
        noise=invoke(RP, 'ReadTagV', 'dataout', bufpts, bufpts); % Reads from the buffer
        disp(['Wrote ' num2str(fwrite(fnoise,noise,'float32')) ' points to file']); % Writes to a file
        
        % Check to see if the data transfer rate is fast enough
        curindex=invoke(RP, 'GetTagVal', 'index');
        disp(['Current index: ' num2str(curindex)]);
	    if(curindex>bufpts)
   	       disp('Transfer rate is too slow');
	    end
        
    % Loop back to start of data capture routine.
    end
    
    fclose(fnoise);    

    % Stop aquiring
    invoke(RP, 'SoftTrg', 2);
    invoke(RP, 'Halt');
end

plot(t,noise); % Plots the last 1/2 second of acquistion   