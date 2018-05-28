function y=listtooltip;
% ListToolTip - list tooltips of all subunits saved in construction directory
global VERSIONDIR
cdir = [VERSIONDIR '\stimmenu\construction'];
ubs = ls([cdir '\*.mat']);
Nf = size(ubs,1); % # .mat files
for ii=1:Nf,
   fn = ubs(ii,:); fn(fn==' ') ='';
   disp(['----------file: ' fn '------------']);
   qq=load(which(fn));
   Nu = length(qq.uigroup);
   for uu=1:Nu,
      tag = qq.tags{uu};
      uig = qq.uigroup{uu};
      if isfield(uig,'TooltipString'),
         tt = uig.TooltipString;
         if ~isempty(tt),
            disp(['  ' tag ': ' tt ]);
         end
      end
   end
end


%ubs{:}
