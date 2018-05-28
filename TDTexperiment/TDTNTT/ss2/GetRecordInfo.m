function Rtn=GetRecordInfo(RootName)
%GetRecordInfo -- Get information about the recording
% 
%Usage: Rtn=GetRecordInfo(RootName)
% 
% The output is a structure as below
% Rtn.FsRP2=FsRP2;
% Rtn.FsRA16=FsRA16;
% Rtn.NStim=NStim;
% Rtn.MaxVolt=MaxVolt;
% Rtn.LChanFlag=LChanFlag;
% Rtn.RChanFlag=RChanFlag;
% Rtn.ISI=ISI;
% Rtn.StimIndex=StimIndex; %N-by-2 matrix, first row for stim numbers presented,
%                           %second for the number of points
%
%By SF, 06/19/02

%File name of the info
fname=fullfile(RootName,'Info.txt');

%Read the header
fid=fopen(fname);
while 1
    tline = fgetl(fid); %Read one line
    
    %If the line does not contain characters,
    %that is the end of the file or the header.
    if ~ischar(tline), break, end 
    if isempty(tline), break, end 
    
    %Lines with %s indicates paramters
    if strcmpi(tline(1),'%')
        eval([tline(2:end) ';']);
    end        
end
fclose(fid);

%Load the numeric part for the file
StimIndex=load(fname);

%Put values to a structure
Rtn.FsRP2=FsRP2;
Rtn.FsRA16=FsRA16;
Rtn.NStim=NStim;
Rtn.MaxVolt=MaxVolt;
Rtn.LChanFlag=LChanFlag;
Rtn.RChanFlag=RChanFlag;
Rtn.ISI=ISI;
Rtn.StimIndex=StimIndex;



