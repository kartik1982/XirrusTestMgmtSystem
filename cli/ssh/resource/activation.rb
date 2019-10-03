module Activation
  def activation_done?(wait_time=10)
    sleep wait_time

    ready_to_move_on = false
    attempts = 0
    while ((ready_to_move_on == false) && attempts < 35)
      man = cmd(['more off','show running-config', 'quit'])
      attempts += 1
      interval_line = man.select{|m|
        m.start_with?"activation interval"
      }.first
      interval = interval_line.split(' ')[2].gsub(/[\(\)]/, '')
      # log("Checking Activation Interval #{interval} - #{Time.now}")
      if interval == "20"
      ready_to_move_on = true
      else
        puts "- not configured yet. On attempt: #{attempts}"
        sleep wait_time
      end
    end
    ready_to_move_on
  end

  def show_activation_interval()
    show_json("running-config")["system"] ["mgmtCfg"]["mgmtActivationInterval"]
  end

  def activate(env='test03')
    cmd(["cloud off", "activation stop", "activation interval 1", "activation server https://activate-#{env}.cloud.xirrus.com", "cloud on", "activation start", "save", "quit"])
  end

  def start_activation()
    cmd(["activation interval 1", "cloud on", "activation start", "save", "quit"])
  end

  def set_activation_url(env, times=1, url=nil)
    url = url || ACTIVATION_URL.gsub("env", env)
    actions = []
    times.times{ actions << "activation server #{url}" }
    actions << "save" << "quit"
    cmd(actions)
  end

  def activation_server()
    show_json("running-config", true)["system"]["mgmtCfg"]["mgmtActivationServer"]
  end

  def cloud_server()
    show_json("running-config", true)["system"]["mgmtCfg"]["mgmtCloudServer"]
  end
end