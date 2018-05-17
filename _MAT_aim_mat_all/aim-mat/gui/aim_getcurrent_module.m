% procedure for 'aim-mat'
% 
%   INPUT VALUES:
% column number
%   RETURN VALUE:
%	
% 
% helping function, that gives back the current selected module for a given
% column number
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org





function [generating_module,generating_function,coptions]=aim_getcurrent_module(handles,columnnr)


switch columnnr
	case 2
		options=handles.all_options.pcp;
		generating_module=handles.info.current_pcp_module;	% this one is selected by the user
		handles.info.calculated_pcp_module=generating_module;	% this one is really calculated
		generating_functionline=['options.' generating_module '.generatingfunction'];
		eval(sprintf('generating_function=%s;',generating_functionline'));
		optline=sprintf('coptions=%s.%s;','handles.all_options.pcp',generating_module);
		eval(optline);
	case 3
		options=handles.all_options.bmm;
		generating_module=handles.info.current_bmm_module;	
		handles.info.calculated_bmm_module=generating_module;	% this one is really calculated
		generating_functionline=['options.' generating_module '.generatingfunction'];
		eval(sprintf('generating_function=%s;',generating_functionline'));
		optline=sprintf('coptions=%s.%s;','handles.all_options.bmm',generating_module);
		eval(optline);
	case 4
		options=handles.all_options.nap;
		generating_module=handles.info.current_nap_module;	
		handles.info.calculated_nap_module=generating_module;	% this one is really calculated
		generating_functionline=['options.' generating_module '.generatingfunction'];
		eval(sprintf('generating_function=%s;',generating_functionline'));
		optline=sprintf('coptions=%s.%s;','handles.all_options.nap',generating_module);
		eval(optline);
	case 5
		options=handles.all_options.strobes;
		generating_module=handles.info.current_strobes_module;	
		handles.info.calculated_strobes_module=generating_module;	% this one is really calculated
		generating_functionline=['options.' generating_module '.generatingfunction'];
		eval(sprintf('generating_function=%s;',generating_functionline'));
		optline=sprintf('coptions=%s.%s;','handles.all_options.strobes',generating_module);
		eval(optline);
	case 6
		options=handles.all_options.sai;
		generating_module=handles.info.current_sai_module;	
		handles.info.calculated_sai_module=generating_module;	% this one is really calculated
		generating_functionline=['options.' generating_module '.generatingfunction'];
		eval(sprintf('generating_function=%s;',generating_functionline'));
		optline=sprintf('coptions=%s.%s;','handles.all_options.sai',generating_module);
		eval(optline);
	case 7
		options=handles.all_options.usermodule;
		generating_module=handles.info.current_usermodule_module;	
		handles.info.calculated_usermodule_module=generating_module;	% this one is really calculated
		generating_functionline=['options.' generating_module '.generatingfunction'];
		eval(sprintf('generating_function=%s;',generating_functionline'));
		optline=sprintf('coptions=%s.%s;','handles.all_options.usermodule',generating_module);
		eval(optline);
	case 8
		options=handles.all_options.movie;
		generating_module=handles.info.current_movie_module;
		handles.info.calculated_movie_module=generating_module;	% this one is really calculated
		generating_functionline=['options.' generating_module '.generatingfunction'];
		eval(sprintf('generating_function=%s;',generating_functionline'));
		optline=sprintf('coptions=%s.%s;','handles.all_options.movie',generating_module);
		eval(optline);
end