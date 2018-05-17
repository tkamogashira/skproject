% generating function for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function gen_screen_movie(data,options)

% movie generation works as follows: Copy all the handles (with all
% information to a local variable and pass that one to the plotting
% routine.
handles=options.handles;
% marker, that we are in a movie generation function
handles.info.domovie=1;

% if ~isfield(options,'frames_per_second')
% 	frames_per_second=20;
% else
% 	frames_per_second=options.frames_per_second;
% end

si=get(0,'ScreenSize');
waithand=waitbar(0,'generating movie');
set(waithand,'Units','Pixel');
si2=get(waithand,'Position');
si2(1)=110;
si2(2)=si(4)-si2(4)-25;
set(waithand,'Position',si2);

moviefilename=options.moviename;
soundfilename=options.soundfilename;
[sounddata,samplerate,bits] = wavread(soundfilename);

oldfig=gcf;
% if there has never been a figure, create a new one
options.figure_handle=figure;
newfig=options.figure_handle;


MakeQTMovie('clear');
MakeQTMovie('start',moviefilename);
MakeQTMovie('size', [options.movie_width options.movie_height]);
MakeQTMovie('quality', options.quality);    % reduces the size



handles=options.handles;
if handles.info.current_plot==6
    data=data.sai;
elseif handles.info.current_plot==7
    data=handles.data.usermodule;
end

nr_frames=length(data);
for ii=1:nr_frames
	waitbar(ii/nr_frames,waithand);

	figure(newfig);
    clf
	set(gca,'Position',[0 0.1 0.93 0.9]);
	
	if handles.with_graphic==1
		handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,ii);
	else
		handles.current_frame_nr=ii;
		handles.info.current_plot=6; % the usermodule
	end
	
	% plot the graphic with the standard method in the new window:
	handles=aim_replotgraphic(handles,options);
	
	drawnow;
	
	MakeQTMovie('addframe');    % and add it to the movie
end

% add one, to fill the last picture (the sound is longer than n*nr_frames)
MakeQTMovie('addframe');

% get the frame rate
frames_per_second=1/(getcurrentframestarttime(data{2})-getcurrentframestarttime(data{1}));
frames_per_second=round(frames_per_second);
if (frames_per_second == Inf)
   frames_per_second=nr_frames./(length(sounddata)./samplerate);
   frames_per_second=round(frames_per_second);
end


% Optional slowmotion of the movie for MIs without sound
if ~isfield(options,'slowmotion')
    options.slowmotion=1;
end

if (options.slowmotion == 1)
    MakeQTMovie('framerate',frames_per_second);
    MakeQTMovie('addsound',sounddata,samplerate);
else
    MakeQTMovie('framerate',round(frames_per_second / options.slowmotion));
end;

MakeQTMovie('finish');
MakeQTMovie('cleanup');
figure(oldfig);
close(newfig);

close(waithand);
