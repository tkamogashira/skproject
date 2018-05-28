function Mess=TestNsam(W);
% Waveform/TestNsam - test integrity of sample counts
%   TestNsam(W) compares the #samples to be played against the predicted
%   count predicted from the # reps and buffer lengths. If they are 
%   inconsistent, an appropriate error message is returned, else ''.
%
%   See also Waveform/NsamPlay.

Mess = '';
NW = numel(W);
for ii=1:NW,
    w = W(ii);
    N = w.NsamPlay;
    Ns = cellfun(@numel,w.Samples); 
    Npred = sum(Ns.*w.Nrep);
    if ~isequal(N,Npred),
        size(W)
        [i1 i2] = ind2sub(size(W), ii);
        Mess = ['Sample count inconsistency in element [' num2str([i1 i2]) '] of Waveform.' ];
        break;
    end
end

