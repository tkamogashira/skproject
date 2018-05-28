function header = IDFcreateHeader(Nseq)

% function header = IDFcreateHeader(Nseq);
% default Nseq is zero.

if nargin<1
    Nseq=0;
end

global SGSR;
vs = SGSR.IDF_SPKversion;

% fill header struct
header.recent_version   = [0 1];
header.current_version  =  vs;
header.num_seqs         =  Nseq;
