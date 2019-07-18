%---------------------------------------------------------------------------%
                  % �ӳ��� �� output.m������Ϊ���������ʾ             
                  % ��ڲ�������ͼ��ʾ��־λdraw_flag��״̬����ֵ����pfresult��
                  %          �ڵ��ѹ��ֵʸ��ampV,�ڵ��ѹ���ʸ��angV��
                  %          ��������iter������ʱ��runtime�����϶�ksi
                  % ���ز�������
%---------------------------------------------------------------------------%
function []=output(alg_flag,draw_flag,pfresult,ampV,angV,iter,runtime,ksi)
    
    angV=180/pi*angV;
    time=datestr(now,'yyyy-mm-dd HH:MM');
    if alg_flag==1
        fprintf('                                       ���ڿ��ٷֽⷨ�ĵ���ϵͳ״̬���ƽ��                                        \n');
        fprintf('                            Results of State Estimation Based on Fast Decoupled Method                           \n');
    else
        fprintf('                                   ���ڼ�Ȩ��С���˷��ĵ���ϵͳ״̬���ƽ��                                        \n');
        fprintf('                       Results of State Estimation Based on Weight Least Squares Method                          \n');
    end
    fprintf('                                         %s    by J.W.Qi                                           \n',time);
    fprintf('                                             MATLAB Version��R2014a                                                  \n');
    fprintf('                                Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz(8GB RAM)                                   \n');
    fprintf('==================================================================================================================\n');
    fprintf('�ڵ��    �ڵ��ѹ��ֵ      �ڵ��ѹ��ֵ      ��ֵ���          �ڵ��ѹ���       �ڵ��ѹ���        ������   \n');
    fprintf('         (����ֵ/p.u.)     (��ʵֵ/p.u.)      (p.u.)         (����ֵ/degree)    (��ʵֵ/degree)      (degree)  \n');
    fprintf('==================================================================================================================\n');
    erampV=pfresult(:,2)-ampV(:,1);
    erangV=pfresult(:,3)-angV(:,1);
    for i=1:size(pfresult,1)
    fprintf('%6d %12.6f     %12.6f    %12.6f        %12.6f       %12.6f     %12.6f      \n',i,ampV(i,1),pfresult(i,2),erampV(i,1),angV(i,1),pfresult(i,3),erangV(i,1));
    end
    fprintf('==================================================================================================================\n');
    fprintf('����Ч������ָ�꣺\n');
    fprintf('��1���㷨�ļ���Ч�ʣ�������������%-2d��                                 ������ʱ�䡿%-7.4f��\n',iter,runtime);
    fprintf('��2�����������ƾ��ȣ������ϳ̶ȡ�%4.2f%%\n',ksi);
    fprintf('��3��״̬�����ƾ���: ���������ѹ��ֵ(p.u.)��%8.6f @ bus%4d    ��ѹ���(degree)��%8.6f @ bus%4d\n',max(abs(erampV)),find(abs(erampV)==max(abs(erampV))),max(abs(erangV)),find(abs(erangV)==max(abs(erangV))));
    fprintf('                    ��ƽ������ѹ��ֵ(p.u.)��%8.6f              ��ѹ���(degree)��%8.6f\n',sum(abs(erampV))/size(pfresult,1),sum(abs(erangV))/size(pfresult,1));
    fprintf('------------------------------------------------------------------------------------------------------------------\n');
    if draw_flag==1   
        subplot(2,1,1);
        plot(1:size(ampV,1),ampV,'-r');
        grid on;      %�������
        hold on;
        plot(1:size(ampV,1),pfresult(:,2),':b');
        legend('����ֵ','��ʵֵ');
        axis([1,size(ampV,1),0.90,1.10]); 
    %     set(gca, 'XTick',[1:size(ampV,1)]);                  
        xlabel('�ڵ����');ylabel('�ڵ��ѹ��ֵ��p.u.��');
    %     title('���ڿ��ٷֽⷨ�ĵ���ϵͳ״̬���ƽ������ѹ��ֵ���Ƚ�');

        subplot(2,1,2);
        plot(1:size(angV,1),angV,'-r');
        grid on;      %�������
        hold on;
        plot(1:size(angV,1),pfresult(:,3),':b');
        legend('����ֵ','��ʵֵ');
        axis([1 size(ampV,1) -90 90]);
    %     set(gca, 'XTick',[1:size(angV,1)]);                 
        xlabel('�ڵ����');ylabel('�ڵ��ѹ��ǣ�degree��');
    %     title('���ڿ��ٷֽⷨ�ĵ���ϵͳ״̬���ƽ������ѹ��ǣ��Ƚ�');
    end
end