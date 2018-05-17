% generating function for 'aim-mat'
%function returnframes=gen_ti2003(nap,strobes,options)
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% time integration
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function returnframes=gen_grouped(nap,strobes,options)
% calculates the stablized image from the data given in options


if ~isfield(strobes,'grouped')
    error('does only work with strobes ''grouping''');
end
nr_sources=size(strobes.cross_strobes{1}.source_cross_channel_value,2);

% Aufteilen auf Quellen (nur über und unter Hälfte)
nr_chan=getnrchannels(nap);

% for ii=1:nr_sources
for ii=2:2
    for jj=1:nr_chan
        newstrobes{jj}.strobes=strobes.cross_strobes{jj}.strobe_times;
        newstrobes{jj}.strobe_vals=strobes.cross_strobes{jj}.strobe_vals;
        newstrobes{jj}.strobe_weights=strobes.cross_strobes{jj}.source_cross_channel_value(:,ii);
    end
    
    options.criterion='fixed_weights';
    options.start_time=0;
    options.maxdelay=0.035;
    options.buffer_memory_decay=0.03;
    options.frames_per_second=200;
    options.weight_threshold=0;
    options.do_normalize=1;
    options.do_adjust_weights=1;
    options.strobe_weight_alpha=0.5;
    options.delay_weight_change=0.5;
    options.mindelay=0.001;
    retfr=gen_ti2003(nap,newstrobes,options);
    
end
returnframes=retfr;
return


