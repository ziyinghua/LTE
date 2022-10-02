function Output= Subblock_interleave_index(Info_data,intl_mode)
if (intl_mode==0)||(intl_mode==1)
    Col_intl=[0,16,8,24,4,20,12,28,2,18,10,26,6,22,14,30,1,17,9,25,5,21,13,29,3,19,11,27,7,23,15,31];
    Col_intl=Col_intl+1;
else
    Col_intl=[1,17,9,25,5,21,13,29,3,19,11,27,7,23,15,31,0,16,8,24,4,20,12,28,2,18,10,26,6,22,14,30];
    Col_intl=Col_intl+1;
end


Col_len=length(Col_intl);%32
Row=ceil(length(Info_data)/Col_len);
kpi=Col_len*Row;
Nd=kpi-length(Info_data);
Temp_data=[ NaN *ones(1,Nd) ,Info_data ];

switch intl_mode
    case 0
        First_mat=reshape(Temp_data,Col_len,Row);
        Output=zeros(1,Row*Col_len);
        for k=1:Col_len
            Output(1,(k-1)*Row+1:k*Row)=First_mat(Col_intl(k),:);
        end

    case 1
        Output=zeros(1,Row*Col_len);
         for k=1:Col_len*Row
            temp1=floor((k-1)/Row)+1;
            temp2=Col_len*mod((k-1),Row);
            temp3=Col_intl(temp1)+temp2;
            temp4=mod(temp3,Row*Col_len)+1;
            Output(1,k)=Temp_data(1,temp4);
         end

    case 2
         First_mat=reshape(Temp_data,Col_len,Row);
        Output=zeros(1,Row*Col_len);
        for k=1:Col_len
            Output(1,(k-1)*Row+1:k*Row)=First_mat(Col_intl(k),:);
        end

end
end

