clear
% close all
clc

probe_type = 'linear'; %'linear', 'phase','convex'
v30 = FuncSysParameters(probe_type);
midchn = (v30.CHNUM-1)*0.5 + 0.25;  % 0:+0.25; 1:-0.25;
% midchn(2) = (v30.CHNUM-1)*0.5 - 0.25;  % 0:+0.25; 1:-0.25;
steera = 0;
wtype = 4;
offset_64clk = 250;
rxf_calc_scale = 15;
%% point by point in 256MHz clk
rxf_pos = 1:v30.Nu;
x = ((0:v30.CHNUM-1)-midchn)*v30.pitchsz;
x = x/v30.c*v30.Fs;
rxf_delay(:,:) = CalcDelay(probe_type, x, rxf_pos*4,0);
% rxf_delay = rxf_delay-min(rxf_delay(:));
rxf_delay = rxf_delay+offset_64clk*4;
%% piecewise-linear approsimation 
load seg_spec_linear.mat
SegCnt = size(span_pos,2);
%float calculation at segment point
[rxf_delay_seg,rxf_apod_seg] = CalcRxDelayApod( probe_type, v30, span_pos, midchn, wtype, steera);
rxf_delay_pla = zeros(v30.CHNUM,v30.Nu,'single');
max_rx_delay_clk = single(511*4); %256MHz
%-------segment 0, initial segment------%
iSeg = 1;
scale = bitshift(1,span_scale_bitcount(iSeg));
PrevSegDelay = rxf_delay_seg(:,iSeg) + offset_64clk*4;
PrevSegDelay(PrevSegDelay>max_rx_delay_clk) = max_rx_delay_clk;
bitDelay = int32(fix(PrevSegDelay.*scale+0.5));
tmp = bitshift(bitDelay,rxf_calc_scale-span_scale_bitcount(iSeg));
rxf_delay_pla(:,1) = floor(bit2float(tmp, rxf_calc_scale));
tmp2 = tmp;
PrevSegDelay = bit2float(tmp2, rxf_calc_scale);
%-------segment 2-127------%
for iSeg = 2:SegCnt
    len = 2*(span_pos(iSeg)-span_pos(iSeg-1));
    scale = bitshift(1,span_scale_bitcount(iSeg));
    delay_clk = rxf_delay_seg(:,iSeg) + offset_64clk*4;
    delay_clk(delay_clk>max_rx_delay_clk) = max_rx_delay_clk;
    slope = int32(fix((delay_clk-PrevSegDelay)/len*scale+0.5));
    slope_sign = sign(slope);
    slope = abs(slope);
    for i=span_pos(iSeg-1)+1:span_pos(iSeg)
        tmp = tmp + slope_sign.*bitshift(slope,rxf_calc_scale-span_scale_bitcount(iSeg))*2;
        rxf_delay_pla(:,i) = floor(bit2float(tmp, rxf_calc_scale));
    end
    tmp2 = tmp2 + slope_sign.*bitshift(slope,rxf_calc_scale-span_scale_bitcount(iSeg))*len;
%     figure(1);stem(tmp);pause(0.1)
    PrevSegDelay = bit2float(tmp2, rxf_calc_scale); 
end
%% check error
error = zeros(v30.CHNUM,v30.Nu);
for iSeg = 1:SegCnt-1
    for i=1:v30.CHNUM
        if rxf_apod_seg(i,iSeg)~=0
            error(i,span_pos(iSeg):span_pos(iSeg+1)-1) = rxf_delay_pla(i,span_pos(iSeg):span_pos(iSeg+1)-1) - rxf_delay(i,span_pos(iSeg):span_pos(iSeg+1)-1);
        end
    end
end
