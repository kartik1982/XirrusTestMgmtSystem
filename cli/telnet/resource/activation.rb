module Activation
  def activation_done?(wait_time=10)
    top
    configure
    # puts "Waiting 30 seconds to begin checking activation interval"
    sleep 30
    ready_to_move_on = false
    attempts = 0

    while ((ready_to_move_on == false) && attempts < 35)
      interval = show_activation_interval()
      attempts += 1

      if interval.nil?
        throw("Unexpected Error. show man command return null which should't be the case")
      end

      if interval == 20
      ready_to_move_on = true
      else
        puts "- not configured yet. On attempt: #{attempts}"
        sleep wait_time
      end
    end

    ready_to_move_on
  end

  def set_offline(env='test03')
    cmd('top')
    configure()
    management()
    cmd('activation stop')
    cmd('activation interval 1')
    cmd('cloud off')
    cmd('save')
    cmd('exit')
  end

  def activate(env='test03')
    goto_management()
    cmd('cloud off')
    cmd("activation stop")
    set_activation_url(env)
    start_activation(true)
  end

  def start_activation(already_in_management=nil)
    goto_management() unless already_in_management
    cmd('activation interval 1')
    cmd('cloud on')
    cmd('activation start')
    cmd('save')
    cmd('exit')
  end

  def set_activation_url(env, times=1, url=nil)
    url = url || ACTIVATION_URL.gsub("env", env)
    times.times{ cmd("Activation Server #{url}") }
  end

  def activation_server()
    show_management().select{|s| s.start_with?("Activation Server")}.first
  end

  def cloud_server()
    show_management().select{|s| s.start_with?("Cloud Server")}.first
  end
end