function dispinfo(this,name)
%DISPINFO   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.


fmt2 = '%16s%15.8g%2s%15.8g%2s%15.8g%2s%15.8g%2s%25s\n';
if this.min~=realmax && this.max~=realmin,
    fprintf(fmt2,name,this.min,' ',this.max,'|',this.MinFxPtRange,' ',this.MaxFxPtRange, ...
        '|',ratio(this,'NOutOfRange'));  
else
    fprintf(fmt2,name,NaN,' ',NaN,'|',this.MinFxPtRange,' ',this.MaxFxPtRange, ...
        '|',ratio(this,'NOutOfRange'));  
end

% [EOF]
