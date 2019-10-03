module Navigation
  def goto_management()
    cmd('top')
    configure()
    management()
  end

  def top
    cmd('top')
  end

  def configure
    cmd('configure') #{|c| print c}
  end

  def management
    cmd('management')#{|c| print c}
  end
end