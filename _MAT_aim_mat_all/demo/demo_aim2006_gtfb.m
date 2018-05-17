% Script to compare the AIM2006 output for four files (listed below)
% This scrips creates six figure windows, one for each stage of the AIM
% processing model and plots four panes, one for each file in each one

% (c) 2006-2008, University of Cambridge, Medical Research Council 
% Tom Walters tcw24@cam.ac.uk
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

filenames{1}='aa110p122s100t.wav';
filenames{2}='aa256p122s100t.wav';
filenames{3}='aa110p089s100t.wav';
filenames{4}='aa256p089s100t.wav';


analysis_start_time=0;
analysis_end_time=0.2;

display_start_time=0.13;
display_end_time=0.154;

bmm_scaling=16;
nap_scaling=0.008;
sai_scaling=0.004;
mellin_scaling=16;

for ii=1:length(filenames)
    name=filenames{ii};
    
    % Find the pitch and scale of the input sound from the filename
    inp=strfind(name,'p');
    pitch=str2num(name(inp-3:inp-1));
    ins=strfind(name,'s');
    scale=str2num(name(ins-3:ins-1));
    
    % Set the parameters for analysis of the sound
    gtfb_options=setparams_gtfb(filenames{ii}, analysis_start_time, analysis_end_time);
    
    
    % Analyse with aim2006
    gtfb_output{ii}=aim(gtfb_options);
    
    
    options.minimum_time=display_start_time;
    options.maximum_time=display_end_time;
    
    title_string=['Pitch:' num2str(pitch) ' Scale:' num2str(scale)];
    
    figure(1)
    set(gcf, 'Name', ['PCP: ' gtfb_output{ii}.info.current_pcp_module]);
    subplot(2,2,ii);
    plot(gtfb_output{ii}.data.pcp, [display_start_time display_end_time]);
    
    figure(2)
    set(gcf, 'Name', ['BMM: ' gtfb_output{ii}.info.current_bmm_module]);
    subplot(2,2,ii);
    plot_bmm(gtfb_output{ii}, options, bmm_scaling,title_string);
    
    figure(3)
    set(gcf, 'Name', ['NAP: ' gtfb_output{ii}.info.current_nap_module]);
    subplot(2,2,ii);
    plot_nap(gtfb_output{ii},options, nap_scaling,title_string);
    
    figure(4)
    set(gcf, 'Name', ['SP: ' gtfb_output{ii}.info.current_strobes_module]);
    subplot(2,2,ii);
    %plot(gtfb_output{ii}.data.nap);
    %hold on;
    plot_strobes(gtfb_output{ii}, options, nap_scaling,title_string);
    
    max_frame=length(gtfb_output{ii}.data.sai);
    
    figure(5)
    set(gcf, 'Name', ['SAI: ' gtfb_output{ii}.info.current_sai_module]);
    subplot(2,2,ii);
    plot_sai(gtfb_output{ii},max_frame, sai_scaling,title_string);
    
    figure(6)
    set(gcf, 'Name', ['Usermodule: ' gtfb_output{ii}.info.current_usermodule_module]);
    subplot(2,2,ii);
    plot_mellin(gtfb_output{ii},max_frame, mellin_scaling, title_string);
    
end