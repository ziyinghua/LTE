function out= scramblefun(pusch_coding_bit,vrb_num,qm,subframeno,ue_index,cellid)
bit_len=vrb_num*12*12*qm;
cinit=ue_index*(2^14)+subframeno*512+cellid;

NC=1600;
x1=[1,zeros(1,30)];


for (i=1:31)
    x2(i)=mod(cinit,2);
    cinit=floor(cinit/2);
end

lenx=NC+bit_len-31;

for(i=1:lenx)
    x1(i+31)=xor(x1(i+3),x1(i));
    temp=x2(i+3)+x2(i+1)+x2(i);
    x2(i+31)=mod(temp,2);
end

for (i=1:bit_len)
    temp=x1(i+NC)+x2(i+NC);
    scrambit(i)=mod(temp,2);
end

for (k=1:bit_len)
    out(k)=double(xor(scrambit(k),pusch_coding_bit(k)));
end

end



