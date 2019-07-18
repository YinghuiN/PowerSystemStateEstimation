%---------------------------------------------------------------------------%
                  % �ӳ��� �� iteration.m������Ϊ��������             
                  % ��ڲ������ڵ��������bus,֧·��������branch,
                  %          �����������mdata,�ڵ��ѹ��ֵ����ǳ�ֵampV0,angV0,
                  %          ��ȫ���ɾ���Yr,�й������ſ˱Ⱦ���Ba,
                  %          �޹������ſ˱Ⱦ���Br���ο��ڵ����nodeRe
                  % ���ز������ڵ��ѹ��ֵʸ��ampV,�ڵ��ѹ���ʸ��angV��
                  %          ��������iter���й�����ʸ��Za,
                  %          �޹�����ʸ��Zr,�й����⺯��ʸ��ha,
                  %          �޹����⺯��ʸ��hr
%---------------------------------------------------------------------------%
function [ampV,angV,iter,Za,Zr,ha,hr] = iteration(bus,branch,mdata,ampV0,angV0,Yr,Ba,Br,nodeRe)
    mbus=size(bus,1);
    mP=size(Ba,1);
    mQ=size(Br,1);
    mr=size(mdata,1);
    
    angV=zeros(mbus,1);                    % �ڵ��ѹ��Ǹ���ֵ0
    ampV=zeros(mbus,1);       
    ampV(:,1)=ampV0;                       % �ڵ��ѹ��ֵ����ֵv0
    angV(:,1)=angV0;  
    
    Ra=zeros(mP,mP);                       % ��ʼ��Ȩ�ؾ���
    Rr=zeros(mQ,mQ);
    Za=zeros(mP,1);                        % ��ʼ������������
    Zr=zeros(mQ,1);
    Pcount=0;                              % �����й��޹���������־
    Qcount=0;
    Pflag=0;                               % �õ�����־
    Qflag=0;
    haflag=0;
%% ����Ȩ������,��������  
    for i=1:mr                             
        type=mdata(i,1);
        if type==1||type==3||type==-3
            Pcount=Pcount+1;
            Ra(Pcount,Pcount)=mdata(i,5);
            Za(Pcount,1)=mdata(i,2);
        else
            if type==0 && mdata(i,6)==nodeRe && mdata(i,7)==nodeRe  % �ο��ڵ㲻��
                continue;
            else
                Qcount=Qcount+1;
                Rr(Qcount,Qcount)=mdata(i,5);
                Zr(Qcount,1)=mdata(i,2);
            end
        end
    end
%% ���㳣����Ϣ����
    A=ampV0^4*(-Ba)'*Ra*(-Ba);            
    B=ampV0^2*(-Br)'*Rr*(-Br);
%% ��������
    for n=1:100
        if Pflag==0
%             ha=gethamatrix(bus,branch,mdata,Yr,Ba,angV,ampV);
            haflag=1;
            [ha,~] = gethmatrix(bus,branch,mdata,Yr,Ba,Br,angV,ampV,nodeRe,haflag);
            a=ampV0^2*(-Ba)'*Ra*(Za-ha);
            dAngV=A\a;            % �����A�������a
            if max(abs(dAngV))<1e-5
                Pflag=1;
            else                  % �������
                if nodeRe==1
                    angV(2:mbus,1)         = angV(2:mbus,1)+dAngV(:,1);
                else
                    angV(1:(nodeRe-1),1)   = angV(1:(nodeRe-1),1)+dAngV(1:(nodeRe-1),1);
                    angV((nodeRe+1):mbus,1)= angV((nodeRe+1):mbus,1)+dAngV(nodeRe:(mbus-1),1);
                end
            end
        end
        if Qflag==0
%             hr= gethrmatrix(bus,branch,mdata,Yr,Br,angV,ampV,nodeRe);
            haflag=0;
            [~,hr] = gethmatrix(bus,branch,mdata,Yr,Ba,Br,angV,ampV,nodeRe,haflag);
            b=ampV0*(-Br)'*Rr*(Zr-hr);
            dAmpV=B\b;
            if max(abs(dAmpV))<(ampV0*1e-5)
                Qflag=1;
            else            % ������ֵ
                if nodeRe==1
                    ampV(2:mbus,1)          = ampV(2:mbus,1)+dAmpV(:,1);
                else 
                    ampV(1:(nodeRe-1),1)    = ampV(1:(nodeRe-1),1)+dAmpV(1:(nodeRe-1),1);
                    ampV((nodeRe+1):mbus,1) = ampV((nodeRe+1):mbus,1)+dAmpV(nodeRe:(mbus-1),1);
                end
            end
        end
        if Pflag==1 && Qflag==1
            break;
        end
    end
    iter=n;
end