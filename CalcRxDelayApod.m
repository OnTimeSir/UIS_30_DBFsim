function [delay,apod] = CalcRxDelayApod( probe_type, v30, span_pos, midchn, wtype, steera)
if nargin<5
    error(' Insufficient parameters');
else  
    if nargin<6
        steera = 0;
    end
    if nargin<5
        wtype = 0;
    end
end

sina = sin(steera*pi/180);
cosa = cos(steera*pi/180);
SegCnt = size(span_pos,2);
apod = zeros(v30.CHNUM,SegCnt,'uint8');
delay = zeros(v30.CHNUM,SegCnt,'single');
for iSeg = 1:SegCnt
    f = span_pos(iSeg)*4;
 % apodization
    aper_ch = span_pos(iSeg)/v30.Fnum/v30.ch2sysclk;
    ch1=fix(midchn-aper_ch/2);
    if ch1<0
        ch1 = 0;
    end
    ch2=fix(midchn+aper_ch/2+0.5);
    if ch2>v30.CHNUM-1
        ch2 = v30.CHNUM-1;
    end
    
    n1 = ch1+1;
    n2 = ch2+1;
    win = zeros(v30.CHNUM,1);
    exlen = 0;
	wlen = n2-n1+1;
	dSum = 0;
    for i=n1:n2
        switch wtype
            case 0		% HANNING
                win(i) = 0.5 - 0.5*cos(2*pi*(i-n1+exlen)/(wlen-1));
            case 1		%HAMMING
                win(i) = 0.54 - 0.46*cos(2*pi*(i-n1+exlen)/(wlen-1));
            case 2		% BLACKMAN
                win(i) = 0.42 - 0.5*cos(2*pi*(i-n1+exlen)/(wlen-1)) + 0.08*cos(4*pi*(i-n1+exlen)/(wlen-1));
            case 3   	% EXPONENT
                win(i) = exp(-(i-n1+exlen-wlen/2+0.5)*(i-n1+exlen-wlen/2+0.5)/wlen/wlen*4);
            case 4		%RECTANGLE
                win(i) = 0.5;
        end
		dSum = dSum+win(i);
    end
    for i=1:v30.CHNUM
        apod(i,iSeg) = fix(63*win(i)+0.5);
    end
%rxdelay  
    for i=n1:n2   
        ch = i-1;
         switch lower(probe_type)
            case {'linear','phase'}  
                dx = (ch-midchn)*v30.ch2rxclk;
                delay(i,iSeg) = -sqrt(dx*dx + f*f + 2*sina*f*dx) + f; 
                
            case {'convex'}
%                 theta = (ch-midchn)*v30.ch2rxclk/v30.R0;
%                 ax = atan(sina*f*(f*cosa+v30.R0).^(-1));
%                 r = (v30.R0+f*cosa).*(cos(ax)).^(-1);    
%                 delay = -sqrt(r.*r + v30.R0*v30.R0 - 2*cos(theta-ax).*r*v30.R0) + f;
         end
    end
    if n1>1
        delay(1:n1-1,iSeg) = delay(n1,iSeg);
    end
    if n2<v30.CHNUM
        delay(n2+1:v30.CHNUM,iSeg) = delay(n2,iSeg);  
    end
end
