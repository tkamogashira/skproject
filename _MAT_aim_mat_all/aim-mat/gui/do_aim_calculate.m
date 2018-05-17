% procedure for 'aim-mat'
% 
% function handles=do_aim_calculate(handles)
%
%   INPUT VALUES:
%  		handles: all relevant data and information in a struct
%   RETURN VALUE:
%		handles: the updated data 
%
% this function does all relevant calculation (can be called with or
% without graphic. 
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function handles=do_aim_calculate(handles)
% 
% % if in the graphic version, then we take the parameters from the parameter
% % file. If in the nographic version, all parameters come in handles.

% save for later
oldoptions=handles.all_options;

if handles.with_graphic==1
    set(handles.figure1,'Pointer','watch'); % set the mousepointer to the busy-sign
    
    if ~isfield(handles.info,'no_automatic_parameter_update')
        no_automatic_parameter_update=1;
    else
        no_automatic_parameter_update=handles.info.no_automatic_parameter_update;
    end
    
    if no_automatic_parameter_update==0
        % first read in the new parameter values and see, which ones have changed
        parfile=handles.info.parameterfilename;
        [pathstr,parfilename,ext] = fileparts(parfile);
        old=pwd;
        lookpath=fullfile(handles.info.original_soundfile_directory,pathstr);
        cd(lookpath);
        eval(parfilename);
        cd(old);
        newoptions=all_options;
        handles.all_options=newoptions;
    end
end


% first calculate the signal
% check, if the signal has been changed:
sigopts=handles.all_options.signal;
sig=handles.data.signal;
changesig=0;
if sigopts.duration~=getlength(sig);
	changesig=1;
end
if sigopts.start_time~=getminimumtime(sig);
	changesig=1;
end
if structisequal(oldoptions.signal,handles.all_options.signal) 
	changesig=1;
end
	
if changesig
		%|| handles.info.calculate_signal==1
	start=handles.all_options.signal.start_time;
	duration=handles.all_options.signal.duration;
	orgsig=handles.data.original_signal;
	
	% do some error checking, just in case:
	sigdur=getlength(orgsig);
	start=max(start,0);
	start=min(start,sigdur-0.001);
	duration=max(0,duration);
	duration=min(duration,sigdur-start);
	
	sig=getpart(orgsig,start,start+duration);
	handles.data.signal=sig;
	name=handles.info.signalname;
	lookpath=fullfile(handles.info.original_soundfile_directory,name);
	graphic_dir=fullfile(handles.info.original_soundfile_directory,handles.info.directoryname);
	
    if exist(graphic_dir)==7 % only, if not in ne graphic mode
    	aim_savefile(handles,sig,name,'signal','signal',[],handles.all_options);
		signame= fullfile(handles.info.original_soundfile_directory,handles.info.signalwavename);
		savewave(sig,signame,0);
    end

% 	handles.info.calculate_signal=0;
	
end



% calculate outerear /middle ear transfere function 
% if get(handles.checkbox0,'Value')==1
if handles.info.calculate_pcp==1
	[generating_module,generating_function,coptions]=aim_getcurrent_module(handles,2);
 	handles.info.calculated_pcp_module=generating_module;	% this one is really calculated
	sig=handles.data.signal;
	callline=sprintf('res=%s(sig,coptions);',generating_function);
	eval(callline);	% evaluate the generating function
	% store the result
	handles.data.pcp=res;

	if handles.info.save_pcp==1
		aim_savefile(handles,res,handles.info.pcpname,'pcp',generating_module,coptions,handles.all_options);
	end	
	if handles.with_graphic==1
		handles.info.pcp_loaded=1;
		handles.info.current_plot=2;    % display the new data
		set(handles.checkbox0,'Value',0);
		handles=aim_deletefile(handles,'bmm');
		handles=aim_deletefile(handles,'nap');
		handles=aim_deletefile(handles,'strobes');
		handles=aim_deletefile(handles,'sai');
		handles=aim_deletefile(handles,'usermodule');
	end
end

% calculate outer ear middle ear transfere functin 
% if get(handles.checkbox1,'Value')==1
if handles.info.calculate_bmm==1
	[generating_module,generating_function,coptions]=aim_getcurrent_module(handles,3);
 	handles.info.calculated_bmm_module=generating_module;	% this one is really calculated
	sig=handles.data.pcp;
	callline=sprintf('res=%s(sig,coptions);',generating_function);
	eval(callline);
	% store the result
	handles.data.bmm=res;
	if handles.info.save_bmm==1
		aim_savefile(handles,res,handles.info.bmmname,'bmm',generating_module,coptions,handles.all_options);
	end
	if handles.with_graphic==1
		handles.info.bmm_loaded=1;
		handles.info.current_plot=3;    % display the new data
		% if this one is calculated new, then the further part has no relevance any more:
		set(handles.checkbox1,'Value',0);
		handles=aim_deletefile(handles,'nap');
		handles=aim_deletefile(handles,'strobes');
		handles=aim_deletefile(handles,'sai');
		handles=aim_deletefile(handles,'usermodule');
	end
end

% calculate NAP
% if get(handles.checkbox2,'Value')==1
if handles.info.calculate_nap==1
	[generating_module,generating_function,coptions]=aim_getcurrent_module(handles,4);
 	handles.info.calculated_nap_module=generating_module;	% this one is really calculated
	bmm=handles.data.bmm;
	callline=sprintf('res=%s(bmm,coptions);',generating_function);
	eval(callline);
	% store the result
	handles.data.nap=res;
	if handles.info.save_nap==1
		aim_savefile(handles,res,handles.info.napname,'nap',generating_module,coptions,handles.all_options);
	end	
	if handles.with_graphic==1
		handles.info.nap_loaded=1;
		handles.info.current_plot=4;    % display the new data
		% if this one is calculated new, then the further part has no relevance any more:
		set(handles.checkbox2,'Value',0);
		handles=aim_deletefile(handles,'strobes');
		handles=aim_deletefile(handles,'sai');
		handles=aim_deletefile(handles,'usermodule');
	end
end

% calculate Strobes
% if get(handles.checkbox3,'Value')==1
if handles.info.calculate_strobes==1
	[generating_module,generating_function,coptions]=aim_getcurrent_module(handles,5);
 	handles.info.calculated_strobes_module=generating_module;	% this one is really calculated
	nap=handles.data.nap;
	callline=sprintf('[res,thres]=%s(nap,coptions);',generating_function);
	eval(callline);
	% store the result
	handles.data.strobes=res;
	if handles.info.save_strobes==1
		aim_savefile(handles,res,handles.info.strobesname,'strobes',generating_module,coptions,handles.all_options);
% 		if isoftype(handles.data.bmm,'frame') && getnrchannels(handles.data.bmm)==1
		aim_savefile(handles,thres,handles.info.thresholdsname,'thresholds',generating_module,coptions,handles.all_options);
% 		end
	end
	if handles.with_graphic==1
		% if we only have one channel, then it is useful also to have the
		% thresholds:
		
		handles.data.thresholds=thres;
		handles.info.strobes_loaded=1;
		handles.info.current_plot=5;    % display the new data
		
		% if this one is calculated new, then the further part has no relevance any more:
		set(handles.checkbox3,'Value',0);
		handles=aim_deletefile(handles,'sai');
		handles=aim_deletefile(handles,'usermodule');
        
        %TCW AIM2006
        handles=aim_deletefile(handles,'pitch_image');
        % This cleans up after pitchresonance and other dual output SAI 
        % modules but will log an error to the command window if the
        % previous SAI module wasn't dual output. This is a bug and needs fixing. 
	end
end

% calculate SAI
% if get(handles.checkbox4,'Value')==1
if handles.info.calculate_sai==1
	[generating_module,generating_function,coptions]=aim_getcurrent_module(handles,6);
 	handles.info.calculated_sai_module=generating_module;	% this one is really calculated
	nap=handles.data.nap;
	strobes=handles.data.strobes;
	callline=sprintf('res=%s(nap,strobes,coptions);',generating_function);

	% add the soundfilename in case for ams
	if strcmp(generating_module,'ams')	% for one channel we additionally pass the threshold:
		coptions.soundfile=handles.info.oldsignalwavename;
	else
		if getnrchannels(handles.data.bmm)==1	% for one channel we additionally pass the threshold:
		coptions.single_channel_threshold=handles.data.thresholds;
		end		
    end	
	
	eval(callline);
    
    % This module is a special case, as we can have two sorts of output
    % from it, either the straight SAI (as seen in AIM 2003), or a pair of images: the pitch
    % image and resonance image. If the dual_output option is set to 1 in
    % the parameters file, then the module is taken to have two outputs.
    % One of these outputs, the resonance image, gets put in the old 'sai'
    % part of the structure, and the pitch image is placed in a new
    % structure, 'pitch_image'.
    if ~isfield(coptions, 'dual_output')
        coptions.dual_output=0;
    end
    
    % store the result
    if (coptions.dual_output==1)
        handles.data.sai=res{1};
        handles.data.pitch_image=res{2};
    else
        handles.data.sai=res;
    end
    
    
	%handles.data.sai=res;
	
    if handles.info.save_sai==1
        if (coptions.dual_output==1)
            aim_savefile(handles,res{1},handles.info.sainame,'sai',generating_module,coptions,handles.all_options);
            aim_savefile(handles,res{2},handles.info.pitch_imagename,'pitch_image',generating_module,coptions,handles.all_options);
        else
            aim_savefile(handles,res,handles.info.sainame,'sai',generating_module,coptions,handles.all_options);
        end
	end
	
	if handles.with_graphic==1
		handles.info.sai_loaded=1;
		handles.info.current_plot=6;    % display the new data
		% if this one is calculated new, then the further part has no relevance any more:
		set(handles.checkbox4,'Value',0);
		handles=aim_deletefile(handles,'usermodule');
	end
end


% calculate user module
% if get(handles.checkbox8,'Value')==1
if handles.info.calculate_usermodule==1
	[generating_module,generating_function,coptions]=aim_getcurrent_module(handles,7);
 	handles.info.calculated_usermodule_module=generating_module;	% this one is really calculated
	
    sai=handles.data.sai;
    
    % TCW AIM2006 - to cary through pitch-resonance output to the latter
    % stages
    if ~isfield(coptions, 'dual_input')
        coptions.dual_input=0;
    end
    

    if coptions.dual_input==1
        if isfield(handles.data, 'pitch_image')
            pitch_image=handles.data.pitch_image;
        	callline=sprintf('res=%s(sai,pitch_image,coptions);',generating_function);
        else
             error(['The module ' generating_module ' is dual input, but the SAI module used before it'...
             ' was not dual output, please use a compatible module at this stage'...
             ' for more information, see the documentation at'...
             ' http://www.pdn.cam.ac.uk/cnbh/aim2006/']);
        end
    else
        if isfield(handles.data, 'pitch_image')
        	error(['The module ' generating_module ' is not dual input, but the SAI module used before it'...
             ' was dual output, please use a compatible module at this stage'...
             ' for more information, see the documentation at'...
             ' http://www.pdn.cam.ac.uk/cnbh/aim2006/']);
        else
             callline=sprintf('res=%s(sai,coptions);',generating_function);
        end
        
    end
    

    eval(callline);

	% store the result
	handles.data.usermodule=res;
	if handles.info.save_usermodule==1
		aim_savefile(handles,res,handles.info.usermodulename,'usermodule',generating_module,coptions,handles.all_options);
	end
	if handles.with_graphic==1
		handles.info.usermodule_loaded=1;
		handles.info.current_plot=7;    % display the new data
		% if this one is calculated new, then the further part has no relevance any more:
		set(handles.checkbox8,'Value',0);
	end	
end

% calculate movies
% if get(handles.checkbox5,'Value')==1
if handles.info.calculate_movie==1
	[generating_module,generating_function,coptions]=aim_getcurrent_module(handles,8);
	handles.info.calculated_movie_module=generating_module;	% this one is really calculated
% 	if strcmp(handles.info.current_usermodule_module,'none')
% 		data=handles.data.sai;
% 	else
% 		data=handles.data.usermodule;
% 	end
	
% 	% if we dont know about the framerate, then get the framerate from the
% 	% sai-module
% 	if ~isfield(coptions,'frames_per_second') 
% 		[mod,func,opts]=aim_getcurrent_module(handles,7); % try in the usermodule
% 		if ~isfield(opts,'frames_per_second')
% 			[mod,func,opts2]=aim_getcurrent_module(handles,6); % try in the sai-module
% 			if ~isfield(opts2,'frames_per_second')
% 				disp('dont know about the framerate! Assuming 20');
% 				coptions.frames_per_second=20; % dont know about it
% 			else
% 				coptions.frames_per_second=opts2.frames_per_second;
% 			end
% 		else
% 			coptions.frames_per_second=opts.frames_per_second;
% 		end
% 	end
		
		
	% in case of the screen-movie, we need some additional information:
% 	if strcmp(handles.info.current_movie_module,'screen')
		if handles.with_graphic==1
			if get(handles.checkbox7,'Value')==1
				handles.all_options.movie.screen.withtime=1;
				coptions.withtime=1;
			else
				handles.all_options.movie.screen.withtime=0;
				coptions.withtime=0;
			end
			% and if we want to see the frequency profile:
			if get(handles.checkbox6,'Value')==1
				handles.all_options.movie.screen.withfre=1;
				coptions.withfre=1;
			else
				handles.all_options.movie.screen.withfre=0;
				coptions.withfre=0;
			end
			% do we want to see the signal?
			if get(handles.checkbox10,'Value')==1
				handles.all_options.movie.screen.withsignal=1;
				coptions.withsignal=1;
			else
				handles.all_options.movie.screen.withsignal=0;
				coptions.withsignal=0;
			end
			% scaling properties
			data_scale=slidereditcontrol_get_value(handles.slideredit_scale);
			handles.all_options.movie.screen.data_scale=data_scale;
			coptions.data_scale=data_scale;
		end
% 	end

    % give the movie access to all data, which is useful for bmm, etc
    data=handles.data;
	
	
	% add a few names to the options, so that the movie can be saved
	if handles.with_graphic==1
		uniqueworkingname=handles.info.uniqueworkingname;
		directoryname=handles.info.directoryname;
		% find out the name of this movie. Movies are numberd in their
		% order, so that no one is lost
		moviename=generate_new_movie_name(handles);
		newname=fullfile(handles.info.uniqueworkingname,moviename);
		coptions.moviename=newname;
		coptions.soundfilename=handles.info.signalwavename;
		coptions.handles=handles;
		callline=sprintf('%s(data,coptions);',generating_function);
		eval(callline);
		handles.info.movie_loaded=1;
		handles.info.last_movie_name_generated=moviename;
		set(handles.checkbox5,'Value',0);
	else
		coptions.moviename=sprintf('%s.%s.mov',handles.info.uniqueworkingname,handles.info.current_movie_module);
		coptions.soundfilename=handles.all_options.signal.signal_filename;
		coptions.handles=handles;
		callline=sprintf('%s(sai,coptions);',generating_function);
		eval(callline);
	end
end

% return the pointer shape
if handles.with_graphic==1
	set(handles.figure1,'Pointer','arrow');
end
