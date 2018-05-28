function IDFwriteStimcommon(fid, stimcntrl, noSkip)

% function = IDFwriteStimcntrl(fid, stimcntrl, noSkip);
% IDF file must be opened with
%      fid = fopen(fname, 'w', 'ieee-le')
% file position will be set to the beginning
% of a stimulus record unless noSkip

if nargin<1
    error('no file id specified');
end
if nargin<2
    error('no stimcntrl record specified');
end
if nargin<3
    noSkip=0;
end

% start writing of beginning of next block
if ~noSkip
    IDFfillToNextBlock(fid);
end

fwriteVAXD(fid, stimcntrl.complete,'uint8');
fwriteVAXD(fid, stimcntrl.stimtype,'int8');
fwriteVAXD(fid, stimcntrl.seqnum,'int16');
fwriteVAXD(fid, stimcntrl.max_subseq,'int16');
fwriteVAXD(fid, stimcntrl.contrachan,'uint8');
fwriteVAXD(fid, stimcntrl.activechan,'uint8');
fwriteVAXD(fid, stimcntrl.limitchan,'uint8');
fwriteVAXD(fid, stimcntrl.spllimitchan,'uint8');
fwriteVAXD(fid, stimcntrl.interval,'single');
fwriteVAXD(fid, stimcntrl.repcount,'int16');
fwriteVAXD(fid, stimcntrl.dsid,'uchar');
fwriteVAXD(fid, stimcntrl.spl_loops,'int16');
fwriteVAXD(fid, stimcntrl.DUR2delay,'single');
fwriteVAXD(fid, stimcntrl.today,'int16');
fwriteVAXD(fid, stimcntrl.tape_ctl.block,'int16');
