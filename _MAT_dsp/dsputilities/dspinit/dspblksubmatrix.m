function varargout = dspblksubmatrix(action)
% DSPBLKSUBMATRIX DSP System Toolbox Submatrix block helper function.

% Copyright 1995-2005 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end

blk = gcbh;

switch action
case 'icon'
   % S=8; t=(0:S)'/S*2*pi; a=0.05;
   % x=a*cos(t);y=a*sin(t);
   % The values for x and y obtained by this are:
   x = [0.05 0.035355 0    -0.035355 -0.05 -0.035355  0     0.035355 0.05]';
   y = [0    0.035355 0.05  0.035355  0    -0.035355 -0.05 -0.035355 0   ]';

   xsize = size(x);
   xc=x*ones(1,9) + ones(xsize)*[.3  .3 .3  .5  .5 .5  .7  .7 .7 ];
   yc=y*ones(1,9) + ones(xsize)*[.25 .5 .75 .25 .5 .75 .25 .5 .75];

   xi=[.4   .8   .8   .4   .4  ];
   yi=[.375 .375 .875 .875 .375];

   x1=[.2 .1 .1 .2 NaN .825 .925 .925 .825];
   y1=[.9 .9 .1 .1 NaN .9   .9   .1   .1  ];

   varargout = {x1,y1,xc,yc,xi,yi};

case 'dynamic'
   %  1 - Row span: RowSpan (All, One, Range)
   %  2 - Starting row: RowStartMode (First, Index, Offset from last,
   %                    Last, Offset from middle, Middle)
   %  3 - Starting row index: RowStartIndex (numeric)
   %  4 - Ending row: RowEndMode (Index, Offset from last,
   %                  Last, Offset from middle, Middle)
   %  5 - Ending row index: RowEndIndex (numeric)
   %
   %  6 - Column span: ColSpan (All, One, Range)
   %  7 - Starting column: ColStartMode (First, Index, Offset from last,
   %                       Last, Offset from middle, Middle)
   %  8 - Starting column index: ColStartIndex (numeric)
   %  9 - Ending column: ColEndMode (Index, Offset from last, Last,
   %                     Offset from middle, Middle)
   % 10 - Ending column index: ColEndIndex (numeric)
   %

   [ROW_SPAN, ROW_START_MODE, ROW_START_INDEX, ROW_END_MODE, ROW_END_INDEX] ...
       = deal(1, 2, 3, 4, 5);

   [COL_SPAN, COL_START_MODE, COL_START_INDEX, COL_END_MODE, COL_END_INDEX] ...
       = deal(6, 7, 8, 9, 10);

   this = get_param(blk,'object');
   valueOnDialog = this.MaskValues;

   orig_mask_vis = this.MaskVisibilities;
   vis = orig_mask_vis;

   % Dialog entries with callbacks:
   %  ROW_SPAN, ROW_START_MODE, ROW_END_MODE,
   %  COL_SPAN, COL_START_MODE, COL_END_MODE

   % Rows
   %
   switch valueOnDialog{ROW_SPAN}
    case 'All rows'
     vis{ROW_START_MODE} = 'off';
     vis{ROW_END_MODE}   = 'off';
    case 'One row'
     vis{ROW_START_MODE} = 'on';
     vis{ROW_END_MODE}   = 'off';
     this.MaskPrompts{ROW_START_MODE} = 'Row:             ';
    case 'Range of rows'
     vis{ROW_START_MODE} = 'on';
     vis{ROW_END_MODE}   = 'on';
     this.MaskPrompts{ROW_START_MODE} = 'Starting row:';
   end
   if strcmp(vis{ROW_START_MODE},'on')
     switch valueOnDialog{ROW_START_MODE}
      case {'First', 'Middle'}
       vis{ROW_START_INDEX} = 'off';
      case 'Last'
       vis{ROW_START_INDEX} = 'off';
       vis{ROW_END_MODE}    = 'off';
      case 'Index'
       vis{ROW_START_INDEX} = 'on';
       if strcmp(valueOnDialog{ROW_SPAN}, 'One row')
         this.MaskPrompts{ROW_START_INDEX} = 'Row index:';
       else
         this.MaskPrompts{ROW_START_INDEX} = 'Starting row index:';
       end
      case {'Offset from last', 'Offset from middle'}
       vis{ROW_START_INDEX} = 'on';
       if strcmp(valueOnDialog{ROW_SPAN}, 'One row')
         this.MaskPrompts{ROW_START_INDEX} = 'Row offset:';
       else
         this.MaskPrompts{ROW_START_INDEX} = 'Starting row offset:';
       end
     end
   else
     vis{ROW_START_INDEX} = 'off';
   end
   if strcmp(vis{ROW_END_MODE},'on')
     switch valueOnDialog{ROW_END_MODE}
      case {'Last', 'Middle'}
       vis{ROW_END_INDEX} = 'off';
      case 'Index'
       vis{ROW_END_INDEX} = 'on';
       this.MaskPrompts{ROW_END_INDEX} = 'Ending row index:';
      case {'Offset from last', 'Offset from middle'}
       vis{ROW_END_INDEX} = 'on';
       this.MaskPrompts{ROW_END_INDEX} = 'Ending row offset:';
     end
   else
     vis{ROW_END_INDEX} = 'off';
   end

   % Columns
   %
   switch valueOnDialog{COL_SPAN}
    case 'All columns'
     vis{COL_START_MODE} = 'off';
     vis{COL_END_MODE}   = 'off';
    case 'One column'
     vis{COL_START_MODE} = 'on';
     vis{COL_END_MODE}   = 'off';
     this.MaskPrompts{COL_START_MODE} = 'Column:             ';
    case 'Range of columns'
     vis{COL_START_MODE} = 'on';
     vis{COL_END_MODE}   = 'on';
     this.MaskPrompts{COL_START_MODE} = 'Starting column:';
   end
   if strcmp(vis{COL_START_MODE},'on')
     switch valueOnDialog{COL_START_MODE}
      case {'First', 'Middle'}
       vis{COL_START_INDEX} = 'off';
      case 'Last'
       vis{COL_START_INDEX} = 'off';
       vis{COL_END_MODE}    = 'off';
      case 'Index'
       vis{COL_START_INDEX} = 'on';
       if strcmp(valueOnDialog{COL_SPAN},'One column')
         this.MaskPrompts{COL_START_INDEX} = 'Column index:';
       else
         this.MaskPrompts{COL_START_INDEX} = 'Starting column index:';
       end
      case {'Offset from last', 'Offset from middle'}
       vis{COL_START_INDEX} = 'on';
       if strcmp(valueOnDialog{COL_SPAN},'One column')
         this.MaskPrompts{COL_START_INDEX} = 'Column offset:';
       else
         this.MaskPrompts{COL_START_INDEX} = 'Starting column offset:';
       end
     end
   else
     vis{COL_START_INDEX} = 'off';
   end
   if strcmp(vis{COL_END_MODE},'on')
     switch valueOnDialog{COL_END_MODE}
      case {'Last', 'Middle'}
       vis{COL_END_INDEX} = 'off';
      case 'Index'
       vis{COL_END_INDEX} = 'on';
       this.MaskPrompts{COL_END_INDEX} = 'Ending column index:';
      case {'Offset from last', 'Offset from middle'}
       vis{COL_END_INDEX} = 'on';
       this.MaskPrompts{COL_END_INDEX} = 'Ending column offset:';
     end
   else
     vis{COL_END_INDEX} = 'off';
   end

   if ~isequal(vis, orig_mask_vis),
     this.MaskVisibilities = vis;
     this.MaskEnables      = vis;
   end
   %% Keep mask visibilities and mask enables in sync:
   if ~isequal(this.MaskEnables,this.MaskVisibilities)
       this.MaskEnables = this.MaskVisibilities;
   end

end % end of switch statement
