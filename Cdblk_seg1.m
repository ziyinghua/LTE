function [Cp,Kp,Cm,Km,F,Out_data]=Cdblk_seg1(Info_data)

B=length(Info_data);
Z=6144;
par=(Info_data(1,B-23:B));
K_Table=[40:8:511,512:16:1023,1024:32:2047,2048:64:6144];%K值表

if B<Z
    L=0;%L：附加CRC校验的长度
    C=1;%C：输出码块总数
    Bp=B;%Bp：输出码字的总数
else
    L=24;
    C=ceil(B/(Z-L));
    Bp=B+C*L;
end

Kp=min(K_Table(C*K_Table>=Bp));%第一个分段大小

if C==1
    Cp=1;%长度为Kp的码块数目
    Km=0;
    Cm=0;
elseif C>1
    Km=max(K_Table(K_Table<Kp));%第二个分段大小
    delta_k=Kp-Km;
    Cm=floor((C*Kp-Bp)/delta_k);%长度为Km的分段数目
    Cp=C-Cm;%长度为Kp的分段数目
end

K_r=zeros(1,C);%K_r 是一个行向量，包含每个代码块的所需长度 。
for r=0:C-1
    if r<Cm
        K_r(r+1)=Km;
    else
        K_r(r+1)=Kp;
    end
end

F=Cp*Kp+Cm*Km-Bp;%需要填充的比特数目

c_r=cell(1,C);%c_r将是一个由C行向量组成的行单元数组，每个行向量代表一个代码块,即存放输出数据
for r=0:C-1
    c_r{r+1}=zeros(1,K_r(r+1));
end

for k=0:F-1
    c_r{1}(k+1)=NaN;
end

k=F;
s=0;
for r=0:C-1
    while k<K_r(r+1)-L
        c_r{r+1}(k+1)=Info_data(s+1);
        k=k+1;
        s=s+1;
    end
    if C>1
        while k<K_r(r+1)
            a_r= c_r{r+1}(1:K_r(r+1)-L);
            a_r(isnan(a_r)) = 0;
            [~,p_r] = Ite_CRC24B(a_r);
            c_r{r+1}(k+1)=p_r(k+L-K_r(r+1)+1);
            k=k+1;
        end
    end
    k=0;
end
Out_data=c_r;
Out_data=reshape(cell2mat(Out_data),5760,10)';
