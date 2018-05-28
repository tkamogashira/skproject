function chans = allChanNums(ch)
% allChanNums - all active DA channels as row vector
%    allChanNums(ch) returns [1 2], 1, 2 or [] for
%    ch = 0|1|2|3 respectively.
%    The variable ch may also be specified as B|L|R|N or
%    as a DAchan-type parameter.
%
%    See also DAchanNaming.

qq = {[1 2] 1 2 []};

switch class(ch),
case 'double', iq = ch+1;
case 'char',
   ch = upper(ch(1));
   iq = strmatch(ch, {'B' 'L' 'R' 'N'});
case 'parameter',
   iq = 1 + ch.as_chanNum;
otherwise,
   error(['Invalid class '' class(ch) '' of ch.']);
end

chans = qq{iq};


