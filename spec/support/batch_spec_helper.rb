module BatchSpecHelper
  def suppress_puts
    allow($stdout).to receive(:puts)
  end
end
