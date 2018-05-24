% remove unnecessary data

% A08121B 138-6-FS (70dB) is fault! Use only A08121B 138-3-FS-CL (70dB).
% A08121B 138-6-FS as Fiber1: Remove RowIdx = 202, 244, 269, 302
% A08121B 138-6-FS as Fiber2: Remove RowIdx = 248, 249, 250

% A08121 22-3-FS and A08121 36-3-FS-cl have same CF! Use only A08121
% 22-3-FS as Fiber1 and A08121 36-3-FS-cl as Fiber2 (CD=0.039).
% Remove RowIdx = 28

% A08121 60-3-FS-CL and A08121 96-3-FS-CL have same CF! Use only A08121
% 60-3-FS-CL as Fiber1 and A08121 96-3-FS-CL as Fiber2 (CD=0.042).
% Remove RowIdx = 84

CFcombiselect8121=CFcombiselect8121([1:27 29:83 85:201 203:243 245:247 251:268 270:301 303:342]);%from N=342 to N=333

% A0898E 19-3-FS and A0898C 67-5-FS have same CF! Use only A0898E
% 19-3-FS as Fiber1 and A0898C 67-5-FS as Fiber2 (CD=0.054).
% Remove RowIdx = 15

CFcombiselect898=CFcombiselect898([1:14 16]);%from N=16 to N=15

% A0242 9-4-FS-CL and A0242 10-3-FS-CL have same CF! Use only A0242
% 9-4-FS-CL as Fiber1 and A0242 10-3-FS-CL as Fiber2 (CD=0.071).
% Remove RowIdx = 16

CFcombiselect242=CFcombiselect242([1:15 17:142]);%from N=142 to N=141


