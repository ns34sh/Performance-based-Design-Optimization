function [Bdec,Ddec,noR3dec,noR2dec,no2ddec,no3ddec] = coldec(x)
%Function to calculate reduction in column width
switch x
    case 1
        Bdec=0;
        Ddec=0;
        noR3dec=0;
        noR2dec=0;
        no2ddec=0;
        no3ddec=0;
    case 2
        Bdec=75;
        Ddec=0;
        noR3dec=0;
        noR2dec=0;
        no2ddec=0;
        no3ddec=0;
    case 3
        Bdec=0;
        Ddec=75;
        noR3dec=0;
        noR2dec=0;
        no2ddec=0;
        no3ddec=0;
    case 4
        Bdec=75;
        Ddec=75;
        noR3dec=0;
        noR2dec=0;
        no2ddec=0;
        no3ddec=0;        
    case 5
        Bdec=150;
        Ddec=0;
        noR3dec=0;
        noR2dec=0;
        no2ddec=0;
        no3ddec=0;        
    case 6
        Bdec=0;
        Ddec=150;
        noR3dec=0;
        noR2dec=0;
        no2ddec=0;
        no3ddec=0;        
    case 7
        Bdec=150;
        Ddec=150;   
        noR3dec=0;
        noR2dec=0;
        no2ddec=0;
        no3ddec=0;        
end

