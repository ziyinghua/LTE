function coded_data=TurboEncodeFun(C,cdblkseg_data,Cm,Km,Kp,F)
for k=1:C
    if(k<=Cm)
        info_len=Km;
    else
        info_len=Kp;
    end
    coded_data(3*(k-1)+1:3*k,1:info_len+4)=Turbo_encoder(cdblkseg_data(k,:),info_len);
    if(k==1)
        if F>0
            coded_data(1:2,1:F)=2*ones(2,F);
        end
    end
end

