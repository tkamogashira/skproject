function stimcntrl = IDFreadstimcommon(fid, noReset)

% function stimcntrl = IDFreadstimcntrl(fid, noReset);
% IDF file must be opened with
%      fid = fopen(idfname, 'r', 'ieee-le')
% and the file position must be at the beginning
% of a stimulus record unless noReset

if nargin<1
    error('no file id specified');
end
if nargin<2
    noReset=0;
end

% reset idf file
if ~noReset
	where = ftell(fid);
	if (where==-1)
	   mess = ferror;
	   error(ferror);
	elseif rem(where, 256) || ~where
	   error('file position not at the beginning of 256-byte record');
    end
end

   % ------STIMCOM----------
stimcntrl.complete=freadVAXD(fid,1,'uint8');
stimcntrl.stimtype=freadVAXD(fid,1,'int8');
stimcntrl.seqnum=freadVAXD(fid,1,'int16');
stimcntrl.max_subseq=freadVAXD(fid,1,'int16');
stimcntrl.contrachan=freadVAXD(fid,1,'uint8');
stimcntrl.activechan=freadVAXD(fid,1,'uint8');
stimcntrl.limitchan=freadVAXD(fid,1,'uint8');
stimcntrl.spllimitchan=freadVAXD(fid,1,'uint8');
stimcntrl.interval=freadVAXD(fid,1,'single');
stimcntrl.repcount=freadVAXD(fid,1,'int16');
stimcntrl.dsid=char(freadVAXD(fid,10,'uchar').');
stimcntrl.spl_loops=freadVAXD(fid,1,'int16');
stimcntrl.DUR2delay=freadVAXD(fid,2,'single').';
stimcntrl.today=freadVAXD(fid,6,'int16').';
stimcntrl.tape_ctl.block=freadVAXD(fid,8,'int16').';
