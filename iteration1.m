%---------------------------------------------------------------------------%
                  % �ӳ��� �� iteration.m������Ϊ��������             
                  % ��ڲ������ڵ��������bus,֧·��������branch,
                  %          �����������mdata,�ڵ��ѹ��ֵ����ǳ�ֵampV0,angV0,
                  %          ��ȫ���ɾ���Y,�ο��ڵ����nodeRe
                  % ���ز������ڵ��ѹ��ֵʸ��ampV,�ڵ��ѹ���ʸ��angV��
                  %          ��������iter������ʸ��z
                  %          ���⺯��ʸ��h
%---------------------------------------------------------------------------%
function [ampV,angV,iter,z,h] = iteration1(bus,branch,mdata,Y,ampV0,angV0,nodeRe)
    nbus=size(bus,1);
    nmdata=size(mdata,1);
    angV=zeros(nbus,1);                       
    ampV=zeros(nbus,1);       
    ampV(:,1)=ampV0;                          % �ڵ��ѹ��ֵ����ֵv0
    angV(:,1)=angV0;                          % �ڵ��ѹ��Ǹ���ֵ0
    R=zeros(nmdata,nmdata);                   % ��ʼ��Ȩ�ؾ���
    z=zeros(nmdata,1);                        % ��ʼ������������
    for i=1:nmdata                             
        R(i,i)=mdata(i,5);
        z(i,1)=mdata(i,2);
    end
    for n=1:100
        H = getJacmatrix1(branch,mdata,nodeRe,Y,ampV,angV);
        h = gethmatrix1(bus,branch,mdata,Y,angV,ampV);
        A = H'*R*H;
        B = H'*R*(z-h);
        del = A\B;
        if max(abs(del))<1e-5
            break;
        else
            ampV = ampV + del(1:nbus,1);
            temp = del(nbus+1:2*nbus-1,1);
            if nodeRe == 1
                angV(2:nbus,1) = angV(2:nbus,1) + temp;
            else
                angV(1:(nodeRe-1),1)    = angV(1:(nodeRe-1),1) + temp(1:(nodeRe-1),1);
                angV((nodeRe+1):nbus,1) = angV((nodeRe+1):nbus,1) + temp(nodeRe:nbus-1,1);
            end
        end
    end
    iter = n;
end