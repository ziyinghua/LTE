function[output,tail_bits]=rsc_encode(x,info_len)
m=3; k=4;
g=[1 0 1 1;1 1 0 1];
total_length=info_len+m;
output=zeros(1,info_len);
tail_bits=zeros(1,6);
state=zeros(1,3);
for i=1:total_length
    if i<=info_len
        temp=rem([x(i) state]*g(1,:)',2);
        output(i)=rem([temp state]*g(2,:)',2);
        state=[temp state(1,1:2)];
    else
        tail_bits(2*(i-info_len)-1)=rem(state*g(1,2:k)',2);
        tail_bits(2*(i-info_len))=rem(state*g(2,2:k)',2);
        state=[0 state(1,1:2)];
    end
end
end