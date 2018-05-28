function xbyte = ByteRep(x);

x = x(:);

xbyte = floor(x/2^24);
x = x - xbyte*2^24;
xbyte = [xbyte floor(x/2^16)] ;
x = x - xbyte(:,2)*2^16;
xbyte = [xbyte floor(x/2^8)] ;
x = x - xbyte(:,3)*2^8;
xbyte = [xbyte x] ;

