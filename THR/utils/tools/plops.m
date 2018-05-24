function ps = plops(N, linestyle)
%plops -return plot-structure in fixed-order, cyclic
%
% ps = PLOPS(ii), uses PLOCO(ii) & PLOMA(ii) to generate a struct ps that
% can be passed to PLOT to specify linestyle, color & marker.
%
% PLOPS(N) returns the Nth plot struct. PLOPS(N+60)=PLOPS(N).
%
% By default, the used linestyle is '-'. To overwrite, give a second
% input argument (string) that is directly used as 'linestyle'-setting.
%
% Syntax examples:
%
% ps = plops(3);
% ps = plops(7, ':');       %dotted line
% ps = plops(128, 'none');    %no line, just markers
% plot(1:10, rand(1,10), ps);
% plot(1:10, rand(1,10), plops(5)); %without intermediate variable
%
% See also ploco, ploma

%default linestyle = '-'
if nargin < 2 | isempty(linestyle), linestyle = '-'; end

color = ploco(N); %get color
marker = ploma(N); %get marker

%make the struct
ps = collectinstruct(color, marker, linestyle);







