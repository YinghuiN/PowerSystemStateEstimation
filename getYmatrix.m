%---------------------------------------------------------------------------%
                  % �ӳ��� ��getYmatrix.m������Ϊ����ڵ㵼�ɾ���             
                  % ��ڲ������ڵ��������bus,֧·��������branch               
                  % ���ز������򻯽ڵ㵼�ɾ���Ya(�����ǶԵص��ݺͱ�ѹ���Ǳ�׼��ȣ�ֱ����֧·�翹������
                  %          ��ȫ�ڵ㵼�ɾ���Yr(�ѿ��ǶԵص��ݺͱ�ѹ���Ǳ�׼��ȣ�
                  %          �ο��ڵ���nodeRe
%---------------------------------------------------------------------------%
function [Ya,Yr,nodeRe] = getYmatrix(bus,branch)

    nb=size(bus,1);                            % size(A,n) n=1����������n=2��������
    nl=size(branch,1);
    Ya=zeros(nb,nb);                           % �Ե��ɾ��󸳳�ֵ0
    Yr=zeros(nb,nb);                           % �Ե��ɾ��󸳳�ֵ0
    for k=1:nl   
        I=branch(k,1);                         % �ڵ�i
        J=branch(k,2);                         % �ڵ�j
        Yt=1/(branch(k,3)+1j*branch(k,4));     % ֧·���� Z=R+jX                         
        Ym=1j*branch(k,5)/2;                   % ֧·�Ե� jb/2
        K=branch(k,9);                         % i,j����K
        Yta=1/(1j*branch(k,4));                % �����ǶԵص��ݺͱ�ѹ���Ǳ�׼��ȣ�ֱ����֧·�翹����
%% ����Ya����        
        Ya(I,I)=Ya(I,I)+Yta;                    
        Ya(J,J)=Ya(J,J)+Yta;
        Ya(I,J)=Ya(I,J)-Yta;
        Ya(J,I)=Ya(I,J);
%% ����Yr����
        if K~=0                                  % ��ѹ��֧·i:j=K:1
            Yr(I,I)=Yr(I,I)+Yt/K+(1-K)*Yt/K/K-Ym;% ���Ǳ�ѹ���Ǳ�׼���
            Yr(J,J)=Yr(J,J)+Yt/K+(K-1)*Yt/K-Ym;  % ��ѹ���Ե�֧·Ϊ��ֵ
            Yr(I,J)=Yr(I,J)-Yt/K;                % ������Ϊ��
        else                                     % ��ͨ��·
            Yr(I,I)=Yr(I,I)+Yt+Ym;
            Yr(J,J)=Yr(J,J)+Yt+Ym;
            Yr(I,J)=Yr(I,J)-Yt;
        end
        Yr(J,I)=Yr(I,J);                         % ������������֧·����������ͬ
    end
 %% �ҵ��ο��ڵ�  
    nodeRe=0;                                 
    for t=1:nb
        Ys=(bus(t,5)+1j*bus(t,6))/100;     % �ڵ�ӵ�֧· Ys=Gs+jBs
        Yr(t,t)=Yr(t,t)+Ys;
        if bus(t,2)==3
            nodeRe=bus(t,1);
        end
    end
end
 