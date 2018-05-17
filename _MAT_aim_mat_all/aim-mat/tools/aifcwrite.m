% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function ok=aifcwrite(x,fs,nbits,fname)

%	function ok=aiffwrite(x,fs,nbits,fname)
%	Write AIFF and AIFF-C file
%	This is a reduced version and does not fulfill the
%	AIFF-C standard.

%	Coded by Hideki Kawahara based on "Audio Interchange file format AIFF-C draft"
%		by Apple Computer inc. 8/26/91
%	14/Feb./1998

ok=1;
[nr,nc]=size(x);
if nc>nr
    ok=[];
	disp('Data must be a set of column vector.');
	return;
end;
nex=floor(log(fs)/log(2));
vv=fs/2^(nex+1)*2^(4*16);
nex2=nex+16383;

fid=fopen(fname,'w');
fwrite(fid,'FORM','char')
cksize=82+nr*nc*(nbits/8);
fwrite(fid,cksize,'int32');
fwrite(fid,'AIFC','char');

fwrite(fid,'FVER','char');
fwrite(fid,4,'int32');
fwrite(fid,2726318400,'uint32');

fwrite(fid,'COMM','char');
fwrite(fid,38,'int32');
fwrite(fid,nc,'int16');
fwrite(fid,nr,'int32');
fwrite(fid,nbits,'int16');
fwrite(fid,nex2,'uint16');
fwrite(fid,vv,'uint64');
fwrite(fid,'NONE','char');
fwrite(fid,14,'uint8');
fwrite(fid,'not compressed','char');
fwrite(fid,0,'char');

fwrite(fid,'SSND','char');
fwrite(fid,nr*nc*(nbits/8)+8,'int32');
fwrite(fid,0,'int32');
fwrite(fid,0,'int32');
y=x';
switch(nbits)
   case 8
       fwrite(fid,y(:),'int8');
   case 16
       fwrite(fid,y(:),'int16');
end;
fclose(fid);

