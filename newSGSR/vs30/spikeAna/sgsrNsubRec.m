function N = sgsrNsubRec(DataFile,iSeq);
% SGSRNSUBREC - number of completed subsequences of SGSR sequence
%   SGSRNSUB(FN,I) returns the # completed subsequences of 
%   sequence # I of file FN
%   This need not be identical to the # subseqs specified by the user 
%   during the measurement; the seq may be interrupted. Use sgsrNsub
%   to obtain the number of specified, not necessarily completed subseqs.
%
%   See also sgsrNsub, getSGSRdata

qq = getSGSRdata(DataFile,iSeq);
N = qq.Header.NsubseqRecorded;

