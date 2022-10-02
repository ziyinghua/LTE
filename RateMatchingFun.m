function [rm_data,rm_len] = RateMatchingFun(coded_data,Channel_type, Nir, C, Cm,direction, module_type, RVidx, Nl, G,Km,Kp)
rm_data=zeros(C,1);
rm_len=zeros(1,C);
for k=1:C
    if(k<=Cm)
        info_len=Km;
    else
        info_len=Kp;
    end
    [temp_data,temp_len] = RateMatching(coded_data(3*(k-1)+1:3*k,1:info_len+4), ...
    Channel_type, Nir, C,direction, module_type, RVidx, Nl, G,k-1);
    rm_len(k)=temp_len;
    rm_data(k,1:rm_len(k))=temp_data;
end
end

