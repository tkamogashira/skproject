% method of class @frame
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/03/20 18:24:22 $
% $Revision: 1.4 $

function fr=frame(val,framestruct,cf)
% Construktor der Frameklasse

    % values that are used, when called from SBreadAIFF
    % fr.structure.totalframetime=frameLength/sampleRate;
    % fr.structure.numWindowFrames=numWindowFrames;
    % fr.structure.scale=scale;
    % fr.structure.wordSize=wordSize;
    % fr.structure.soundPosition=soundPosition;
    % fr.structure.littleEndian=littleEndian;
    % fr.structure.frameLength=frameLength;
    % fr.structure.numChannels=numChannels;
    % fr.structure.numSampleFrames=numSampleFrames;
    % fr.structure.sampleSize=sampleSize;
    % fr.structure.sampleRate=sampleRate;
    % fr.structure.interleaveLevel=interleaveLevel;
    % fr.structure.numWindowFrames=numWindowFrames;
    % fr.structure.staticTimeFlag=staticTimeFlag;
    % fr.structure.outputTimeOffset=outputTimeOffset;
    % fr.structure.absoluteNormalise=absoluteNormalise;

    % valus that are used when more then one frame make a movie
    % fr.movie.scale_summe= the higest value of a sum
    % fr.movie.current_frame_number= the current number of this frame
    % fr.movie.current_frame_start_time; the starting time of this frame
    % fr.movie.nr_frames_total;
    % fr.movie.all_min_value; 
    % fr.movie.all_max_value; 

if nargin==0 % this must be there see help http://www.mathworks.com/access/helpdesk/help/techdoc/matlab_prog/ch14_o11.shtml#27700
    fr.structure=[];
    fr.movie.nr_frames_total=1;
    fr.movie.all_min_value=0;
    fr.movie.all_max_value=1;  % important for the overall scaling of all frames
    fr.movie.scale_summe=1;
    fr.movie.scale_frequency=1;
    fr.movie.current_frame_number=1;
    fr.movie.current_frame_start_time=0;
    fr.start_time=0;    
    fr.centerfrequencies=(1:10)*1000;
    fr.text='';
    fr.x_axis_label='time (ms)';
    fr.samplerate=1000;
    fr.values=zeros(10,1000);
    fr.name='empty frame';
    
elseif nargin ==1
    if isobject(val)    % KopieKontruktor
        fr.structure=val.structure;
        fr.movie=val.movie;
        fr.start_time=val.start_time;
        fr.centerfrequencies=val.centerfrequencies;
        fr.text=val.text;
        fr.x_axis_label='time (ms)';
        fr.samplerate=val.samplerate;
        fr.values=val.values;
        fr.name=val.name;
    elseif isstruct(val)  % Aufruf von load
        fr.structure=val.structure;
        fr.movie=val.movie;
        fr.start_time=val.start_time;
        fr.centerfrequencies=val.centerfrequencies;
        fr.text=val.text;
        fr.x_axis_label='time (ms)';
        fr.samplerate=val.samplerate;
        fr.values=val.values;
        fr.name=val.name;
    else% Aufruf mit einem Array:
        fr.structure=[];
        fr.movie.nr_frames_total=1;
        fr.movie.all_min_value=0;
        fr.movie.all_max_value=1;  % important for the overall scaling of all frames
        fr.movie.scale_summe=1;
        fr.movie.scale_frequency=1;
        fr.movie.current_frame_number=1;
        fr.movie.current_frame_start_time=0;
        
        fr.start_time=0;
        fr.centerfrequencies=(1:size(val,1))*1000;
        fr.text='';
        fr.x_axis_label='time (ms)';
        fr.samplerate=16000;
        %if size(val,1) > size(val,2)
        %    val=val';
        %end
        fr.values=val;
        fr.name='empty frame';
    end
else
    % this values come from the constructof of an SBreadAIFF
    fr.structure=framestruct;

    % values that describe the frame in comparison to all frames 
    fr.movie.nr_frames_total=1;
    fr.movie.all_min_value=0;
    fr.movie.all_max_value=1;  % important for the overall scaling of all frames
    fr.movie.scale_summe=1;
    fr.movie.scale_frequency=1;
    fr.movie.current_frame_number=1;
    fr.movie.current_frame_start_time=0;
    
    fr.start_time=framestruct.outputTimeOffset;
    if nargin < 3
        fr.centerfrequencies=1:size(val,1);
    else
        fr.centerfrequencies=cf;
    end
    % this text is plotted together with the frame
    fr.text='';
    fr.x_axis_label='time (ms)';
    fr.samplerate=framestruct.sampleRate; % in pixel/sec
    if size(val,1) > size(val,2)
        val=val';
    end
    fr.values=val;
    fr.name='generic frame';
end % single parameter konstructor

fr=class(fr,'frame');