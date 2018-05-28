function zz=uiload(ext);

if nargin<1, ext = 'mat'; end;

persistent DIR
if isempty(DIR),
   DIR = [pwd filesep];
end

[fn fp] = uigetfile([DIR '*.' ext]);

if isequal(fn,0), return; end % user cancelled
DIR = fp;
zz = load([fp fn],'-mat');

