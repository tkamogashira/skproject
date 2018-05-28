function getList = RecursiveGet(h, selection);

if nargin<1, h = gcf; end;
select = nargin>1;
set(0,'handlevis','on');
allh = [findobj(h)];
global GG
GG = allh(:).';
getList = GG;
if nargin<2, return; end;
Nh = length(allh);
getList = cell(1,Nh);
boring = {'FontName' 'Children' 'HandleVisibility' 'Clipping' ...
      'CData' 'CreateFcn' 'DeleteFcn' 'BusyAction' 'Max' 'Min'...
      'Extent'};
Nboring = length(boring);
for ii=1:Nh,
   header.MyIndex = ii;
   header.Handle = allh(ii);
   header.Tag = get(allh(ii),'tag');
   gL = get(allh(ii));
   qq=[];
   if select,
      for jj=1:length(selection),
         sl = selection{jj};
         if isfield(gL, sl),
            qq = setfield(qq, sl, getfield(gL, sl));
         end
      end
      gL = qq;
   end
   getList{ii} = combineStruct(header, gL);
   % for jj=1:Nboring,
   %    if isfield(getList{ii},boring{jj}),
   %       getList{ii} = rmfield(getList{ii}, boring{jj});
   %   end;
end
GG = zeros(1,Nh);
for ii=1:Nh,
   GG(ii)=(getList{ii}.Handle);
end;


