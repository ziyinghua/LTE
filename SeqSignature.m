function [Signat, par] = SeqSignature(Seq, GroupNo)
% Signature of Sequence in Customer way

%% Seq = rand(1,1600)+j*randn(1,1600);

if nargin<2
    GroupNo=0;
end

seq = reshape(Seq, 1, []);

if isreal(seq)
    seqq = seq;
else
    seqq = [real(seq); imag(seq)];
end

seq = reshape(seqq, 1, []);

midx = find(seq<0);
mval = seq(midx);
seq(midx) = seq(midx) - min(mval);

midx = find(seq<1);
mval = seq(midx);
mval = round(8192*mval);
seq(midx) = mval;

midx = find(seq>1);
mval = seq(midx);
mval = round(1024*mval);
seq(midx) = mval;

N = ceil(log2(max(seq)+0.0)+0.5); %% convert logical to double if needed

if N<17
    seq = uint16(seq);
else
    seq = uint32(seq);
end


tmp = de2bi(seq, N);

intest = reshape(tmp, 1, []);
intest = circshift(intest, GroupNo);

[~,par] = Ite_CRC24A(intest);
Signat = dec2hex([8, 4, 2, 1]*reshape(par(end-23:end), 4, []))';

