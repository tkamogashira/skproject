% support file for 'aim-mat'
%
% This file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function res=generate_clicktrain_normal
% generate the "standart clicktrain response, that is subtracted from
% the sai
% generate a clicktrain, send it through an aim-model and average the
% clicktrain response from 50-200 ms. Save the result in a file called
% "click_frame"


clear all_options
ct=clicktrain(0.2,25000,25); 	% the clicktrain is below the width of the image

% generate the model parameters:

%%%%%%%%%%%%%
% Signaloptions
all_options.signal.signal_filename='temp.wav';
all_options.signal.start_time=0;
all_options.signal.duration=0.5;
all_options.signal.samplerate=getsr(ct);

%%%%%%%%%%%%%
% outer/middle ear filter function
all_options.pcp.none.generatingfunction='gennopcp';
all_options.pcp.none.displayname='no correction by outer/middle ear';
all_options.pcp.none.revision='$Revision: 585 $';


%%%%%%%%%%%%%
% bmm
all_options.bmm.gtfb.generatingfunction='gen_gtfb';
all_options.bmm.gtfb.displayname='Gamma tone filter bank';
all_options.bmm.gtfb.revision='$Revision: 585 $';
all_options.bmm.gtfb.nr_channels=50;
all_options.bmm.gtfb.lowest_frequency=100;
all_options.bmm.gtfb.highest_frequency=6400;
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
all_options.sai.ti2003.displayname='time integration stabilized auditory image';
all_options.sai.ti2003.revision='$Revision: 585 $';
all_options.sai.ti2003.criterion='change_weights';
all_options.sai.ti2003.start_time=0;
all_options.sai.ti2003.maxdelay=0.035;
all_options.sai.ti2003.buffer_memory_decay=0.03;
all_options.sai.ti2003.frames_per_second=300;
all_options.sai.ti2003.weight_threshold=0;
all_options.sai.ti2003.do_normalize=1;
all_options.sai.ti2003.do_times_nap_height=0;
all_options.sai.ti2003.do_adjust_weights=1;
all_options.sai.ti2003.strobe_weight_alpha=0.5;
all_options.sai.ti2003.delay_weight_change=0.5;
all_options.sai.ti2003.erb_frequency_integration=0;



% set the signal to the appropriate one
savewave(ct,'temp.wav');



res=aim(all_options);

resu=res.result;
len=length(resu);
click_frame=resu{1}; % its an empty one anyhow
for i=10:len
	fr=resu{i}/1000;
	click_frame=click_frame+fr;	
end

save click_frame click_frame


res=click_frame;
