function [ Info_data,par] = Ite_CRC24B(inf_bits)
par=zeros(1,24);
G = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1];%生成多项式，由低位到高位
CRC_test= [inf_bits,zeros(1,24)];%返回一个1x24的零矩阵
for i=1:length(inf_bits)
    if CRC_test(i)==1
        for j=(1:length(G))
            CRC_test(i+j-1)=xor(CRC_test(i+j-1),G(j));%逻辑异或
        end
    end
end
for k= 1:24
    par(k)=CRC_test(length(inf_bits)+k);%数据进行合并
end
Info_data =[inf_bits,par];