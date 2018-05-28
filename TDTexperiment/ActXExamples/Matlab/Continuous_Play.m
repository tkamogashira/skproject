% Continuous play example using a serial buffer
% This program writes to the rambuffer once it has cyled half way through the buffer

% filePath - set this to wherever the examples are stored
filePath = 'C:\TDT\ActiveX\ActXExamples\matlab\';

npts=100000;  % Size of the serial buffer
bufpts = npts/2; % Number of points to write to buffer

RP = Circuit_Loader('C:\TDT\ActiveX\ActXExamples\RP_files\Continuous_Play.rcx'); % Runs Circuit_Loader

if RP.GetStatus==7

    % Generate two tone signals to play out in MATLAB
    freq1=1000;
    freq2=5000;
    fs=97656.25;
    
    t=(1:bufpts)/fs;
    s1=sin(2*pi*t*freq1);
    s2=sin(2*pi*t*freq2);
    
    
    % Serial Buffer will be divided into two Buffers A & B
    % Load up entire buffer with Segments A and B
    
    RP.WriteTagV('datain', 0, s1);
    RP.WriteTagV('datain', bufpts-1, s2);

    % Start Playing
    RP.SoftTrg(1);
    curindex=RP.GetTagVal('index');
    
    % Main Looping Section
    for i = 1:10

        % Wait until done playing A
        while(curindex<bufpts) % Checks to see if it has played from half the buffer
            curindex=RP.GetTagVal('index');
        end

        % Loads the next signal segment
        freq1=freq1+1000;
        s1=sin(2*pi*t*freq1);
        RP.WriteTagV('datain', 0, s1);

        % Checks to see if the data transfer rate is fast enough
        curindex=RP.GetTagVal('index');
        if(curindex<bufpts)
            disp('Transfer rate is too slow');
        end

        % Wait until start playing A
        while(curindex>bufpts)
            curindex=RP.GetTagVal('index');
        end

        % Load B
        freq2=freq2+1000;
        s2=sin(2*pi*t*freq2);
        RP.WriteTagV('datain', bufpts,s2);

        % Make sure still playing A
        curindex=RP.GetTagVal('index');
        if(curindex>bufpts)
            disp('Transfer rate is too slow');
        end
        
        % Loop back to wait until done playing A
    end

    % Stop playing
    RP.SoftTrg(2);
    RP.Halt;
end