%---------------------------------------------------------------------------%
                  % �ӳ��� ��getYmatrix1.m������Ϊ����ڵ㵼�ɾ���             
                  % ��ڲ������ڵ��������bus,֧·��������branch               
                  % ���ز�������ȫ�ڵ㵼�ɾ���Y(�ѿ��ǶԵص��ݺͱ�ѹ���Ǳ�׼��ȣ�
                  %          �ο��ڵ���nodeRe
%---------------------------------------------------------------------------%
function [Y,nodeRe] = getYmatrix1(bus,branch)

    nb=size(bus,1);                            % size(A,n) n=1����������n=2��������
    nl=size(branch,1);
    Y=zeros(nb,nb);                           % �Ե��ɾ��󸳳�ֵ0
    for k=1:nl   
        I=branch(k,1);                         % �ڵ�i
        J=branch(k,2);                         % �ڵ�j
        Yt=1/(branch(k,3)+1j*branch(k,4));     % ֧·���� Z=R+jX                         
        Ym=1j*branch(k,5)/2;                   % ֧·�Ե� jb/2
        K=branch(k,9);                         % i,j����K
%% ����Yr����
        if K~=0                                  % ��ѹ��֧·i:j=K:1
            Y(I,I)=Y(I,I)+Yt/K+(1-K)*Yt/K/K-Ym;% ���Ǳ�ѹ���Ǳ�׼���
            Y(J,J)=Y(J,J)+Yt/K+(K-1)*Yt/K-Ym;  % ��ѹ���Ե�֧·Ϊ��ֵ
            Y(I,J)=Y(I,J)-Yt/K;                % ������Ϊ��
        else                                     % ��ͨ��·
            Y(I,I)=Y(I,I)+Yt+Ym;
            Y(J,J)=Y(J,J)+Yt+Ym;
            Y(I,J)=Y(I,J)-Yt;
        end
        Y(J,I)=Y(I,J);                         % ������������֧·����������ͬ
    end
 %% �ҵ��ο��ڵ�  
    nodeRe=0;                                 
    for t=1:nb
        Ys=(bus(t,5)+1j*bus(t,6))/100;     % �ڵ�ӵ�֧· Ys=Gs+jBs
        Y(t,t)=Y(t,t)+Ys;
        if bus(t,2)==3
            nodeRe=bus(t,1);
        end
    end
end
 