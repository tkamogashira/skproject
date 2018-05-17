% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
% mystraight
% transforms it with two parameters: scale and fotrans

function sigret=straight(sig,f0trans,freqscale,timescale)

mystraight('set_grafix',0);
mystraight('initialize');
mystraight('initializeparams');
mystraight('setwavedata',sig);
mystraight('source',sig);
mystraight('bandcorrbtn');
mystraight('bypassbtn');

scales(1)=f0trans;
scales(2)=freqscale;
scales(3)=timescale;

mystraight('set_scales',scales);
sigret=mystraight('synthesizegraded');








