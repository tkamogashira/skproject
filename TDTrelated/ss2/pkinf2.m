function Rtn=pkinf2(pkfname)
%PKINF2 -- Get information about a "peak" file.
%Up-version of PKINF, adapted for the new peak format "FORMAT Pk0501 "
%For a give peak file, return a structure that contains following
%fields:
%FormatID: Format ID of the peak file
%RawFName: File from which the peaks were extracted.
%SRate: Sampling rate (Hz)
%NPts: Number of data points per peak waveform
%NChan: Number of recording channels
%NPk: Number of peaks per channel
%NScByts: Number of bytes for the scalar
%NDatByts: Number of bytes for data points
%by SF, 6/8/01 modified from PKINF
%Usage: Rtn=pkinf2(pkfname)

fidpk=fopen(pkfname,'rb');
if fidpk<0
   error(sprintf('Cannot Open %s',pkfname));
	fclose (fidpk);
end

%Initialize the output
Rtn=[];

%Check the file format
FormatID=char(fread(fidpk,[1 80],'char'));
if ~strcmpi(FormatID(1:14),'FORMAT Pk0501 ')
   fclose (fidpk);
   error('Improper format of the PK file!!');
end
%Input file name
rawfname=char(fread(fidpk,[1 80],'char'));
rawfname=deblank(rawfname);
%Sampling rate for the peak waveformas; 50kHz
srate=fread(fidpk,[1 1],'uint32'); 
%Number of points per peak wavelet
npts=fread(fidpk,[1 1],'uint32');
%Number of channels
nch=fread(fidpk,[1 1],'uint16');
%Number of peaks per channel
npk=fread(fidpk,[1 nch],'uint32');
%Number of bytes for a scalar
nbytscl=fread(fidpk,[1 1],'uint16');
%Number of bytes for a data point
nbytdat=fread(fidpk,[1 1],'int16');

%check if the file size is consistent with the above numbers
OnePk=4+4+abs(nbytscl)+npts*abs(nbytdat);
cof=ftell(fidpk);
fseek(fidpk,0,'eof');
eof=ftell(fidpk);
mynpk=(eof-cof)/OnePk;

fclose(fidpk);
if mynpk~=floor(mynpk)
   error(sprintf('Problem in file size of %s',pkfname));
elseif mynpk ~= sum(npk)
   error(sprintf('Inconsistent # of peaks in %s',pkfname));
end

%Format the data for the output
Rtn.FormatID=FormatID;
Rtn.RawFName=rawfname;
Rtn.SRate=srate;
Rtn.NPts=npts;
Rtn.NChan=nch;
Rtn.NPk=npk;
Rtn.NScByts=nbytscl;
Rtn.NDatByts=nbytdat;
