function seg_pos = Gen_seg_spec( Nu, seg_len_first, seg_leng_last, seg_cnt)
% Gen_seg_spec 
%   specify the length of first and last segment and the count of segments
%   the function ensure the end point of the last segment equals to Nu
%

if nargin<3
    error('no sufficient parameters supplied');
    return;
end

if nargin<4
    seg_cnt = 16;
end

x = double(1:seg_cnt);
A = double(ones(3,3));
A(1,1) = sum(x.^2); A(1,2) = sum(x); A(1,3) = seg_cnt;
A(2,1) = 1;         A(2,2) = 1;      A(2,3) = 1;
A(3,1) = seg_cnt^2; A(3,2) = seg_cnt;A(3,3) = 1;
B(1,1) = Nu-1;
B(2,1) = seg_len_first;
B(3,1) = seg_leng_last;
%
p = inv(A)*B;
% plot(round(p(1)*x.^2+p(2)*x+p(3)),'ro')
seg_length = round(p(1)*x.^2+p(2)*x+p(3));

%% compensate the last segment for rounding loss
len_loss = Nu-1 - sum(seg_length);
seg_length(seg_cnt) = seg_length(seg_cnt) + len_loss;

%% output
seg_pos = [1, 1+cumsum(seg_length) ];
end

