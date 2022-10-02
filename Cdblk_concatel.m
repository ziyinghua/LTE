function output = Cdblk_concatel(C,Info_data,data_len)

k=0;
for i=1:C
    len=data_len(i);
    output(k+1:k+len)=Info_data(i,1:len);
    k=k+len;

end

