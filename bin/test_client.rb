require 'battle_tank/client'

threads = []
%w{Rogue Medic Barmaid}.each do |name|
  threads << Thread.new do

    client = BattleTank::Client.new(name)

    (101..105).each do |move|

      sleep(0.2)

      client.send(move.to_s)

      #receiver.recv_string(msg = '')
      ## Simple progress indicator for the viewer
      #$stdout << "PULL #{msg}.\n"
      #$stdout.flush

    end

    sleep 1
    client.close
    sleep 1

  end
end

threads.each(&:join)
