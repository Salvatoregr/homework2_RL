close all
clear all
clc

% Selezione bag file
%bag = rosbag('coppie_cubica_circolare.bag');
%bag = rosbag('coppie_cubica_lineare.bag');
%bag = rosbag('coppie_trapezoidale_circolare.bag');
bag = rosbag('coppie_trapezoidale_lineare.bag');

% Definizione dei topic
topics = {
    '/iiwa/iiwa_joint_1_effort_controller/command',
    '/iiwa/iiwa_joint_2_effort_controller/command',
    '/iiwa/iiwa_joint_3_effort_controller/command',
    '/iiwa/iiwa_joint_4_effort_controller/command',
    '/iiwa/iiwa_joint_5_effort_controller/command',
    '/iiwa/iiwa_joint_6_effort_controller/command',
    '/iiwa/iiwa_joint_7_effort_controller/command'
};

numJoints = length(topics);
jointTorqueMsgs = cell(numJoints, 1);
numMessages = zeros(numJoints, 1);
numJointData = zeros(numJoints, 1);
jointTorques = cell(numJoints, 1);

% Lettura coppie da messaggi per ogni joint
for i = 1:numJoints
    jointTorqueMsgs{i} = readMessages(select(bag, 'Topic', topics{i}));
    numMessages(i) = length(jointTorqueMsgs{i});
    numJointData(i) = length(jointTorqueMsgs{i}{1}.Data);
    jointTorques{i} = zeros(numMessages(i), numJointData(i));

    % Estrazione coppie da messaggi per ogni joint
    for j = 1:numMessages(i)
        torques = jointTorqueMsgs{i}{j}.Data;
        jointTorques{i}(j, :) = torques;
    end
end

% Creazione del vettore tempo
time = linspace(0.29, 2.99, numMessages(1));

% Plot delle coppie per tutti i joint su un unico grafico
figure;
grid;
hold on;
for joint = 1:numJoints
    plot(time, jointTorques{joint}, 'DisplayName', ['Joint ', num2str(joint)]);
end
hold off;
title('Joint Torques');
xlabel('Time [s]');
ylabel('Torque [Nm]');
legend('show');
