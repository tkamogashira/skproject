% demonstration file for 'aim-mat'
%
% (c) 2006-2008, University of Cambridge, Medical Research Council 
% Written by Tom Walters (tcw24@cam.ac.uk)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

% Parameters for the demonstration figures: gm2002/gtfb/hcl/sti03/mellin

%%%%%%%%%%%%%
%   16-Mar-2006
%   produced by Tom Walters



%%%%%%%%%%%%%

function all_options=setparams_gtfb(filename, starttime, endtime)

%%%%%%%%%%%%%
% Signaloptions
all_options.signal.signal_filename=filename;
all_options.signal.start_time=starttime;
all_options.signal.duration=endtime-starttime;

[x, fs]=wavread(filename);
all_options.signal.samplerate=fs;
all_options.signal.original_start_time=0;
all_options.signal.original_duration=length(x)/fs;
all_options.signal.original_samplerate=fs;


%%%%%%%%%%%%%
% outer/middle ear filter function

all_options.pcp.gm2002.generatingfunction='gen_gm2002';
all_options.pcp.gm2002.displayname='outer/middle ear transfere function from Glasberg and Moore (2002)';
all_options.pcp.gm2002.revision='$Revision: 585 $';
all_options.pcp.gm2002.select_correction=1;
all_options.pcp.gm2002.delay_correction=-0.04205;



%%%%%%%%%%%%%
% bmm
all_options.bmm.gtfb.generatingfunction='gen_gtfb';
all_options.bmm.gtfb.displayname='Gamma tone filter bank';
all_options.bmm.gtfb.revision='$Revision: 585 $';
all_options.bmm.gtfb.default_nextmodule='hcl';
all_options.bmm.gtfb.nr_channels=75;
all_options.bmm.gtfb.lowest_frequency=100;
all_options.bmm.gtfb.highest_frequency=6000;
all_options.bmm.gtfb.do_phase_alignment='off';
all_options.bmm.gtfb.phase_alignment_nr_cycles=3;
all_options.bmm.gtfb.b=1.019;




%%%%%%%%%%%%%
% nap

all_options.nap.hcl.generatingfunction='gen_hcl';
all_options.nap.hcl.displayname='halfwave rectification, compression and lowpass filtering';
all_options.nap.hcl.revision='$Revision: 585 $';
all_options.nap.hcl.compression='log';
all_options.nap.hcl.do_lowpassfiltering=1;
all_options.nap.hcl.lowpass_cutoff_frequency=1200;
all_options.nap.hcl.lowpass_order=2;



%%%%%%%%%%%%%
% strobes

all_options.strobes.sf2003.generatingfunction='gen_sf2003';
all_options.strobes.sf2003.displayname='strobe finding';
all_options.strobes.sf2003.revision='$Revision: 585 $';
all_options.strobes.sf2003.strobe_criterion='interparabola';
all_options.strobes.sf2003.strobe_decay_time=0.02;
all_options.strobes.sf2003.parabel_heigth=1.2;
all_options.strobes.sf2003.parabel_width_in_cycles=1.5;
all_options.strobes.sf2003.bunt=1.02;
all_options.strobes.sf2003.wait_cycles=1.5;
all_options.strobes.sf2003.wait_timeout_ms=20;
all_options.strobes.sf2003.slope_coefficient=1;



%%%%%%%%%%%%%
% sai
all_options.sai.ti2003.generatingfunction='gen_ti2003';
all_options.sai.ti2003.displayname='time integration stabilized auditory image on several sources';
all_options.sai.ti2003.revision='$Revision: 585 $';
all_options.sai.ti2003.criterion='change_weights';
all_options.sai.ti2003.mindelay=0.0005;
all_options.sai.ti2003.maxdelay=0.035;
all_options.sai.ti2003.buffer_memory_decay=0.03;
all_options.sai.ti2003.frames_per_second=200;
all_options.sai.ti2003.weight_threshold=0;
all_options.sai.ti2003.do_normalize=1;
all_options.sai.ti2003.do_times_nap_height=0;
all_options.sai.ti2003.do_adjust_weights=1;
all_options.sai.ti2003.strobe_weight_alpha=0.5;
all_options.sai.ti2003.delay_weight_change=0.5;
all_options.sai.ti2003.do_click_reduction=0;
all_options.sai.ti2003.click_reduction_sai='click_frame.mat';

% 
%%%%%%%%%%%%%
% user defined module
all_options.usermodule.mellin.generatingfunction='gen_mellin';
all_options.usermodule.mellin.displayname='mellin Image';
all_options.usermodule.mellin.displayfunction='displaymellin';
all_options.usermodule.mellin.revision='$Revision: 585 $';
all_options.usermodule.mellin.do_all_frames=0;
all_options.usermodule.mellin.framerange=[ 40 40];
all_options.usermodule.mellin.do_all_image=1;
all_options.usermodule.mellin.audiorange=[ 1 200];
all_options.usermodule.mellin.flipimage=0;
all_options.usermodule.mellin.c_2pi=[ 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4 4.05 4.1 4.15 4.2 4.25 4.3 4.35 4.4 4.45 4.5 4.55 4.6 4.65 4.7 4.75 4.8 4.85 4.9 4.95 5 5.05 5.1 5.15 5.2 5.25 5.3 5.35 5.4 5.45 5.5 5.55 5.6 5.65 5.7 5.75 5.8 5.85 5.9 5.95 6 6.05 6.1 6.15 6.2 6.25 6.3 6.35 6.4 6.45 6.5 6.55 6.6 6.65 6.7 6.75 6.8 6.85 6.9 6.95 7 7.05 7.1 7.15 7.2 7.25 7.3 7.35 7.4 7.45 7.5 7.55 7.6 7.65 7.7 7.75 7.8 7.85 7.9 7.95 8 8.05 8.1 8.15 8.2 8.25 8.3 8.35 8.4 8.45 8.5 8.55 8.6 8.65 8.7 8.75 8.8 8.85 8.9 8.95 9 9.05 9.1 9.15 9.2 9.25 9.3 9.35 9.4 9.45 9.5 9.55 9.6 9.65 9.7 9.75 9.8 9.85 9.9 9.95 10 10.05 10.1 10.15 10.2 10.25 10.3 10.35 10.4 10.45 10.5 10.55 10.6 10.65 10.7 10.75 10.8 10.85 10.9 10.95 11 11.05 11.1 11.15 11.2 11.25 11.3 11.35 11.4 11.45 11.5 11.55 11.6 11.65 11.7 11.75 11.8 11.85 11.9 11.95 12 12.05 12.1 12.15 12.2 12.25 12.3 12.35 12.4 12.45 12.5 12.55 12.6 12.65 12.7 12.75 12.8 12.85 12.9 12.95 13 13.05 13.1 13.15 13.2 13.25 13.3 13.35 13.4 13.45 13.5 13.55 13.6 13.65 13.7 13.75 13.8 13.85 13.9 13.95 14 14.05 14.1 14.15 14.2 14.25 14.3 14.35 14.4 14.45 14.5 14.55 14.6 14.65 14.7 14.75 14.8 14.85 14.9 14.95 15 15.05 15.1 15.15 15.2 15.25 15.3 15.35 15.4 15.45 15.5 15.55 15.6 15.65 15.7 15.75 15.8 15.85 15.9 15.95 16 16.05 16.1 16.15 16.2 16.25 16.3 16.35 16.4 16.45 16.5 16.55 16.6 16.65 16.7 16.75 16.8 16.85 16.9 16.95 17 17.05 17.1 17.15 17.2 17.25 17.3 17.35 17.4 17.45 17.5 17.55 17.6 17.65 17.7 17.75 17.8 17.85 17.9 17.95 18 18.05 18.1 18.15 18.2 18.25 18.3 18.35 18.4 18.45 18.5 18.55 18.6 18.65 18.7 18.75 18.8 18.85 18.9 18.95 19 19.05 19.1 19.15 19.2 19.25 19.3 19.35 19.4 19.45 19.5 19.55 19.6 19.65 19.7 19.75 19.8 19.85 19.9 19.95 20 20.05 20.1 20.15 20.2 20.25 20.3 20.35 20.4 20.45 20.5 20.55 20.6 20.65 20.7 20.75 20.8 20.85 20.9 20.95 21 21.05 21.1 21.15 21.2 21.25 21.3 21.35 21.4 21.45 21.5 21.55 21.6 21.65 21.7 21.75 21.8 21.85 21.9 21.95 22 22.05 22.1 22.15 22.2 22.25 22.3 22.35 22.4 22.45 22.5 22.55 22.6 22.65 22.7 22.75 22.8 22.85 22.9 22.95 23 23.05 23.1 23.15 23.2 23.25 23.3 23.35 23.4 23.45 23.5 23.55 23.6 23.65 23.7 23.75 23.8 23.85 23.9 23.95 24 24.05 24.1 24.15 24.2 24.25 24.3 24.35 24.4 24.45 24.5 24.55 24.6 24.65 24.7 24.75 24.8 24.85 24.9 24.95 25 25.05 25.1 25.15 25.2 25.25 25.3 25.35 25.4 25.45 25.5 25.55 25.6 25.65 25.7 25.75 25.8 25.85 25.9 25.95 26 26.05 26.1 26.15 26.2 26.25 26.3 26.35 26.4 26.45 26.5 26.55 26.6 26.65 26.7 26.75 26.8 26.85 26.9 26.95 27 27.05 27.1 27.15 27.2 27.25 27.3 27.35 27.4 27.45 27.5 27.55 27.6 27.65 27.7 27.75 27.8 27.85 27.9 27.95 28 28.05 28.1 28.15 28.2 28.25 28.3 28.35 28.4 28.45 28.5 28.55 28.6 28.65 28.7 28.75 28.8 28.85 28.9 28.95 29 29.05 29.1 29.15 29.2 29.25 29.3 29.35 29.4 29.45 29.5 29.55 29.6 29.65 29.7 29.75 29.8 29.85 29.9 29.95 30];
all_options.usermodule.mellin.TFval=[ 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4 4.05 4.1 4.15 4.2 4.25 4.3 4.35 4.4 4.45 4.5 4.55 4.6 4.65 4.7 4.75 4.8 4.85 4.9 4.95 5 5.05 5.1 5.15 5.2 5.25 5.3 5.35 5.4 5.45 5.5 5.55 5.6 5.65 5.7 5.75 5.8 5.85 5.9 5.95 6 6.05 6.1 6.15 6.2 6.25 6.3 6.35 6.4 6.45 6.5 6.55 6.6 6.65 6.7 6.75 6.8 6.85 6.9 6.95 7 7.05 7.1 7.15 7.2 7.25 7.3 7.35 7.4 7.45 7.5 7.55 7.6 7.65 7.7 7.75 7.8 7.85 7.9 7.95 8 8.05 8.1 8.15 8.2 8.25 8.3 8.35 8.4 8.45 8.5 8.55 8.6 8.65 8.7 8.75 8.8 8.85 8.9 8.95 9 9.05 9.1 9.15 9.2 9.25 9.3 9.35 9.4 9.45 9.5 9.55 9.6 9.65 9.7 9.75 9.8 9.85 9.9 9.95 10 10.05 10.1 10.15 10.2 10.25 10.3 10.35 10.4 10.45 10.5 10.55 10.6 10.65 10.7 10.75 10.8 10.85 10.9 10.95 11 11.05 11.1 11.15 11.2 11.25 11.3 11.35 11.4 11.45 11.5 11.55 11.6 11.65 11.7 11.75 11.8 11.85 11.9 11.95 12 12.05 12.1 12.15 12.2 12.25 12.3 12.35 12.4 12.45 12.5 12.55 12.6 12.65 12.7 12.75 12.8 12.85 12.9 12.95 13 13.05 13.1 13.15 13.2 13.25 13.3 13.35 13.4 13.45 13.5 13.55 13.6 13.65 13.7 13.75 13.8 13.85 13.9 13.95 14 14.05 14.1 14.15 14.2 14.25 14.3 14.35 14.4 14.45 14.5 14.55 14.6 14.65 14.7 14.75 14.8 14.85 14.9 14.95 15 15.05 15.1 15.15 15.2 15.25 15.3 15.35 15.4 15.45 15.5 15.55 15.6 15.65 15.7 15.75 15.8 15.85 15.9 15.95 16];
all_options.usermodule.mellin.ssi=0;
all_options.usermodule.mellin.log=0;
all_options.usermodule.mellin.lowest_frequency=100;
all_options.usermodule.mellin.highest_frequency=6000;




%%%%%%%%%%%%%
% movies


%%%%%%%%%%%%%
% graphics

all_options.graphics.gtfb.is_log=0;
all_options.graphics.gtfb.time_reversed=0;
all_options.graphics.gtfb.plotstyle='mesh';
all_options.graphics.gtfb.colormap='cool';
all_options.graphics.gtfb.colorbar='off';
all_options.graphics.gtfb.camlight='left';
all_options.graphics.gtfb.lighting='phong';
all_options.graphics.hcl.is_log=0;
all_options.graphics.hcl.time_reversed=0;
all_options.graphics.hcl.plotstyle='mesh';
all_options.graphics.hcl.colormap='hot';
all_options.graphics.hcl.colorbar='off';

all_options.graphics.mellin.is_log=0;
all_options.graphics.mellin.time_profile_scale=100;

all_options.graphics.ti2003.minimum_time=0.001;
all_options.graphics.ti2003.maximum_time=0.035;
all_options.graphics.ti2003.is_log=1;
all_options.graphics.ti2003.time_reversed=1;
all_options.graphics.ti2003.display_time=0;
all_options.graphics.ti2003.time_profile_scale=1;
all_options.graphics.ti2003.plotstyle='mesh';
all_options.graphics.ti2003.colormap='summer';
all_options.graphics.ti2003.colorbar='off';
all_options.graphics.ti2003.viewpoint=[ 0 80];
all_options.graphics.ti2003.camlight=[ 50 0; 30 90];
all_options.graphics.ti2003.lighting='phong';
all_options.graphics.ti2003.shiftcolormap=0.8;
