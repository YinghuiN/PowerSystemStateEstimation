%---------------------------------------------------------------------------%
                  % �ӳ��� ��getBmatrix.m������Ϊ���㳣���ſ˱Ⱦ���             
                  % ��ڲ������򻯽ڵ㵼�ɾ���Ya����ȫ�ڵ㵼�ɾ���Yr
                  %           ֧·��������branch�������������mdata��
                  %           �ο��ڵ�nodeRe���ο��ڵ��ѹ��ֵampV0
                  % ���ز�����P-Theta�����ſ˱Ⱦ���Ba
                  %          Q-V    �����ſ˱Ⱦ���Br  
%---------------------------------------------------------------------------%
function [Ba,Br] = getBmatrix(Ya,Yr,branch,mdata,nodeRe,ampV0)
    
    nbus=size(Ya,1);  
    nmdata=size(mdata,1);
    ImYa=imag(Ya);                           % ȡYa�����鲿
    ImYr=imag(Yr);                           % ȡYr�����鲿                    
    type=mdata(:,1);
    Pcount=length(find(type==1))+length(find(type==3))+length(find(type==-3));
    Qcount=nmdata-Pcount-1;                % �����޹�����ʸ��������ȥ���ο��ڵ��ѹ��
    Ba=zeros(Pcount,nbus-1);               % �й�ʸ���ſ˱�Ba�����ʼ�� ma��na�ף�ȥ���ο��ڵ��ѹ�� 
    Br=zeros(Qcount,nbus-1);               % �޹�ʸ���ſ˱�Br�����ʼ�� mr��nr�ף�ȥ���ο��ڵ��ѹ��
    Pcount=0;
    Qcount=0;
    for n=1:nmdata
        type=mdata(n,1);
        I=mdata(n,6);
        J=mdata(n,7);
        switch(type)
            case 0                     % �ڵ��ѹ Vi(i=j)
                if I~=nodeRe
                    Qcount=Qcount+1;
                    Br(Qcount,I)=-1/ampV0;  % 1=-v0*(-1/v0)
                end
            case 2                     % �ڵ�ע���޹� Qi(i=j)
                Qcount=Qcount+1;
                for t=1:nbus
                    if t==I
                        Br(Qcount,t)=ImYr(I,I)+sum(ImYr(I,:)); % (-Bii*v0^2+Qi)/v0=-v0*(Bii+sigma(Bij))
                    else
                        Br(Qcount,t)=ImYr(I,t);  % -Bij*v0=-v0*(Bij)
                    end
                end 
            case 4                     % ֧·�׶��޹� Qij
                Qcount=Qcount+1;
                br=imag(1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4)));
                y2c=branch(mdata(n,8),5);
                k=branch(mdata(n,8),9);
                if k~=0
                    Br(Qcount,I)= 2*br/k/k-br/k;
                    Br(Qcount,J)= -br/k;
                else
                    Br(Qcount,I)= br+y2c;  %-ImYr(I,J); % -v0*(b+2yc)   % b��B��ͬ��B�ǻ����ɵ��鲿��������ȡ��ʱ��Yij=-yij;
                    Br(Qcount,J)= -br; %ImYr(I,J);% v0*b=-v0*(-b)
                end
            case -4                    % ֧·ĩ���޹� Qji
                Qcount=Qcount+1;
                br=imag(1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4)));
                y2c=branch(mdata(n,8),5);
                k=branch(mdata(n,8),9);
                if k~=0
                    Br(Qcount,I)= -br/k;
                    Br(Qcount,J)= 2*br-br/k;
                else
                    Br(Qcount,I)=-br;% ImYr(I,J); % v0*b=-v0*(-b)
                    Br(Qcount,J)=br+y2c; % -ImYr(I,J); % -v0*(b+2yc)
                end
            case 1                     % �ڵ�ע���й�Pi(i=j)
                Pcount=Pcount+1;
                for t=1:nbus
                    if t==I
                        Ba(Pcount,t)=ImYa(I,I)-sum(ImYa(I,:)); % -Bii*v0^2-Qi=-v0^2*(Bii-sigma(Bij))
                    else
                        Ba(Pcount,t)=ImYa(I,t); % -Bij*v0^2=-v0^2*(Bij)
                    end
                end        
            case 3                     % ֧·�׶��й�Pij
                Pcount=Pcount+1;
                ba=-1/(branch(mdata(n,8),4));
                Ba(Pcount,I)= ba;% -ImYa(I,J); % -v0^2*b
                Ba(Pcount,J)=-ba;% ImYa(I,J);% v0^2*b
            case -3                   % ֧·ĩ���й�Pji
                Pcount=Pcount+1;
                ba=-1/(branch(mdata(n,8),4));
                Ba(Pcount,I)=-ba;% ImYa(I,J);% v0^2*b
                Ba(Pcount,J)=ba;% -ImYa(I,J);
        end
    end
    if nodeRe==1                         % ɾȥ�ο��ڵ�
        Br=Br(:,2:nbus);
        Ba=Ba(:,2:nbus);
    else
        Br=[Br(:,1:(nodeRe-1)) Br(:,((nodeRe+1):nbus))];
        Ba=[Ba(:,1:(nodeRe-1)) Ba(:,((nodeRe+1):nbus))];
    end
    
end
