clc
clear all 

error_probability = 0.01:0.05:0.1; % Define error probability range
 
lamda = 1:16; % Define lambda range

sync_word = [1 1 1 0 0 0 1 1 1 0 1 1 0 1 1 0]; % Define sync word

for e = 1:length(error_probability) % Loop through error probability range
    mda = zeros(1, 16); % Initialize missed detection count array
    pfa = zeros(1, 16); % Initialize false alarm count array
    frames = 10000; % Define number of frames to simulate
    
    for k = 1:16 % Loop through lambda range
        for j = 1:frames % Loop through frames
            matric = zeros(1, 15); % Initialize count array        
           
            error_vector = rand(1, 32) <= error_probability(e); % Generate random error vector with given probability
            data = randi([0 1], 1, 16); % Generate random data vector
            data_pack = [sync_word, data]; % Create data packet with sync word and data
            data_pack_received = xor(data_pack, error_vector); % Add errors to data packet
            for i = 1:length(data_pack_received) - 15 % Loop through data packet
                temp = data_pack_received(i:i+15); % Get 16-bit segment of data packet

                matric(i) = sum(temp == sync_word); % Count number of sync word matches in segment
                if (i ~= 1 && matric(i) >= lamda(k)) % Check for false alarm
                    pfa(lamda(k)) = pfa(lamda(k)) + 1;
                end
                if (i == 1 && matric(i) < lamda(k)) % Check for missed detection
                    mda(k) = mda(k) + 1;
                end
             end
        end
     pfa(k) = pfa(k) / (16 * frames); % Calculate false alarm rate
     mda(k) = mda(k) / (16 * frames); % Calculate missed detection rate
       
    end
    
    % Plot results
    stem(matric)
    grid on
    hold all
    %semilogy(lamda, pfa, 'LineWidth', 1);
    %hold on;
    %grid on;
    %semilogy(lamda, mda, 'LineWidth', 1);
    %xlabel('Lamda');
    %ylabel('P(fault detection) P(missed detection)');
    
end
