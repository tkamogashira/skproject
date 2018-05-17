% method of class @parameter
% 
% (c) 2003-2008, University of Cambridge
% Maintained by Tom Walters (tcw24@cam.ac.uk), written by Stefan Bleeck (stefan@bleeck.de)
% http://www.pdn.cam.ac.uk/cnbh/aim2006/tools/parameter
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
function param=setslidereditcontrol(param,text,slidereditcombi,inbox)
% defines the tooltio for that entry

if nargin<4
    inbox='all';
end

nr=getentrynumberbytext(param,text,inbox);
if nr>0
    param.entries{nr}.slidereditcombi=slidereditcombi;
end
    
