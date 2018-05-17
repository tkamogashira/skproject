% method of class @
%	function writetofile(sig,name) 
%   INPUT VALUES:
%  		sig: signal to save
%		name: filename
%   RETURN VALUE:
%		none
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function writetofile(sig,name)
%usage: writetofile(sig,name)
%DRRSmith 28/05/02
%readsounddata=getdata(sig);
%fid=fopen(name,'wb');
%fwrite(fid,readsounddata,'int16');
%fclose(fid);

readsounddata=getdata(sig);
if (isunix==1)
   fid=fopen(name,'wb','b'); %bigendian
   fwrite(fid,readsounddata,'int16');
   fclose(fid);
else
   fid=fopen(name,'wb','l'); %littleendian
   fwrite(fid,readsounddata,'int16');
   fclose(fid);
end

% readsounddata=getdata(sig);
% fid=fopen(name,'wb',endian);
% fwrite(fid,readsounddata,'int16');
% fclose(fid);
