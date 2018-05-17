% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function edit(sig)
% opens the signal in CoolEdit (if installed)
name='temp_signal_in_edit';

filename=get_new_filename(name,'wav');

savewave(sig,filename);
try
    winopen(filename);
catch
    error('sorry, no wave editor installed');
end

