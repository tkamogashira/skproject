number=size(data,1);
for n=1:number
    fiber(n).id=char(textdata(n+1,1));
    fiber(n).side=char(textdata(n+1,2));
    fiber(n).cf=str2num(char(textdata(n+1,3)));
    fiber(n).cutting=str2num(char(textdata(n+1,4)));
    fiber(n).section=str2num(char(textdata(n+1,5)));
    fiber(n).zsc=str2num(char(textdata(n+1,6)));
    
    fiber(n).kind=char(textdata(n+1,7));
    fiber(n).tree=char(textdata(n+1,8));
    fiber(n).termination=char(textdata(n+1,9));
    fiber(n).branchorder=char(textdata(n+1,10));
    fiber(n).distance=str2num(char(textdata(n+1,11)));
    fiber(n).pre_x=char(textdata(n+1,12));
    
    fiber(n).x=data(n,1);
    fiber(n).y=data(n,2);
    fiber(n).z=data(n,3);
    fiber(n).noncorrected_z=data(n,4);
    fiber(n).sectiontop_z=data(n,5);
    
    fiber(n).dp_x=data(n,6);
    fiber(n).dp_y=data(n,7);
    fiber(n).dp_z=data(n,8);
    fiber(n).noncorrected_dp_z=data(n,9);
    fiber(n).vp_x=data(n,10);
    fiber(n).vp_y=data(n,11);
    fiber(n).vp_z=data(n,12);
    fiber(n).noncorrected_vp_z=data(n,13);
    fiber(n).ep_minus_vp=data(n,14);
    fiber(n).dp_minus_vp=data(n,15);
    fiber(n).ep_minus_vp_on_dp_minus_vp=data(n,16);
    
    fiber(n).fb_distance=data(n,17);
    fiber(n).fb_x=data(n,18);
    fiber(n).fb_y=data(n,19);
    fiber(n).fb_z=data(n,20);
    
    fiber(n).rp_x=data(n,21);
    fiber(n).rp_y=data(n,22);
    fiber(n).rp_z=data(n,23);
    
    fiber(n).cp_x=data(n,24);
    fiber(n).cp_y=data(n,25);
    fiber(n).cp_z=data(n,26);
    
    fiber(n).square_ep_minus_rp=data(n,25);
    fiber(n).cp_minus_rp=data(n,26);
    fiber(n).ep_minus_rp_on_cp_minus_rp=data(n,27);
    
    fiber(n).al_from_ml=data(n,32);
    fiber(n).al_from_fb=data(n,33);
end;
    
    
    
    
    
    
    
    