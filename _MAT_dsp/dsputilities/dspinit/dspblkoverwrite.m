function varargout = dspblkoverwrite(action)
% DSPBLKOVERWRITE DSP System Toolbox Overwrite Values block helper function.

% Copyright 1995-2005 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end

blk = gcbh;

switch action
 case 'icon'
   % S=8; t=(0:S)'/S*2*pi; a=0.05;
   % x=a*cos(t);y=a*sin(t);
   % The values for x and y obtained by this are:
   x1= [.27 .17 .17 .27 NaN .755 .855 .855 .755];
   y1= [.92 .92 .1  .1  NaN .92  .92  .1   .1  ];

   x = [0.05 0.035355 0    -0.035355 -0.05 -0.035355  0     0.035355 0.05]';
   y = [0    0.035355 0.05  0.035355  0    -0.035355 -0.05 -0.035355 0   ]';
   xsize = size(x);

   xm =[-0.05 -0.03 NaN  0.03  0.05 NaN -0.05 -0.03 NaN 0.03 0.05 NaN -0.04 0.04 NaN -0.04  0.04]';
   ym =[-0.05 -0.05 NaN -0.05 -0.05 NaN  0.05  0.05 NaN 0.05 0.05 NaN -0.05 0.05 NaN  0.05 -0.05]';
   xmsize = size(xm);

   if strcmp(get_param(blk,'OverWriteDiag'), 'Submatrix')
     xmc=xm*ones(1,4) + ones(xmsize)*[.5 .5  .7 .7 ];
     ymc=ym*ones(1,4) + ones(xmsize)*[.5 .75 .5 .75];

     xc=x*ones(1,5) + ones(xsize)*[.3  .3 .3  .5  .7 ];
     yc=y*ones(1,5) + ones(xsize)*[.25 .5 .75 .25 .25];

     xi=[.4   .8   .8   .4   .4  ];
     yi=[.375 .375 .875 .875 .375];

   else

     xmc=xm*ones(1,3) + ones(xmsize)*[.3  .5 .7 ];
     ymc=ym*ones(1,3) + ones(xmsize)*[.75 .5 .25];

     xc=x*ones(1,6) + ones(xsize)*[.3 .3  .5  .5  .7  .7];
     yc=y*ones(1,6) + ones(xsize)*[.5 .25 .75 .25 .75 .5];

     xi=[0.21  0.21  0.665 0.79  0.79 0.335 0.21 ];
     yi=[0.845 0.723 0.15  0.15  0.27 0.845 0.845];

   end
   varargout = {x1,y1,xc,yc,xmc,ymc,xi,yi};

 case 'dynamic'
   % 1  - 'Overwrite:'                      popup, OverWriteDiag, {'Submatrix', 'Diagonal'}
   % 2  - 'Source of overwriting value(s):' popup, valFrom2ndIP,  {'Specify via dialog', 'Second input port'}
   % 3  - 'Overwrite with:'                 edit,  ConstValue
   % 4  - 'Row span:'                       popup, RowSpan,       {'All rows', 'One row', 'Range of rows'}
   % 5  - 'Starting row:'                   popup, RowStartMode   {'First', 'Index', 'Offset from last', 'Last', 'Offset from middle', 'Middle'}
   % 6  - 'Starting row index:'             edit,  RowStartIndex
   % 7  - 'Ending row:'                     popup, RowEndMode     {'Index', 'Offset from last', 'Last', 'Offset from middle', 'Middle'}
   % 8  - 'Ending row index:'               edit,  RowEndIndex
   % 9  - 'Column span:'                    popup, ColSpan        {'All columns', 'One column', 'Range of columns'}
   % 10 - 'Starting column:'                popup, ColStartMode   {'First', 'Index', 'Offset from last', 'Last', 'Offset from middle', 'Middle'}
   % 11 - 'Starting column index:'          edit,  ColStartIndex
   % 12 - 'Ending column:'                  popup, ColEndMode     {'Index', 'Offset from last', 'Last', 'Offset from middle', 'Middle'}
   % 13 - 'Ending column index:'            edit,  ColEndIndex
   % 14 - 'Diagonal span:'                  popup, DiagSpan       {'All elements', 'One element', 'Range of elements'}
   % 15 - 'Starting element:'               popup, DiagStartMode  {'First', 'Index', 'Offset from last', 'Last', 'Offset from middle', 'Middle'}
   % 16 - 'Starting element index:'         edit,  DiagStartIndex
   % 17 - 'Ending element:'                 popup, DiagEndMode    {'Index', 'Offset from last', 'Last', 'Offset from middle', 'Middle'}
   % 18 - 'Ending element index:'           edit,  DiagEndIndex

   this = get_param(blk,'object');
   mv = this.MaskValues;

   orig_vis = this.MaskVisibilities;
   vis = orig_vis;

   if strcmp(this.valFrom2ndIP, 'Second input port')
     vis{3} = 'off';
   else
     vis{3} = 'on';
   end

   if strcmp(this.OverWriteDiag, 'Diagonal')
     %% Diagonal mode
     vis(4:13) = {'off'};
     vis{14} = 'on';

     diagSpan = mv{14};
     switch diagSpan
      case 'All elements'
       vis(15:18) = {'off'};

      case 'One element'
       vis{15} = 'on';
       this.MaskPrompts{15} = 'Element:             ';

       vis(17:18) = {'off'};

       diagStartMode = mv{15};
       switch diagStartMode
        case {'First','Last','Middle'}
         vis{16} = 'off';
        case 'Index'
         vis{16} = 'on';
         this.MaskPrompts{16} = 'Element index:';
        case {'Offset from last', 'Offset from middle'}
         vis{16} = 'on';
         this.MaskPrompts{16} = 'Element offset:';
       end

      case 'Range of elements'
       vis{15} = 'on';
       this.MaskPrompts{15} = 'Starting element:';

       diagStartMode = mv{15};
       switch diagStartMode
        case {'First','Middle'}
         vis{16} = 'off';
         vis{17} = 'on';
        case 'Last'
         vis(16:18) = {'off'};
        case 'Index'
         vis{16} = 'on';
         vis{17} = 'on';
         this.MaskPrompts{16} = 'Starting element index:';
        case {'Offset from last', 'Offset from middle'}
         vis{16} = 'on';
         vis{17} = 'on';
         this.MaskPrompts{16} = 'Starting element offset:';
       end

       if strcmp(vis{17},'on')
         diagEndMode = mv{17};
         switch diagEndMode
          case {'Last', 'Middle'}
           vis{18} = 'off';
          case 'Index'
           vis{18} = 'on';
           this.MaskPrompts{18} = 'Ending element index:';
          case {'Offset from last', 'Offset from middle'}
           vis{18} = 'on';
           this.MaskPrompts{18} = 'Ending element offset:';
         end
       end
     end

   else
     %% Submatrix mode
     vis(14:18) = {'off'};

     % Rows
     vis{4} = 'on';
     rowSpan = mv{4};
     switch rowSpan
      case 'All rows'
       vis(5:8) = {'off'};

      case 'One row'
       vis{5} = 'on';
       vis(7:8) = {'off'};
       this.MaskPrompts{5} = 'Row:             ';

       rowStartMode = mv{5};
       switch rowStartMode
        case {'First', 'Last', 'Middle'}
         vis{6} = 'off';
        case 'Index'
         vis{6} = 'on';
         this.MaskPrompts{6} = 'Row index:';
        case {'Offset from last', 'Offset from middle'}
         vis{6} = 'on';
         this.MaskPrompts{6} = 'Row offset:';
       end

      case 'Range of rows'
       vis{5} = 'on';
       this.MaskPrompts{5} = 'Starting row:';

       rowStartMode = mv{5};
       switch rowStartMode
        case {'First', 'Middle'}
         vis{6} = 'off';
         vis{7} = 'on';
        case 'Last'
         vis(6:8) = {'off'};
        case 'Index'
         vis{6} = 'on';
         vis{7} = 'on';
         this.MaskPrompts{6} = 'Starting row index:';
        case {'Offset from last', 'Offset from middle'}
         vis{6} = 'on';
         vis{7} = 'on';
         this.MaskPrompts{6} = 'Starting row offset:';
       end

       if strcmp(vis{7},'on')
         rowEndMode = mv{7};
         switch rowEndMode
          case {'Last', 'Middle'}
           vis{8} = 'off';
          case 'Index'
           vis{8} = 'on';
           this.MaskPrompts{8} = 'Ending row index:';
          case {'Offset from last', 'Offset from middle'}
           vis{8} = 'on';
           this.MaskPrompts{8} = 'Ending row offset:';
         end
       end
     end

     % Columns
     vis{9} = 'on';
     colSpan = mv{9};
     switch colSpan
      case 'All columns'
       vis(10:13) = {'off'};

      case 'One column'
       vis{10} = 'on';
       vis(12:13) = {'off'};
       this.MaskPrompts{10} = 'Column:             ';

       colStartMode = mv{10};
       switch colStartMode
        case {'First', 'Last', 'Middle'}
         vis{11} = 'off';
        case 'Index'
         vis{11} = 'on';
         this.MaskPrompts{11} = 'Column index:';
        case {'Offset from last', 'Offset from middle'}
         vis{11} = 'on';
         this.MaskPrompts{11} = 'Column offset:';
       end

      case 'Range of columns'
       vis{10} = 'on';
       this.MaskPrompts{10} = 'Starting column:';

       colStartMode = mv{10};
       switch colStartMode
        case {'First', 'Middle'}
         vis{11} = 'off';
         vis{12} = 'on';
        case 'Last'
         vis(11:13) = {'off'};
        case 'Index'
         vis{11} = 'on';
         vis{12} = 'on';
         this.MaskPrompts{11} = 'Starting column index:';
        case {'Offset from last', 'Offset from middle'}
         vis{11} = 'on';
         vis{12} = 'on';
         this.MaskPrompts{11} = 'Starting column offset:';
       end

       if strcmp(vis{12},'on')
         colEndMode = mv{12};
         switch colEndMode
          case {'Last', 'Middle'}
           vis{13} = 'off';
          case 'Index'
           vis{13} = 'on';
           this.MaskPrompts{13} = 'Ending column index:';
          case {'Offset from last', 'Offset from middle'}
           vis{13} = 'on';
           this.MaskPrompts{13} = 'Ending column offset:';
         end
       end
     end
   end

   if ~isequal(vis, orig_vis)
       this.MaskVisibilities = vis;
       this.MaskEnables = vis;
   end
   %% Keep mask visibilities and mask enables in sync:
   if ~isequal(this.MaskEnables,this.MaskVisibilities)
       this.MaskEnables = this.MaskVisibilities;
   end

end % end of switch statement
