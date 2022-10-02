%% For Educaton Purpose
% Experiments of LTE Uplink TRX
% Version 1.12
% Oct. 18th 2019
% Oct. 9th 2020
% Sept. 16th 2021


clear; clc; close all;
% 
workdir = 'C:\Users\wxhkx\Desktop\Matlab\M_C_S_Design'; % Use your own working directory locally
                       % Make sure all your sub-routines are all in this
                       % directory.     C:\Users\wxhkx\Desktop\Matlab\M_C_S_Design

cd(workdir) 

%% 0.0. Students' Group Number ...

result.GroupNo = 0;   % keep it unchaged by default

%% 0.0. Students' Group Number ###

%% 0.1. General Parameters Setting ......
tbsize = 57336;%
module_type = 1; %1: QPSK; 2:16QAM; 3:64QAM
prb_num = 100;
rbstart = 0;
Qm = module_type*2;
UL_subframe_num = 2;
ue_index = 60;
cellid = 0;

antnum =1; %����������Ŀ 1�������߽���  2:2���߽���
addnoiseflag =0; %1:�������  0�����������

%����ƥ��ʹ�ò���
Channel_type =0;
Nir =0;
direction =1;
RVidx =0;
Nl =1;
G=12*12*prb_num*Qm;
mimo_type = 1;
cfi=1;
cp_type = 0;

% G = G_cal(1,cp_type,cfi,UL_subframe_num,prb_num,module_type,mimo_type);%����ÿ����������ܷ��͵�ȫ��������                          
% [C, Cp, Kp, Cm, Km, F]  = cdblk_para_cal(tbsize);
% E= E_cal(G,C,module_type,Nl);%����ÿ������������ƥ����������� 

%��Դ����
% info_data = Source_data_gen(1, 1, tbsize, 1, 0);
load 'C:\Users\wxhkx\Desktop\Matlab\M_C_S_Design\info_data.mat';   %%% for 2021 fall 
inf_bit=info_data;
% dlmwrite('.\data\Source.dat',info_data,'delimiter','\n','precision',1);
[result.exp00, par] = SeqSignature(inf_bit); %  signature is FA3754
%%%% 0.1. General Parameters Setting ######

%% 01.1 CRC��� ......
% crc_data = CRC_attach(info_data,24,0);
[ crc_data,crc_24] = Ite_CRC24A(inf_bit);
result.exp11 = dec2hex([8, 4, 2, 1]*reshape(crc_24, 4, []))';  %%% = result.exp00

%% 01.2 ���ָ� ......

[Cp, Kp, Cm, Km, F, cdblkseg_data] = Cdblk_seg1(crc_data);
C = Cp+Cm;
result.exp12 = SeqSignature(cdblkseg_data, result.GroupNo);



%% Exp.02.1 Turbo���� ......
coded_data = zeros(3*C,Cp+4);
coded_data = TurboEncodeFun(C,cdblkseg_data,Cm,Km,Kp,F);

result.exp21 = SeqSignature(coded_data, result.GroupNo);
%%%% Exp.02.1 Turbo���� ######
%% ############################################################


%% Exp.02.2 �ӿ齻֯������ƥ�� ......
rm_data = zeros(C,3*Cp+12);
[rm_data,rm_len] = RateMatchingFun(coded_data,Channel_type, Nir, C, Cm,direction, module_type, RVidx, Nl, G,Km,Kp);

result.exp22 = SeqSignature(rm_data, result.GroupNo);
%%%% Exp.02.2 �ӿ齻֯������ƥ�� ######
%% ############################################################


%% Exp.02.3 ��鼶�� ......
ccbc_data = Cdblk_concatel(C,rm_data,rm_len);

result.exp23 = SeqSignature(ccbc_data, result.GroupNo);
%%%% Exp.02.3 ��鼶�� ######
%% ############################################################


%% Exp.02.4 �ŵ���֯ ......
interleaver_data = interleaver(ccbc_data,prb_num,Qm);

result.exp24 = SeqSignature(interleaver_data, result.GroupNo);
%%%% Exp.02.4 �ŵ���֯ ######
%% ############################################################


%% Exp.02.5 ���� ......
scramble_data = scramblefun(interleaver_data,prb_num,Qm,UL_subframe_num,ue_index,cellid);

result.exp25 = SeqSignature(scramble_data, result.GroupNo);
%%%% Exp.02.5 ���� ######
%% ############################################################







%% Exp.03.1 ���� ......
mod_data = modfun(scramble_data,prb_num,module_type);

result.exp31 = SeqSignature(mod_data, result.GroupNo);
%%%% Exp.03.1 ���� ######
%% ############################################################


%% Exp.03.2 ����ʱ϶��Ƶ�źŲ��� ......
[rs_slot1,rs_local_slot1] = pusch_rs_gen(prb_num,0,0,2*UL_subframe_num,cellid,0,0,0,3);
[rs_slot2,rs_local_slot2] = pusch_rs_gen(prb_num,0,0,2*UL_subframe_num+1,cellid,0,0,0,3);

result.exp32 = SeqSignature([rs_slot1, rs_slot2], result.GroupNo);
%%%% Exp.03.2 ����ʱ϶��Ƶ�źŲ��� ######
%% ############################################################


%% Exp.04.1 ��Դ���ӣ�RE��ӳ�� ......
remapdata = remap(mod_data,rs_slot1,rs_slot2,prb_num,rbstart);

result.exp41 = SeqSignature(remapdata, result.GroupNo);
%%%% Exp.04.1 ��Դ���ӣ�RE��ӳ�� ......
%% ############################################################


%% Exp.04.2 ����Ƶ������ ......
fredata = genFredata(remapdata);

result.exp42 = SeqSignature(fredata, result.GroupNo);
%%%% Exp.04.2 ����Ƶ������ ######
%% ############################################################


%% Exp.04.3 �������߿�ʱ������ ......
antdata = genantdata(fredata); %% ���� OFDM ����

result.exp43 = SeqSignature(antdata, result.GroupNo);
%%%% Exp.04.3 �������߿�ʱ������ ######
%% ############################################################


%% Validating ......

result

%%%% Validating ######
%% ############################################################



% #########################################################################
% #####   Receiving Experiments Structure Relies on Individuals       #####
% #########################################################################

