function [output_data,out_len] = RateMatching(Info_data,Channel_type,Nir,C,direction,module_type,Rvidx,Nl,G,r)

%global OUPUT_FILE ; %output file name
%global PRINT_FLAG;  %0:not print result  1:output

%% 子块交织
if Channel_type==0
    temp1=Subblock_interleave_index(Info_data(1,:),0);
    temp2=Subblock_interleave_index(Info_data(2,:),0);
    temp3=Subblock_interleave_index(Info_data(3,:),1);
else
    temp1=Subblock_interleave_index(Info_data(1,:),2);
    temp2=Subblock_interleave_index(Info_data(2,:),2);
    temp3=Subblock_interleave_index(Info_data(3,:),2);
end

Kii=length(temp1);
Kw=3*Kii;

%% 比特收集
w=zeros(1,Kw);
w(1,1:Kii)=temp1;
if(Channel_type==0)
    for k=1:Kii
        w(1,(Kii+1):(2*k-1))=temp2(k);
        w(1,(Kii+1):(2*k))=temp3(k);
    end
else
    w(1,(Kii+1):(2*Kii))=temp2;
    w(1,(Kii+1):(3*Kii))=temp3;
end

%% 速率匹配
%  Channel_type==0
    if (direction==0)
        Ncb=min([floor(Nir/C),Kw]);
    else 
        Ncb=Kw;
    end

    Qm=module_type*2;
    Gpie=G/(Nl*Qm);
    Gama=mod(Gpie,C);
    if (r<C-Gama)
        E=Nl*Qm*floor(Gpie/C);
    else
        E=Nl*Qm*ceil(Gpie/C);
    end

    Rsub=Kii/32;
    k0=Rsub*(2*ceil(Ncb/(8*Rsub))*Rvidx+2);
    k=1;
    j=0;
    output_data=zeros(1,mod(k0+j,Ncb)+1);
    while (k<E+1)
        if (w(1,mod(k0+j,Ncb)+1)<2)
            output_data(k)=w(1,mod(k0+j,Ncb)+1);
            k=k+1;
        end
        j=j+1;
    end
    out_len=length(output_data);
end

