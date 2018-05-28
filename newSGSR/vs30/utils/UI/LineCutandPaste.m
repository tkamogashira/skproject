function y=LineCopyandPaste(kw, varargin);
% LineCutandPaste - cut and paste lines of figures
persistent CutLine
switch lower(kw),
case 'copy',
   LL = get(gcbf,'currentObject');
   if isequal('line', get(LL,'Type')),
      CutLine = rmfield(get(LL), {'Parent', 'BeingDeleted' 'Type' 'UIContextMenu'});
   end
case 'delete',
   LL = get(gcbf,'currentObject');
   if isequal('line', get(LL,'Type')),
      delete(LL);
   end
case 'enable',
   % make figure printfahig
   set(gcf,'ResizeFcn',''); set(gcf,'menubar','none'); set(gcf,'menubar','figure')
   % enable copying of lines
   lili = findobj(gcbf, 'type', 'line');
   for li=lili(:)',
      ggcmenu('copy line', 'LineCutandPaste copy', li);
      uu = ggcmenu('delete line', 'LineCutandPaste delete', li); 
      set(uu, 'Separator', 'on')
   end
   % enable pasting of lines to axes
   axax = findobj(gcbf, 'type', 'axes');
   for ax=axax(:)',
      ggcmenu('edit copied line', 'LineCutandPaste edit', ax); 
      uu = ggcmenu('paste line as is', 'LineCutandPaste paste', ax); 
      set(uu, 'Separator', 'on')
      uu = ggcmenu('paste line red', 'LineCutandPaste paste', ax); 
      set(uu,'userdata',[1 0 0]);
      uu = ggcmenu('paste line green', 'LineCutandPaste paste', ax); 
      set(uu,'userdata',[0 1 0]);
      uu = ggcmenu('paste line blue', 'LineCutandPaste paste', ax); 
      set(uu,'userdata',[0 0 1]);
      uu = ggcmenu('paste line magenta', 'LineCutandPaste paste', ax); 
      set(uu,'userdata',[1 0 1]);
      uu = ggcmenu('paste line black', 'LineCutandPaste paste', ax); 
      set(uu,'userdata',[0 0 0]);
      uu = ggcmenu('paste line cyan', 'LineCutandPaste paste', ax); 
      set(uu,'userdata',[0 1 1]);
   end
case 'paste',
   LL = get(gcbf,'currentObject');
   if isequal('axes', get(LL,'Type')),
      axes(LL); 
      if ~isempty(CutLine), 
         hh=line(CutLine); 
         Col = get(gcbo, 'userdata');
         if ~isempty(Col), 
            set(hh,'color', Col); 
            set(hh,'MarkerEdgeColor', Col);
            MFC = get(hh,'MarkerFaceColor');
            if ~isequal([1 1 1], MFC), set(hh,'MarkerFaceColor', Col); end
         end;
      end;
   end
case 'edit',
   CutLine
   while 1,
      CMD = input('LL>> ', 's');
      if isempty(CMD), return; end;
      CMD = strsubst(CMD, 'LL', 'CutLine');
      CMD
      eval(CMD, 'lasterr');
   end
case 'empty',
   CutLine = [];
case 'get',
   y = CutLine;
case 'init',
   ggcmenu('enable line editing', 'LineCutandPaste enable');
otherwise, error(['unknown keyword "' kw '"']);
end

