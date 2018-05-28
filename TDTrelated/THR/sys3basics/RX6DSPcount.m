function [CT, mess] = RX6DSPcount(CT);
% RX6DSPcount - get/set type number of DSPs of RX6 device
%    RX6DSPcount returns the number of DSPs in the RX6 connected to this
%    setup.
%
%    RX6DSPcount(N) sets it to n. N may be 2 or 5.
%
%    See also sys3setup.

if nargin<1, % get
    mess = '';
    ERR = 'No DSP count was specified for this setup.';
    try,
        CT = myflag('RX6DSPcount');
        if isempty(CT), 
            CT = sys3setup('DSPcount_RX6'); 
            myflag('RX6DSPcount', CT); % store for fast retrieval
        end
    catch,
        if nargout<2, % throw error
            error(ERR);
        else, % suppress error but return errer mess
            CT = '';
            mess = ERR;
        end
    end
else, % set
    if ~isequal(2, CT) && ~isequal(5, CT),
        error('RX6 DSP count must be 2 or 5.');
    end
    sys3setup('DSPcount_RX6', CT);
    myflag('RX6DSPcount', CT);
end




