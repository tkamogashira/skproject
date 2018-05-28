function N = sgsrNsub(DataFile,iSeq);
% SGSRNSUB - number of subsequences of SGSR sequence
%   SGSRNSUB(FN,I) returns the # subsequences of sequence # I of file FN
%   as specified by the user during the measurement.  
%   This need not be identical to the # subseqs measured; the
%   seq may be interrupted. Use sgsrNsubRec to obtain the
%   number of completed subseqs.
%
%   See also sgsrNsubRec, getSGSRdata

qq = getSGSRdata(DataFile,iSeq);
N = qq.Header.Nsubseq;

